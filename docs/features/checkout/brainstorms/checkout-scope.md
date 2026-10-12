---
type: brainstorm
feature: checkout
status: draft
updated: 2026-10-12
links:
  - docs/_product/prd.md
  - docs/_product/product-roadmap-baseline.md
  - docs/_shared/core-spec.md
  - docs/_shared/domain/lifecycle-inventory.md
  - docs/_shared/domain/library-states.md
  - docs/_shared/id-crosswalk-lmp.md
---

# Mượn sách tại quầy

## 1. Idea Seed

Nhân viên quét thẻ người đọc và từng cuốn sách tại quầy; hệ thống kiểm tra điều kiện ngay khi quét và ghi toàn bộ phiếu mượn trong một lần xác nhận, không để hai người cùng giữ một bản sao, rồi in biên nhận cho người đọc.

## 2. Context

- Quầy mượn thủ công dễ nhầm sách, nhầm người đọc và nhầm trạng thái; đây là giao dịch chính của thư viện và là lý do số hóa bằng QR.
- Pilot chạy ở một cơ sở với hai quầy, nên hai quầy có thể cùng xử lý một bản sao.
- Feature cần dữ liệu đã sẵn sàng từ R0: tài khoản và phân quyền (`access-control`), đầu sách (`catalog-admin`), bản sao có QR (`copy-inventory`), tham số mượn (`policy-config`). Chặn mượn vì nợ phạt chỉ bật sau khi job quá hạn và sổ phạt (`overdue-fines`) đã chạy.
- Nhận sách đã đặt trước đi qua quầy mượn nhưng chỉ có từ R2 (`reservation`); ở R1A chưa có bản sao nào ở trạng thái Đang giữ.

## 3. User Types (preliminary)

| User Type | Pain Point | Primary Need |
|-----------|-----------|--------------|
| Nhân viên (trực quầy) | Tra tay từng cuốn, dễ ghi nhầm, không biết người đọc đang nợ hay quá hạn | Quét là biết được mượn hay không, xác nhận một lần cho cả giỏ |
| Người đọc | Chờ lâu, bị ghi mượn nhầm hoặc trùng phiếu | Mượn nhanh, có biên nhận ghi rõ hạn trả |
| Thủ thư trưởng | Không chắc mỗi bản sao chỉ một người giữ | 0 phiếu mở trùng một bản sao, mọi giao dịch có dấu vết |

## 4. Capabilities Breakdown

### P0 — must have

- Quét QR thẻ để tìm người đọc; nhập mã tay khi QR mờ. Mã quét chỉ dùng để tìm bản ghi, không thay cho kiểm tra quyền.
- Kiểm tra 3 điều kiện chặn mượn ngay khi quét thẻ: tài khoản bị khóa hoặc chưa kích hoạt, đang có sách quá hạn, nợ phạt vượt ngưỡng; cộng với hạn mức số cuốn đang mượn.
- Quét từng bản sao, kiểm tra ngay: bản sao đang Sẵn sàng và được phép cho mượn, không trùng trong giỏ, không trùng đầu sách người đọc đang mượn, không vượt hạn mức.
- Rà soát giỏ với hạn trả dự kiến trước khi xác nhận.
- Ghi cả giỏ trong một lần: hoặc tất cả cuốn được ghi mượn, hoặc không cuốn nào.
- Chống ghi trùng khi bấm xác nhận lặp hoặc mất mạng sau khi xác nhận.
- Hai quầy cùng xử lý một bản sao: chỉ thao tác hợp lệ đầu tiên thành công, quầy sau thấy trạng thái mới.
- In biên nhận ngay sau khi mượn, gộp các cuốn theo thời điểm tạo. Biên nhận gồm: tên thư viện, mã phiếu, ngày giờ mượn; tên và mã thẻ người đọc; danh sách cuốn (tên sách, mã bản sao) kèm hạn trả từng cuốn; Nhân viên thực hiện.
- Ghi dấu vết (audit) và phát sự kiện thông báo hạn trả trong cùng giao dịch.

