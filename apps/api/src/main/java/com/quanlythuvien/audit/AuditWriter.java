package com.quanlythuvien.audit;

import org.springframework.stereotype.Service;

import java.time.Clock;
import java.time.LocalDateTime;

@Service
public class AuditWriter {

    private final AuditLogRepository logs;
    private final Clock clock;

    public AuditWriter(AuditLogRepository logs, Clock clock) {
        this.logs = logs;
        this.clock = clock;
    }

    /** Ghi một dòng nhật ký: ai làm gì, trên bản ghi nào. */
    public void record(Long actorId, String action, String entityType, String entityId, String detail) {
        AuditLog log = new AuditLog();
        log.setActorId(actorId);
        log.setAction(action);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setDetail(detail);
        log.setCreatedAt(LocalDateTime.now(clock));
        logs.save(log);
    }
}
