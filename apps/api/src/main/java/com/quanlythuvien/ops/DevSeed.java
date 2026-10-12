package com.quanlythuvien.ops;

import com.quanlythuvien.identity.ReaderProfile;
import com.quanlythuvien.identity.ReaderProfileRepository;
import com.quanlythuvien.identity.UserAccount;
import com.quanlythuvien.identity.UserAccountRepository;
import com.quanlythuvien.shared.Role;
import com.quanlythuvien.shared.UserStatus;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.Clock;
import java.time.LocalDateTime;

@Component
@ConditionalOnProperty(name = "app.seed", havingValue = "true")
public class DevSeed implements ApplicationRunner {

    private final UserAccountRepository users;
    private final ReaderProfileRepository profiles;
    private final PasswordEncoder passwordEncoder;
    private final Clock clock;
    private final String password;

    public DevSeed(UserAccountRepository users, ReaderProfileRepository profiles, PasswordEncoder passwordEncoder,
                   Clock clock, @Value("${app.seed-password}") String password) {
        this.users = users;
        this.profiles = profiles;
        this.passwordEncoder = passwordEncoder;
        this.clock = clock;
        this.password = password;
    }

    @Override
    /** Tạo sẵn ba tài khoản demo nếu chưa có. Chỉ chạy khi bật seed. */
    public void run(ApplicationArguments args) {
        if (users.existsByEmail("admin@library.local")) {
            return;
        }
        save("admin@library.local", "Thủ thư", Role.LIBRARIAN, UserStatus.ACTIVE, null);
        save("librarian@library.local", "Nhân viên", Role.STAFF, UserStatus.ACTIVE, null);
        UserAccount reader = save("reader@library.local", "Người đọc", Role.READER, UserStatus.ACTIVE, "R10000001");
        ReaderProfile profile = new ReaderProfile();
        profile.setUserId(reader.getId());
        profile.setCardCode("R10000001");
        profiles.save(profile);
    }

    /** Lưu một tài khoản demo. */
    private UserAccount save(String email, String name, Role role, UserStatus status, String ignoredCard) {
        UserAccount user = new UserAccount();
        user.setEmail(email);
        user.setDisplayName(name);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setRole(role);
        user.setStatus(status);
        user.setCreatedAt(LocalDateTime.now(clock));
        return users.save(user);
    }
}
