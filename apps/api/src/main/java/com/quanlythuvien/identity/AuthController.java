package com.quanlythuvien.identity;

import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "identity")
@RestController
@RequestMapping("/api")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    /** Đăng nhập bằng email và mật khẩu, trả về token. */
    @PostMapping("/auth/login")
    AuthService.TokenResponse login(@Valid @RequestBody AuthService.LoginRequest request) {
        return authService.login(request);
    }

    /** Người đọc tự đăng ký. Tài khoản ở trạng thái chờ kích hoạt, chưa được mượn. */
    @PostMapping("/auth/register")
    AuthService.MeResponse register(@Valid @RequestBody AuthService.RegisterRequest request) {
        return authService.register(request);
    }

    /** Xem thông tin tài khoản đang đăng nhập. */
    @GetMapping("/me")
    AuthService.MeResponse me() {
        return authService.me();
    }

    /** Kiểm tra quyền quản trị. Người đọc gọi sẽ bị từ chối. */
    @GetMapping("/admin/ping")
    @PreAuthorize("hasRole('ADMIN')")
    String ping() {
        return "ok";
    }

    /** Quản trị viên tạo tài khoản thủ thư. */
    @PostMapping("/admin/staff")
    @PreAuthorize("hasRole('ADMIN')")
    AuthService.MeResponse createStaff(@Valid @RequestBody AuthService.CreateStaffRequest request) {
        return authService.createLibrarian(request);
    }

    /** Quản trị viên khóa hoặc mở lại tài khoản. Không khóa chính mình. */
    @PatchMapping("/admin/users/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    AuthService.MeResponse status(@PathVariable long id, @Valid @RequestBody AuthService.StatusRequest request) {
        return authService.setStatus(id, request.status());
    }

    /** Thủ thư kích hoạt người đọc để họ được mượn sách. */
    @PostMapping("/readers/{id}/activate")
    @PreAuthorize("hasAnyRole('LIBRARIAN','ADMIN')")
    AuthService.MeResponse activate(@PathVariable long id) {
        return authService.activateReader(id);
    }

    /** Tìm người đọc theo mã thẻ, dùng khi quét QR thẻ tại quầy. */
    @GetMapping("/readers/by-card/{code}")
    @PreAuthorize("hasAnyRole('LIBRARIAN','ADMIN')")
    AuthService.MeResponse byCard(@PathVariable String code) {
        ReaderProfile profile = authService.profileByCard(code);
        return authService.publicMe(profile.getUserId());
    }
}
