package com.quanlythuvien;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.quanlythuvien.fine.FineRepository;
import com.quanlythuvien.identity.UserAccount;
import com.quanlythuvien.identity.UserAccountRepository;
import com.quanlythuvien.shared.Role;
import com.quanlythuvien.shared.UserStatus;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.jupiter.api.Test;
import jakarta.persistence.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class LibraryApiTest {

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired UserAccountRepository users;
    @Autowired PasswordEncoder encoder;
    @Autowired FineRepository fines;
    @Autowired EntityManager entityManager;

    @Test
    void healthIsPublic() throws Exception {
        mvc.perform(get("/api/health")).andExpect(status().isOk());
    }

    @Test
    void staffKeepsCounterAccessWithoutManagementAccess() throws Exception {
        String email = unique("staff");
        user(email, Role.STAFF, UserStatus.ACTIVE);
        String token = login(email);
        mvc.perform(get("/api/policy").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mvc.perform(get("/api/admin/ping").header("Authorization", "Bearer " + token))
                .andExpect(status().isForbidden());
        mvc.perform(post("/api/admin/staff").header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(java.util.Map.of(
                                "email", unique("newstaff"), "password", "Dev123456", "displayName", "Nhân viên"))))
                .andExpect(status().isForbidden());
    }

    @Test
    void librarianCreatesStaffWithOriginalRoleCode() throws Exception {
        String email = unique("librarian");
        user(email, Role.LIBRARIAN, UserStatus.ACTIVE);
        String token = login(email);
        mvc.perform(get("/api/admin/ping").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        MvcResult result = mvc.perform(post("/api/admin/staff")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(java.util.Map.of(
                                "email", unique("newstaff"), "password", "Dev123456", "displayName", "Nhân viên"))))
                .andExpect(status().isOk()).andReturn();
        assertEquals("STAFF", json.readTree(result.getResponse().getContentAsString()).get("role").asText());
    }

    @Test
    void readerCannotCallAdminPing() throws Exception {
        String email = unique("reader");
        long id = user(email, Role.READER, UserStatus.ACTIVE);
        String token = login(email);
        mvc.perform(get("/api/me").header("Authorization", "Bearer " + token))
                .andExpect(status().isOk());
        mvc.perform(get("/api/admin/ping").header("Authorization", "Bearer " + token))
                .andExpect(status().isForbidden());
        assertTrue(id > 0);
    }

    @Test
    void secondLoanOfSameCopyIsRejected() throws Exception {
        String admin = unique("admin");
        user(admin, Role.LIBRARIAN, UserStatus.ACTIVE);
        String readerEmail = unique("member");
        long readerId = user(readerEmail, Role.READER, UserStatus.ACTIVE);
        String token = login(admin);
        long titleId = createTitle(token, "Sách " + readerEmail);
        String code = "C-" + UUID.randomUUID().toString().substring(0, 8);
        mvc.perform(post("/api/titles/" + titleId + "/copies")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"code\":\"" + code + "\",\"shelf\":\"A1\"}"))
                .andExpect(status().isOk());
        mvc.perform(post("/api/loans")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"readerId\":" + readerId + ",\"copyCode\":\"" + code + "\"}"))
                .andExpect(status().isOk());
        mvc.perform(post("/api/loans")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"readerId\":" + readerId + ",\"copyCode\":\"" + code + "\"}"))
                .andExpect(status().isConflict());
    }

    @Test
    @Transactional
    void overdueReturnCreatesOneFineAndBlocksNextLoan() throws Exception {
        String admin = unique("admin");
        user(admin, Role.LIBRARIAN, UserStatus.ACTIVE);
        long readerId = user(unique("member"), Role.READER, UserStatus.ACTIVE);
        String token = login(admin);
        long titleId = createTitle(token, "Trễ hạn");
        String code = "D-" + UUID.randomUUID().toString().substring(0, 8);
        mvc.perform(post("/api/titles/" + titleId + "/copies")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"code\":\"" + code + "\"}"))
                .andExpect(status().isOk());
        MvcResult loan = mvc.perform(post("/api/loans")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"readerId\":" + readerId + ",\"copyCode\":\"" + code + "\"}"))
                .andExpect(status().isOk())
                .andReturn();
        long loanId = json.readTree(loan.getResponse().getContentAsString()).get("id").asLong();
        entityManager.createQuery("update Loan l set l.dueAt = :due where l.id = :id")
                .setParameter("due", LocalDateTime.now().minusDays(2))
                .setParameter("id", loanId)
                .executeUpdate();
        entityManager.flush();
        entityManager.clear();
        mvc.perform(post("/api/loans/" + loanId + "/return")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"damaged\":false}"))
                .andExpect(status().isOk());
        assertEquals(1, fines.findByReaderIdOrderByCreatedAtDesc(readerId).size());
        String second = "E-" + UUID.randomUUID().toString().substring(0, 8);
        mvc.perform(post("/api/titles/" + titleId + "/copies")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"code\":\"" + second + "\"}"))
                .andExpect(status().isOk());
        mvc.perform(post("/api/loans")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"readerId\":" + readerId + ",\"copyCode\":\"" + second + "\"}"))
                .andExpect(status().isConflict());
    }

    @Test
    void dryRunDoesNotWriteInvalidSheet() throws Exception {
        String admin = unique("admin");
        user(admin, Role.LIBRARIAN, UserStatus.ACTIVE);
        String token = login(admin);
        byte[] workbook = sheetWithBlankPrice();
        MockMultipartFile file = new MockMultipartFile("file", "bad.xlsx",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", workbook);
        MvcResult result = mvc.perform(multipart("/api/import/titles/dry-run").file(file)
                        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andReturn();
        JsonNode body = json.readTree(result.getResponse().getContentAsString());
        assertTrue(body.get("errors").size() > 0);
    }

    private long createTitle(String token, String name) throws Exception {
        MvcResult result = mvc.perform(post("/api/titles")
                        .header("Authorization", "Bearer " + token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"name\":\"" + name + "\",\"author\":\"Tác giả\",\"priceVnd\":50000,\"loanable\":true}"))
                .andExpect(status().isOk())
                .andReturn();
        return json.readTree(result.getResponse().getContentAsString()).get("id").asLong();
    }

    private String login(String email) throws Exception {
        MvcResult result = mvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"" + email + "\",\"password\":\"Dev123456\"}"))
                .andExpect(status().isOk())
                .andReturn();
        return json.readTree(result.getResponse().getContentAsString()).get("accessToken").asText();
    }

    private long user(String email, Role role, UserStatus status) {
        UserAccount user = new UserAccount();
        user.setEmail(email);
        user.setDisplayName(email);
        user.setPasswordHash(encoder.encode("Dev123456"));
        user.setRole(role);
        user.setStatus(status);
        user.setCreatedAt(LocalDateTime.now());
        return users.save(user).getId();
    }

    private static String unique(String prefix) {
        return prefix + "+" + UUID.randomUUID() + "@library.test";
    }

    private static byte[] sheetWithBlankPrice() throws Exception {
        try (XSSFWorkbook workbook = new XSSFWorkbook(); ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            var sheet = workbook.createSheet();
            var header = sheet.createRow(0);
            header.createCell(0).setCellValue("ten");
            var row = sheet.createRow(1);
            row.createCell(0).setCellValue("Sách");
            row.createCell(1).setCellValue("Tác giả");
            row.createCell(5).setCellValue("COPY-1");
            workbook.write(output);
            return output.toByteArray();
        }
    }
}
