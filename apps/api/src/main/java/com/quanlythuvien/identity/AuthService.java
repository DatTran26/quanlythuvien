package com.quanlythuvien.identity;

import com.quanlythuvien.config.JwtService;
import com.quanlythuvien.shared.ApiException;
import com.quanlythuvien.shared.CurrentUser;
import com.quanlythuvien.shared.Role;
import com.quanlythuvien.shared.UserStatus;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.LocalDateTime;
import java.util.Locale;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class AuthService {

    private final UserAccountRepository users;
    private final ReaderProfileRepository profiles;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final Clock clock;

    public AuthService(UserAccountRepository users, ReaderProfileRepository profiles,
                       PasswordEncoder passwordEncoder, JwtService jwtService, Clock clock) {
        this.users = users;
        this.profiles = profiles;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.clock = clock;
    }

    /** Kiểm tra mật khẩu và cấp token. Tài khoản bị khóa thì không vào được. */
    public TokenResponse login(LoginRequest request) {
        UserAccount user = users.findByEmail(normalize(request.email()))
                .filter(found -> passwordEncoder.matches(request.password(), found.getPasswordHash()))
                .orElseThrow(() -> ApiException.badRequest("BAD_CREDENTIALS", "Email hoặc mật khẩu không đúng"));
        if (user.getStatus() == UserStatus.LOCKED) {
            throw ApiException.conflict("LOCKED", "Tài khoản đang bị khóa");
        }
        return new TokenResponse(jwtService.issue(user.getEmail(), user.getRole()), "Bearer", jwtService.ttlSeconds(), user.getRole().name());
    }

    @Transactional
    /** Tạo người đọc ở trạng thái chờ và sinh mã thẻ. */
    public MeResponse register(RegisterRequest request) {
        String email = normalize(request.email());
        if (users.existsByEmail(email)) {
            throw ApiException.conflict("EMAIL_TAKEN", "Email đã được đăng ký");
        }
        UserAccount user = newAccount(email, request.password(), request.displayName(), Role.READER, UserStatus.PENDING);
        users.save(user);
        ReaderProfile profile = new ReaderProfile();
        profile.setUserId(user.getId());
        profile.setCardCode(newCardCode());
        profiles.save(profile);
        return me(user);
    }

    /** Lấy hồ sơ của người đang đăng nhập. */
    public MeResponse me() {
        return me(requireCurrent());
    }

    @Transactional
    /** Tạo tài khoản nhân viên đang hoạt động. */
    public MeResponse createStaff(CreateStaffRequest request) {
        String email = normalize(request.email());
        if (users.existsByEmail(email)) {
            throw ApiException.conflict("EMAIL_TAKEN", "Email đã được đăng ký");
        }
        UserAccount user = newAccount(email, request.password(), request.displayName(), Role.STAFF, UserStatus.ACTIVE);
        return me(users.save(user));
    }

    @Transactional
    /** Đổi trạng thái tài khoản. Không khóa chính mình, không đụng thủ thư khác. */
    public MeResponse setStatus(long userId, UserStatus status) {
        UserAccount actor = requireCurrent();
        UserAccount target = users.findById(userId).orElseThrow(() -> ApiException.notFound("Không thấy tài khoản"));
        if (actor.getId().equals(target.getId())) {
            throw ApiException.conflict("SELF_LOCK", "Không khóa chính tài khoản đang dùng");
        }
        if (target.getRole() == Role.LIBRARIAN) {
            throw ApiException.conflict("LIBRARIAN_PROTECTED", "Không đổi trạng thái thủ thư khác");
        }
        target.setStatus(status);
        return me(target);
    }

    @Transactional
    /** Bật trạng thái hoạt động cho người đọc. */
    public MeResponse activateReader(long userId) {
        UserAccount target = users.findById(userId).orElseThrow(() -> ApiException.notFound("Không thấy người đọc"));
        if (target.getRole() != Role.READER) {
            throw ApiException.badRequest("NOT_READER", "Chỉ kích hoạt tài khoản người đọc");
        }
        target.setStatus(UserStatus.ACTIVE);
        return me(target);
    }

    /** Lấy tài khoản từ token. Không thấy thì báo lỗi. */
    public UserAccount requireCurrent() {
        return users.findByEmail(CurrentUser.email()).orElseThrow(() -> ApiException.notFound("Không thấy tài khoản"));
    }

    /** Tìm hồ sơ thẻ theo mã. */
    public ReaderProfile profileByCard(String code) {
        return profiles.findByCardCode(code.trim()).orElseThrow(() -> ApiException.notFound("Không thấy thẻ người đọc"));
    }

    /** Trả thông tin công khai của một tài khoản, không kèm mật khẩu. */
    public MeResponse publicMe(long userId) {
        return me(users.findById(userId).orElseThrow(() -> ApiException.notFound("Không thấy tài khoản")));
    }

    /** Lấy tài khoản và kiểm tra đúng là người đọc. */
    public UserAccount requireReader(long readerId) {
        UserAccount reader = users.findById(readerId).orElseThrow(() -> ApiException.notFound("Không thấy người đọc"));
        if (reader.getRole() != Role.READER) {
            throw ApiException.badRequest("NOT_READER", "Tài khoản không phải người đọc");
        }
        return reader;
    }

    /** Tạo tài khoản mới, mật khẩu được băm trước khi lưu. */
    private UserAccount newAccount(String email, String password, String displayName, Role role, UserStatus status) {
        UserAccount user = new UserAccount();
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setDisplayName(displayName.trim());
        user.setRole(role);
        user.setStatus(status);
        user.setCreatedAt(LocalDateTime.now(clock));
        return user;
    }

    /** Sinh mã thẻ chưa trùng. */
    private String newCardCode() {
        for (int i = 0; i < 5; i++) {
            String code = "R" + ThreadLocalRandom.current().nextInt(10000000, 99999999);
            if (profiles.findByCardCode(code).isEmpty()) {
                return code;
            }
        }
        throw ApiException.conflict("CARD_CODE", "Không sinh được mã thẻ");
    }

    /** Đổi tài khoản thành dữ liệu trả về cho client. */
    private static MeResponse me(UserAccount user) {
        return new MeResponse(user.getId(), user.getEmail(), user.getDisplayName(), user.getRole().name(), user.getStatus().name());
    }

    /** Viết thường và bỏ khoảng trắng đầu cuối của email. */
    public static String normalize(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }

    public record LoginRequest(@Email @NotBlank String email, @NotBlank String password) {
    }

    public record RegisterRequest(
            @Email @NotBlank String email,
            @NotBlank @Size(min = 8, max = 72) String password,
            @NotBlank @Size(max = 120) String displayName) {
    }

    public record CreateStaffRequest(
            @Email @NotBlank String email,
            @NotBlank @Size(min = 8, max = 72) String password,
            @NotBlank @Size(max = 120) String displayName) {
    }

    public record StatusRequest(@NotNull UserStatus status) {
    }

    public record TokenResponse(String accessToken, String tokenType, long expiresInSeconds, String role) {
    }

    public record MeResponse(long id, String email, String displayName, String role, String status) {
    }
}
