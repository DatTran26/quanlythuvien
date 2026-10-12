package com.quanlythuvien.catalog;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface TitleRepository extends JpaRepository<Title, Long> {

    @Query("""
            select t from Title t
            where t.active = true and (
                lower(t.name) like lower(concat('%', :q, '%'))
                or lower(t.author) like lower(concat('%', :q, '%'))
                or lower(coalesce(t.isbn, '')) like lower(concat('%', :q, '%'))
            )
            order by t.name
            """)
    List<Title> search(String q);
}