### P1 — should have

- Không có trong feature này.

### P2 — nice to have

- Không có. Nhận sách đã đặt trước thuộc `reservation` (R2); cho mượn ngoại lệ khi người đọc không đủ điều kiện không làm.

## 5. Core Flows (Happy Path)

### 5.1 Mượn sách tại quầy

1) Nhân viên mở quầy lưu thông, chọn bắt đầu mượn.
2) Nhân viên quét QR thẻ người đọc; hệ thống tìm người đọc, nạp tình trạng tài khoản, sách đang mượn và công nợ.
3) Hệ thống kiểm tra điều kiện mượn (D1). Không đủ thì dừng và nêu lý do cụ thể.
4) Nhân viên quét từng cuốn; hệ thống kiểm tra từng cuốn ngay khi thêm (D2). Cuốn lỗi không vào giỏ, các cuốn hợp lệ giữ nguyên.
5) Hệ thống hiển thị màn rà soát: danh sách cuốn và hạn trả dự kiến.
6) Nhân viên xác nhận; hệ thống ghi toàn bộ giỏ trong một giao dịch: tạo phiếu mượn cho từng cuốn, chuyển bản sao sang Đang mượn, ghi audit, phát sự kiện thông báo.
7) Hệ thống hiển thị "Đã tạo phiếu mượn…" và in biên nhận.

```
Nhân viên quét thẻ ──> Tìm người đọc ──không thấy──> "Không tìm thấy người đọc với mã này" → quét lại / nhập tay
                          │ thấy
                          ▼
              D1: Đủ điều kiện mượn? ──không──> Dừng, nêu lý do (khóa / quá hạn / nợ / hạn mức)
                          │ có
                          ▼
     Nhân viên quét từng cuốn ◄─────────────────────────────┐
                          │                                │
              D2: Cuốn hợp lệ? ──không──> Không thêm, giữ giỏ ┘
                          │ có
                          ▼
                Thêm vào giỏ + hạn trả dự kiến
                          │ (quét xong)
                          ▼
                Rà soát giỏ → Nhân viên xác nhận
                          │
              D3: Lần xác nhận này đã ghi trước đó? ──có──> Trả kết quả đã ghi, không tạo phiếu thứ hai
                          │ chưa
                          ▼
              D4: Mọi cuốn còn đúng trạng thái? ──không──> Hủy cả giỏ → "Sách vừa được cập nhật…" → quét lại
                          │ có
                          ▼
              D5: Ghi được audit? ──không──> Hủy cả giỏ, cảnh báo vận hành
                          │ có
                          ▼
     Ghi phiếu mượn + bản sao Đang mượn + audit + sự kiện thông báo (một giao dịch)
                          │
                          ▼
        "Đã tạo phiếu mượn…" + in biên nhận   (gửi thông báo lỗi → thử lại nền, phiếu vẫn giữ)
```

## 6. System Behavior Deep Dive

### 6.1 Decision Points

| ID | Flow | Khi nào | YES (nhánh đồng ý) | NO (nhánh từ chối) |
|---|---|---|---|---|
| D1 | Mượn | Người đọc đủ điều kiện mượn? (tài khoản đang hoạt động, không có sách quá hạn, nợ trong ngưỡng, chưa đạt hạn mức) | Cho quét sách | Dừng, hiển thị lý do cụ thể và cách khắc phục; không có ngoại lệ |
| D2 | Mượn | Cuốn vừa quét hợp lệ? (Sẵn sàng, được phép cho mượn, không trùng giỏ, không trùng đầu sách đang mượn, còn hạn mức) | Thêm vào giỏ kèm hạn trả dự kiến | Không thêm, báo trạng thái hiện tại, giữ các cuốn hợp lệ |
| D3 | Mượn | Lần xác nhận này đã được ghi trước đó? (bấm lặp, mất mạng sau xác nhận) | Trả lại kết quả đã ghi | Xử lý như lần mới |
| D4 | Mượn | Lúc ghi, mọi cuốn trong giỏ vẫn đúng trạng thái đã kiểm? | Ghi tiếp | Hủy cả giỏ, không cuốn nào được ghi; mở màn xung đột |
| D5 | Mượn | Ghi audit thành công? | Hoàn tất giao dịch | Hủy cả giỏ, cảnh báo vận hành |

