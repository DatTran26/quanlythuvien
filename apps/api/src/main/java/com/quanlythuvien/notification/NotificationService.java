package com.quanlythuvien.notification;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.LocalDateTime;

@Service
public class NotificationService {

    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);

    private final AppNotificationRepository notifications;
    private final Clock clock;

    public NotificationService(AppNotificationRepository notifications, Clock clock) {
        this.notifications = notifications;
        this.clock = clock;
    }

    /** Lưu thông báo trong app. Gửi email lỗi cũng không làm hỏng nghiệp vụ. */
    public void notify(Long userId, String title, String body) {
        AppNotification notification = new AppNotification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setBody(body);
        notification.setCreatedAt(LocalDateTime.now(clock));
        notifications.save(notification);
        trySendMail(userId, title);
    }

    /** Chỗ gửi email. Hiện chỉ ghi log, lỗi thì bỏ qua. */
    private void trySendMail(Long userId, String title) {
        try {
            log.info("email skipped for user {} event {}", userId, title);
        } catch (RuntimeException ex) {
            log.warn("email failed for user {}: {}", userId, ex.getMessage());
        }
    }
}
