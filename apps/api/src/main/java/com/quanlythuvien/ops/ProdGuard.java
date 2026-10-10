package com.quanlythuvien.ops;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("prod")
public class ProdGuard implements ApplicationRunner {

    private final boolean seed;
    private final String jwtSecret;

    public ProdGuard(@Value("${app.seed}") boolean seed, @Value("${app.jwt.secret}") String jwtSecret) {
        this.seed = seed;
        this.jwtSecret = jwtSecret;
    }

    @Override
    /** Chặn chạy production nếu còn bật seed hoặc còn dùng mật khẩu JWT mẫu. */
    public void run(ApplicationArguments args) {
        if (seed) {
            throw new IllegalStateException("APP_SEED phải tắt khi chạy profile prod");
        }
        if (jwtSecret.contains("dev-only") || jwtSecret.contains("local-compose") || jwtSecret.contains("test-secret")) {
            throw new IllegalStateException("JWT_SECRET production không được dùng giá trị mẫu");
        }
    }
}
