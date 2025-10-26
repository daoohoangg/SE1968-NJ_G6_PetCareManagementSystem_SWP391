package com.petcaresystem.dto.pageable;

import java.util.Collections;
import java.util.List;

/**
 * Simple immutable container for paginated query results.
 */
public class PagedResult<T> {

    private final List<T> items;
    private final long totalItems;
    private final int page;
    private final int pageSize;

    public PagedResult(List<T> items, long totalItems, int page, int pageSize) {
        this.items = items != null ? items : Collections.emptyList();
        this.totalItems = Math.max(totalItems, 0);
        this.page = Math.max(page, 1);
        this.pageSize = pageSize > 0 ? pageSize : this.items.size();
    }

    public List<T> getItems() {
        return items;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public int getPage() {
        return page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalPages() {
        if (pageSize <= 0 || totalItems == 0) {
            return 0;
        }
        return (int) ((totalItems + pageSize - 1) / pageSize);
    }

    public int getOffset() {
        return (page - 1) * pageSize;
    }

    public int getStartIndex() {
        if (totalItems == 0 || items.isEmpty()) {
            return 0;
        }
        return getOffset() + 1;
    }

    public int getEndIndex() {
        if (totalItems == 0 || items.isEmpty()) {
            return 0;
        }
        return getOffset() + items.size();
    }

    public boolean hasPrevious() {
        return page > 1;
    }

    public boolean hasNext() {
        int totalPages = getTotalPages();
        return totalPages > 0 && page < totalPages;
    }
}
