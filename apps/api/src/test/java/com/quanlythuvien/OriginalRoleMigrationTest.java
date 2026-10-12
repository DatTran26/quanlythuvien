package com.quanlythuvien;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;

import java.sql.DriverManager;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;

class OriginalRoleMigrationTest {
    @Test
    void preservesAccountsAndPermissionsWhenMigratingExistingRoles() throws Exception {
        String url = "jdbc:h2:mem:roles-" + UUID.randomUUID()
                + ";MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1";
        Flyway.configure().dataSource(url, "sa", "").target("3").load().migrate();
        try (var connection = DriverManager.getConnection(url, "sa", "");
             var statement = connection.createStatement()) {
            statement.executeUpdate("""
                    insert into app_user (email, password_hash, role, status, display_name, created_at) values
                    ('admin@library.local', 'hash', 'ADMIN', 'ACTIVE', 'Quản trị viên', current_timestamp),
                    ('librarian@library.local', 'hash', 'LIBRARIAN', 'ACTIVE', 'Thủ thư', current_timestamp),
                    ('reader@library.local', 'hash', 'READER', 'ACTIVE', 'Người đọc', current_timestamp),
                    ('manager@library.test', 'hash', 'ADMIN', 'LOCKED', 'Nguyễn An', current_timestamp),
                    ('counter@library.test', 'hash', 'LIBRARIAN', 'ACTIVE', 'Trần Bình', current_timestamp)
                    """);
        }
        var flyway = Flyway.configure().dataSource(url, "sa", "").load();
        flyway.migrate();
        // Repeated application startup must not map the new librarian back to staff.
        flyway.migrate();
        try (var connection = DriverManager.getConnection(url, "sa", "");
             var statement = connection.createStatement();
             var rows = statement.executeQuery("""
                     select u.role, u.display_name, u.status, b.previous_role, b.previous_display_name
                     from app_user u join app_user_role_backup b on b.user_id = u.id order by u.id
                     """)) {
            String[][] expected = {
                    {"LIBRARIAN", "Thủ thư", "ACTIVE", "ADMIN", "Quản trị viên"},
                    {"STAFF", "Nhân viên", "ACTIVE", "LIBRARIAN", "Thủ thư"},
                    {"READER", "Người đọc", "ACTIVE", "READER", "Người đọc"},
                    {"LIBRARIAN", "Nguyễn An", "LOCKED", "ADMIN", "Nguyễn An"},
                    {"STAFF", "Trần Bình", "ACTIVE", "LIBRARIAN", "Trần Bình"}
            };
            int count = 0;
            while (rows.next()) {
                for (int column = 0; column < expected[count].length; column++) {
                    assertEquals(expected[count][column], rows.getString(column + 1));
                }
                count++;
            }
            assertEquals(expected.length, count);
        }
    }
}
