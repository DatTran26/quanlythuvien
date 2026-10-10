package com.quanlythuvien.report;

import com.lowagie.text.Document;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.quanlythuvien.catalog.BookCopyRepository;
import com.quanlythuvien.circulation.Loan;
import com.quanlythuvien.circulation.LoanRepository;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class ReportService {

    private final LoanRepository loans;
    private final BookCopyRepository copies;

    public ReportService(LoanRepository loans, BookCopyRepository copies) {
        this.loans = loans;
        this.copies = copies;
    }

    /** Lấy các phiếu đang quá hạn. */
    public List<Loan> overdue() {
        return loans.findOverdue();
    }

    /** Đếm số bản sao theo trạng thái. */
    public List<Object[]> inventory() {
        return copies.countByStatus();
    }

    /** Đếm mượn và trả trong khoảng ngày. */
    public Map<String, Long> trends(LocalDate from, LocalDate to) {
        LocalDateTime start = from.atStartOfDay();
        LocalDateTime end = to.plusDays(1).atStartOfDay();
        Map<String, Long> result = new LinkedHashMap<>();
        result.put("loans", (long) loans.findByBorrowedAtBetween(start, end).size());
        result.put("returns", (long) loans.findByReturnedAtBetween(start, end).size());
        return result;
    }

    /** Xuất danh sách quá hạn thành file Excel. */
    public byte[] overdueExcel() throws IOException {
        try (XSSFWorkbook workbook = new XSSFWorkbook(); ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            var sheet = workbook.createSheet("qua-han");
            var header = sheet.createRow(0);
            header.createCell(0).setCellValue("doc_gia");
            header.createCell(1).setCellValue("sach");
            header.createCell(2).setCellValue("han");
            int rowIndex = 1;
            for (Loan loan : overdue()) {
                var row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(loan.getReader().getDisplayName());
                row.createCell(1).setCellValue(loan.getTitle().getName());
                row.createCell(2).setCellValue(loan.getDueAt().toString());
            }
            workbook.write(output);
            return output.toByteArray();
        }
    }

    /** Xuất danh sách quá hạn thành file PDF. */
    public byte[] overduePdf() throws IOException {
        try (ByteArrayOutputStream output = new ByteArrayOutputStream()) {
            Document document = new Document();
            PdfWriter.getInstance(document, output);
            document.open();
            document.add(new Paragraph("Danh sach qua han"));
            PdfPTable table = new PdfPTable(3);
            table.addCell("Doc gia");
            table.addCell("Sach");
            table.addCell("Han");
            for (Loan loan : overdue()) {
                table.addCell(loan.getReader().getDisplayName());
                table.addCell(loan.getTitle().getName());
                table.addCell(loan.getDueAt().toLocalDate().toString());
            }
            document.add(table);
            document.close();
            return output.toByteArray();
        }
    }
}
