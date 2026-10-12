package com.quanlythuvien.config;

import com.quanlythuvien.shared.Role;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.Test;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class JwtServiceTest {
    private static final String SECRET = "test-secret-test-secret-test-secret-32";
    private final JwtService jwt = new JwtService(SECRET, 60);

    @Test
    void issuesTokensWithOriginalBusinessRoles() {
        for (Role role : Role.values()) {
            var claims = jwt.parse(jwt.issue("member@library.test", role));
            assertEquals(role.name(), claims.get("role", String.class));
        }
    }

    @Test
    void rejectsOldCounterTokensInsteadOfGrantingLibrarianPermissions() {
        String oldToken = Jwts.builder()
                .subject("counter@library.test")
                .claim("role", "LIBRARIAN")
                .expiration(Date.from(Instant.now().plusSeconds(600)))
                .signWith(Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8)))
                .compact();
        assertThrows(JwtException.class, () -> jwt.parse(oldToken));
    }
}