### 6.2 Scenario Matrix

| From State | To State | Rule | Action | Result |
|------------|----------|------|--------|--------|
| Người đọc đang hoạt động, không quá hạn, nợ trong ngưỡng, dưới hạn mức | — | D1 = có | Cho quét sách | Vào bước quét sách |
| Tài khoản bị khóa hoặc chưa kích hoạt | — | D1 = không | Dừng | Lý do "tài khoản" + hướng dẫn mở khóa/kích hoạt |
| Có sách quá hạn đang mở | — | D1 = không | Dừng | Lý do "quá hạn" + hướng dẫn trả sách |
| Nợ phạt vượt ngưỡng | — | D1 = không | Dừng | Lý do "công nợ" + hướng dẫn nộp phạt |
| Đạt hạn mức số cuốn | — | D1 = không | Dừng | "Người đọc đã đạt giới hạn 5 cuốn đang mượn." |
| Bản sao Sẵn sàng, được phép cho mượn | Đang mượn | D2 = có, D4 = có | Xác nhận | Phiếu mượn được ghi |
| Bản sao Đang mượn / Chờ duyệt / Đang sửa / Mất / Thanh lý | — | D2 = không | Không thêm | Báo trạng thái hiện tại |
| Bản sao Sẵn sàng nhưng không được phép cho mượn (đọc tại chỗ) | — | D2 = không | Không thêm | Báo không cho mượn về |
| Bản sao Đang giữ cho đặt trước (từ R2) | Đang mượn | Đúng người được giữ | Xác nhận | Thuộc `reservation`, không có ở R1A |

### 6.3 State Transitions

```
Bản sao:   Sẵn sàng ──xác nhận mượn──> Đang mượn
           Đang giữ ──xác nhận mượn đúng người──> Đang mượn   (từ R2)
Phiếu mượn: (chưa có) ──xác nhận mượn──> Đang mở
```

| Entity | Từ | Sang | Trigger | Quay lại được? |
|--------|------|----|---------|-------------|
| Bản sao | Sẵn sàng | Đang mượn | Xác nhận mượn thành công | Có, qua trả sách (`return-handling`) |
| Bản sao | Đang giữ | Đang mượn | Xác nhận mượn đúng người được giữ (R2) | Có, qua trả sách |
| Phiếu mượn | — | Đang mở | Xác nhận mượn thành công | Không mở lại; kết thúc ở trả, mất (`return-handling`, `lost-handling`) |

### 6.4 Interrupted Transactions

| Tình huống | Hệ thống còn lại gì | Resume | Cleanup |
|---|---|---|---|
| Mất kết nối hoặc đóng màn trước khi xác nhận | Không có giao dịch nào | Quét lại hoặc khôi phục giỏ trên máy nếu còn | Không có dữ liệu nghiệp vụ cần xóa |
| Mất kết nối sau khi đã xác nhận | Giao dịch đã ghi hoặc chưa ghi | Tra lại theo lần xác nhận; đã ghi thì hiển thị kết quả, không tạo lần thứ hai | Đối soát các lần xác nhận chưa nhận phản hồi |
| Gửi thông báo hạn trả lỗi | Phiếu mượn đã ghi, sự kiện thông báo nằm trong hàng đợi | Hệ thống tự thử lại | Quá số lần thử thì chuyển hàng lỗi để vận hành xử lý |
| Hai quầy cùng xử lý một bản sao | Chỉ giao dịch ghi trước thành công | Quầy sau tải trạng thái mới, chọn cuốn khác | Không phát sinh hai phiếu mở trên một bản sao |
| Bấm xác nhận lặp | Một giao dịch duy nhất | Lần bấm sau nhận lại kết quả gốc | Không có |

