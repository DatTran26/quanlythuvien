package com.quanlythuvien.config;

import com.quanlythuvien.shared.ApiException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.orm.ObjectOptimisticLockingFailureException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;

@RestControllerAdvice
public class ApiExceptionHandler {

    /** Trả lỗi nghiệp vụ đúng mã HTTP. */
    @ExceptionHandler(ApiException.class)
    ResponseEntity<Map<String, String>> api(ApiException ex) {
        return ResponseEntity.status(ex.getStatus()).body(Map.of("code", ex.getCode(), "message", ex.getMessage()));
    }

    /** Hai người sửa cùng một bản sao thì người sau nhận lỗi sách vừa được cập nhật. */
    @ExceptionHandler(ObjectOptimisticLockingFailureException.class)
    ResponseEntity<Map<String, String>> stale() {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(Map.of("code", "STALE_COPY", "message", "Sách vừa được cập nhật"));
    }

    /** Dữ liệu trùng hoặc vi phạm ràng buộc thì trả lỗi xung đột. */
    @ExceptionHandler(DataIntegrityViolationException.class)
    ResponseEntity<Map<String, String>> conflict() {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(Map.of("code", "CONFLICT", "message", "Dữ liệu bị trùng hoặc không còn hợp lệ"));
    }

    /** Body gửi lên thiếu hoặc sai định dạng thì trả 400. */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    ResponseEntity<Map<String, String>> invalid(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(error -> error.getField() + " không hợp lệ")
                .orElse("Dữ liệu không hợp lệ");
        return ResponseEntity.badRequest().body(Map.of("code", "VALIDATION", "message", message));
    }
}
