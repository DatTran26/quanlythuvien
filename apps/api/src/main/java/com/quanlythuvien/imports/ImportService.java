package com.quanlythuvien.imports;

import com.quanlythuvien.audit.AuditWriter;
import com.quanlythuvien.catalog.BookCopy;
import com.quanlythuvien.catalog.BookCopyRepository;
import com.quanlythuvien.catalog.Category;
import com.quanlythuvien.catalog.CategoryRepository;
import com.quanlythuvien.catalog.Title;
import com.quanlythuvien.catalog.TitleRepository;
import com.quanlythuvien.circulation.CopyStatus;
import com.quanlythuvien.shared.ApiException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Service
public class ImportService {

    private final TitleRepository titles;
    private final CategoryRepository categories;
    private final BookCopyRepository copies;
    private final AuditWriter audit;
    private final DataFormatter formatter = new DataFormatter();

    public ImportService(TitleRepository titles, CategoryRepository categories, BookCopyRepository copies, AuditWriter audit) {
        this.titles = titles;
        this.categories = categories;
        this.copies = copies;
        this.audit = audit;
    }

    /** Đọc Excel và liệt kê lỗi, không ghi kho. */
    public ImportPreview dryRun(InputStream input) throws IOException {
        return parse(input);
    }

    @Transactional
    /** Ghi Excel vào kho. Còn dòng sai thì không ghi dòng nào. */
    public ImportPreview commit(InputStream input, long actorId) throws IOException {
        ImportPreview preview = parse(input);
        if (!preview.errors().isEmpty()) {
            throw ApiException.badRequest("IMPORT_INVALID", String.join("; ", preview.errors()));
        }
        for (ImportRow row : preview.rows()) {
            Category category = null;
            if (row.category() != null) {
                category = categories.findByNameIgnoreCase(row.category()).orElseGet(() -> {
                    Category created = new Category();
                    created.setName(row.category());
                    return categories.save(created);
                });
            }
            Title title = new Title();
            title.setName(row.name());
            title.setAuthor(row.author());
            title.setIsbn(row.isbn());
            title.setCategory(category);
            title.setPriceVnd(row.priceVnd());
            title.setLoanable(true);
            title.setActive(true);
            titles.save(title);
            BookCopy copy = new BookCopy();
            copy.setTitle(title);
            copy.setCode(row.copyCode());
            copy.setShelf(row.shelf());
            copy.setStatus(CopyStatus.AVAILABLE);
            copies.save(copy);
        }
        audit.record(actorId, "IMPORT", "title", String.valueOf(preview.rows().size()), null);
        return preview;
    }

    /** Đọc từng dòng Excel và gom lỗi. */
    private ImportPreview parse(InputStream input) throws IOException {
        List<ImportRow> rows = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        Set<String> seen = new HashSet<>();
        try (XSSFWorkbook workbook = new XSSFWorkbook(input)) {
            var sheet = workbook.getSheetAt(0);
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null || blank(row, 0)) {
                    continue;
                }
                int line = i + 1;
                String name = text(row, 0);
                String author = text(row, 1);
                String isbn = text(row, 2);
                String category = text(row, 3);
                String priceText = text(row, 4);
                String code = text(row, 5);
                String shelf = text(row, 6);
                if (name == null || author == null || code == null || priceText == null) {
                    errors.add("Dòng " + line + " thiếu tên, tác giả, giá hoặc mã bản sao");
                    continue;
                }
                int price;
                try {
                    price = Integer.parseInt(priceText.replace(".", ""));
                } catch (NumberFormatException ex) {
                    errors.add("Dòng " + line + " giá không phải số");
                    continue;
                }
                if (!seen.add(code) || copies.existsByCode(code)) {
                    errors.add("Dòng " + line + " trùng mã bản sao " + code);
                    continue;
                }
                rows.add(new ImportRow(name, author, isbn, category, price, code, shelf));
            }
        }
        if (rows.isEmpty() && errors.isEmpty()) {
            errors.add("File không có dòng dữ liệu");
        }
        return new ImportPreview(rows, errors);
    }

    /** Đọc một ô Excel thành chữ. Ô trống trả về null. */
    private String text(Row row, int index) {
        Cell cell = row.getCell(index);
        if (cell == null) {
            return null;
        }
        String value = formatter.formatCellValue(cell).trim();
        return value.isEmpty() ? null : value;
    }

    /** Dòng không có tên sách thì bỏ qua. */
    private boolean blank(Row row, int index) {
        return text(row, index) == null;
    }

    public record ImportRow(String name, String author, String isbn, String category, int priceVnd, String copyCode, String shelf) {
    }

    public record ImportPreview(List<ImportRow> rows, List<String> errors) {
    }
}