### 6.5 Other Edge Cases

- Quét trùng một cuốn trong cùng giỏ: báo trùng, bỏ qua lần quét sau.
- Mã thẻ hoặc mã sách không tồn tại: báo không tìm thấy, cho quét lại, nhập tay hoặc tra cứu thủ công.
- Xác nhận khi giỏ rỗng hoặc phiếu đã xong: nút xác nhận bị vô hiệu, giải thích trạng thái hiện tại.
- Một cuốn lỗi khi quét: cuốn lỗi bị loại, các cuốn hợp lệ vẫn xác nhận được khi Nhân viên đồng ý. Đây là loại khỏi giỏ trước khi xác nhận, không phải ghi một phần.
- Cấu hình hạn mức/hạn mượn đổi giữa chừng: chỉ áp dụng cho giao dịch bắt đầu sau thời điểm hiệu lực; phiếu đã tạo giữ quy định tại thời điểm mượn.
- Không cho mượn ngoại lệ khi người đọc không đủ điều kiện, kể cả khi Thủ thư có mặt.

## 7. Validation, Limits & Wording

### 7.1 Validation rules

| Field | Rule |
|---|---|
| Mã thẻ người đọc | Bắt buộc; phải tìm được đúng một người đọc |
| Mã bản sao | Bắt buộc; phải tìm được đúng một bản sao |
| Giỏ mượn | Không trùng bản sao; không vượt hạn mức; không trùng đầu sách người đọc đang mượn; ít nhất 1 cuốn mới cho xác nhận |

### 7.2 Limits & Quotas (exact values)

| Tham số | Giá trị | Window | Behavior khi vượt |
|---|---|---|---|
| Sách đang mượn tối đa | 5 bản sao (chốt — DEC-SF-10) | Tại thời điểm xác nhận | Từ chối phần vượt hạn mức |
| Thời hạn mượn | 14 ngày (chốt — DEC-SF-10) | Mỗi phiếu mượn | Tính quá hạn sau thời điểm kết thúc hạn |
| Ngưỡng nợ chặn mượn | 50.000đ (chốt — DEC-SF-10) | Tại thời điểm quét thẻ | Dừng ở D1 |

### 7.3 Wording samples (exact strings)

#### Error messages

| Tình huống | Wording | Code |
|---|---|---|
| Người đọc không đủ điều kiện mượn | "Không thể tạo phiếu mượn. Vui lòng kiểm tra trạng thái thẻ, sách quá hạn và công nợ." | E-core-006 |
| Vượt hạn mức | "Người đọc đã đạt giới hạn 5 cuốn đang mượn." | E-core-006 |
| Mã thẻ không tồn tại | "Không tìm thấy người đọc với mã này" | E-core-003 |
| Mã bản sao không tồn tại | "Không tìm thấy bản sao với mã này" | E-core-003 |
| Bản sao không cho mượn được | "Bản sao này không cho mượn được: {lý do}." | E-checkout-001 |
| Bản sao vừa được xử lý ở quầy khác | "Sách vừa được cập nhật. Vui lòng quét lại để xem trạng thái mới." | E-core-004 |

Lý do theo trạng thái bản sao:

| Trạng thái | {lý do} |
|---|---|
| Đang mượn | "đang được mượn" |
| Chờ duyệt | "đang chờ duyệt hư hỏng" |
| Đang sửa | "đang sửa chữa" |
| Mất | "đã báo mất" |
| Thanh lý | "đã thanh lý" |
| Đang giữ cho người đọc khác (R2) | "đang giữ cho người đọc khác" |
| Chỉ đọc tại chỗ | "chỉ đọc tại chỗ, không cho mượn về" |

