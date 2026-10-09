package com.quanlythuvien.catalog;

import com.quanlythuvien.audit.AuditWriter;
import com.quanlythuvien.circulation.CopyStatus;
import com.quanlythuvien.shared.ApiException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CatalogService {

    private final TitleRepository titles;
    private final CategoryRepository categories;
    private final BookCopyRepository copies;
    private final AuditWriter audit;

    public CatalogService(TitleRepository titles, CategoryRepository categories, BookCopyRepository copies, AuditWriter audit) {
        this.titles = titles;
        this.categories = categories;
        this.copies = copies;
        this.audit = audit;
    }

    /** Tìm đầu sách đang dùng theo từ khóa. */
    public List<Title> search(String q) {
        return titles.search(q == null ? "" : q.trim());
    }

    /** Đếm bản sao đang sẵn sàng và được phép mượn. */
    public long availableCount(Long titleId) {
        return copies.findByTitleId(titleId).stream().filter(copy -> copy.getStatus() == CopyStatus.AVAILABLE && copy.loanable()).count();
    }

    @Transactional
    /** Tạo đầu sách. Thể loại chưa có thì tạo mới. */
    public Title createTitle(String name, String author, String isbn, String categoryName, int priceVnd, boolean loanable, long actorId) {
        Title title = new Title();
        title.setName(name.trim());
        title.setAuthor(author.trim());
        title.setIsbn(blankToNull(isbn));
        title.setPriceVnd(priceVnd);
        title.setLoanable(loanable);
        title.setActive(true);
        if (categoryName != null && !categoryName.isBlank()) {
            title.setCategory(categories.findByNameIgnoreCase(categoryName.trim()).orElseGet(() -> {
                Category category = new Category();
                category.setName(categoryName.trim());
                return categories.save(category);
            }));
        }
        titles.save(title);
        audit.record(actorId, "TITLE_CREATE", "title", String.valueOf(title.getId()), title.getName());
        return title;
    }

    @Transactional
    /** Thêm bản sao ở trạng thái sẵn sàng. Mã trùng thì từ chối. */
    public BookCopy addCopy(long titleId, String code, String shelf, long actorId) {
        Title title = titles.findById(titleId).orElseThrow(() -> ApiException.notFound("Không thấy đầu sách"));
        if (copies.existsByCode(code.trim())) {
            throw ApiException.conflict("COPY_CODE", "Mã bản sao đã tồn tại");
        }
        BookCopy copy = new BookCopy();
        copy.setTitle(title);
        copy.setCode(code.trim());
        copy.setShelf(blankToNull(shelf));
        copy.setStatus(CopyStatus.AVAILABLE);
        copies.save(copy);
        audit.record(actorId, "COPY_CREATE", "copy", String.valueOf(copy.getId()), copy.getCode());
        return copy;
    }

    /** Lấy bản sao theo mã. Không thấy thì báo lỗi. */
    public BookCopy requireCopy(String code) {
        return copies.findByCode(code.trim()).orElseThrow(() -> ApiException.notFound("Không thấy bản sao"));
    }

    /** Chuỗi rỗng được lưu thành null. */
    private static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
