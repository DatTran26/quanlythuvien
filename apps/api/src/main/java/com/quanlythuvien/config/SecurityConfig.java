package com.quanlythuvien.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.beans.factory.annotation.Value;

import java.util.Map;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    /** Chặn API: đường công khai thì mở, còn lại phải có token đúng vai trò. */
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthFilter jwtAuthFilter, ObjectMapper objectMapper)
            throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/api/health",
                                "/api/auth/login",
                                "/api/auth/register",
                                "/v3/api-docs/**",
                                "/swagger-ui/**",
                                "/swagger-ui.html")
                        .permitAll()
                        .anyRequest()
                        .authenticated())
                .exceptionHandling(errors -> errors
                        .authenticationEntryPoint((request, response, ex) -> write(objectMapper, response, 401, "UNAUTHENTICATED", "Cần đăng nhập"))
                        .accessDeniedHandler((request, response, ex) -> write(objectMapper, response, 403, "FORBIDDEN", "Không đủ quyền")))
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    /** Cách băm mật khẩu trước khi lưu. */
    @Bean
    PasswordEncoder passwordEncoder(@Value("${app.bcrypt-strength}") int strength) {
        return new BCryptPasswordEncoder(strength);
    }

    /** Ghi lỗi đăng nhập hoặc thiếu quyền ra JSON. */
    private static void write(ObjectMapper objectMapper, jakarta.servlet.http.HttpServletResponse response,
                              int status, String code, String message) throws java.io.IOException {
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        objectMapper.writeValue(response.getOutputStream(), Map.of("code", code, "message", message));
    }
}