#### Success messages

| Tình huống | Wording |
|---|---|
| Mượn thành công | "Đã tạo phiếu mượn. Hạn trả được hiển thị trong danh sách sách đang mượn." |

#### Info / neutral messages

| Tình huống | Wording |
|---|---|
| Xác nhận lặp, giao dịch đã ghi | "Phiếu mượn này đã được ghi trước đó. Đây là kết quả đã ghi." |
| Quét trùng một cuốn trong giỏ | "Cuốn này đã có trong giỏ." |

## 8. Assumptions

- Mỗi cuốn một phiếu mượn, các phiếu tạo cùng một lần được in gộp trên một biên nhận theo thời điểm tạo (mặc định OQ-06 nguồn). Cách gọi phiếu cha/dòng phiếu còn mở ở OQ-core-004.
- Biên nhận in có ngay từ R1A cho giao dịch mượn; non-goal R1A của roadmap chỉ loại biên nhận thu phạt.
- Chặn mượn vì nợ phạt chỉ bật khi job quá hạn và sổ phạt đã chạy (DEC-P2-02).
- Hạn mức, hạn mượn, ngưỡng nợ dùng một bộ quy định chung, không phân loại người đọc.

## 9. Risks

| Rủi ro | Khả năng | Hậu quả nghiệp vụ | Cách phòng |
|--------|----------|-------------------|-----------|
| Process: Nhân viên chưa quen việc loại cuốn lỗi và đọc lý do chặn | thường | Giao dịch chậm, người đọc xếp hàng | Diễn tập tại quầy trước pilot (GATE-TRN) |
| Data: Nhãn QR mờ hoặc dán sai cuốn sau import | thỉnh thoảng | Ghi mượn nhầm cuốn, kho lệch | Đối soát vật lý ở GATE-MIG; luôn cho nhập mã tay |
| Timeline: Giá trị đã chốt bị đổi sát ngày pilot | hiếm | Phải đổi cấu hình và wording, đào tạo lại quầy | Mọi thay đổi đi qua change request |
| Adoption: Người đọc không chấp nhận bị chặn cứng, không có ngoại lệ | thỉnh thoảng | Phàn nàn tại quầy | Lý do chặn rõ ràng kèm cách khắc phục ngay tại quầy |

## 10. Success Criteria (preliminary)

- 0 phiếu mở trùng một bản sao trong kiểm thử đồng thời hai quầy.
- 100% giao dịch mượn có audit.
- Thời gian hoàn tất một giao dịch mượn giảm so với baseline thủ công đo trong UAT; đề xuất ≤ 2 phút/giao dịch.

## 11. Open Questions

- [x] OQ-1: Giá trị chính thức của hạn mức số cuốn, thời hạn mượn và ngưỡng nợ chặn mượn? → Resolved: 5 cuốn / 14 ngày / 50.000đ (DEC-SF-10, 2026-10-08)
- [x] OQ-2: Biên nhận mượn in gồm những thông tin gì? → Resolved: tên thư viện, mã phiếu, ngày giờ mượn, tên và mã thẻ người đọc, danh sách cuốn kèm mã bản sao và hạn trả, Nhân viên thực hiện (2026-10-08)
- [x] OQ-3: Wording khi bản sao không cho mượn được theo từng trạng thái, khi xác nhận lặp và khi quét trùng? → Resolved: xem Mục 7.3 (2026-10-08)
- [x] OQ-4: Ghi chú non-goal R1A "không biên nhận in/xuất" trong roadmap có cần sửa để ghi rõ chỉ áp cho biên nhận thu phạt? → Resolved: sửa roadmap R1A non-goal và PRD 7.9 (2026-10-08)
- [ ] OQ-5: Khổ giấy và loại máy in biên nhận tại quầy? (hold — đội vận hành)

## 12. Next Steps

- `/srs checkout`
