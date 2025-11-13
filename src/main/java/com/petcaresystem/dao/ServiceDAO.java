package com.petcaresystem.dao;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.enities.Service;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import com.petcaresystem.enities.ServiceCategory;

public class ServiceDAO {

    // Whitelist cột sort -> tránh lỗi cú pháp & injection
    private static final Map<String, String> SORT_MAP = Map.of(
            "serviceId",   "s.serviceId",
            "serviceName", "s.serviceName",
            "price",       "s.price",
            "duration",    "s.durationMinutes",
            "updated",     "s.updatedAt",
            "category",    "c.name" // sort theo thuộc tính scalar của category
    );

    private static final Logger LOGGER = Logger.getLogger(ServiceDAO.class.getName());

    /** Lấy tất cả service + category (tránh N+1) */
    // getAllServices
    public List<Service> getAllServices() {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            List<Service> results = s.createQuery(
                    "select sv from Service sv " +
                            "left join fetch sv.category c " +
                            "order by sv.serviceId desc", Service.class
            ).list();
            if (results == null || results.isEmpty()) {
                return Collections.emptyList();
            }
            return new ArrayList<>(new LinkedHashSet<>(results));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to load services", ex);
            return Collections.emptyList();
        }
    }

    // searchServices nhận categoryId (Integer)
    public List<Service> searchServices(String keyword, Integer categoryId, Boolean isActive,
                                        String sortBy, String sortOrder) {
        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "select sv from Service sv " +
                            "left join fetch sv.category c where 1=1 ");

            if (keyword != null && !keyword.isBlank()) {
                hql.append(" and (lower(sv.serviceName) like :kw or lower(sv.description) like :kw) ");
            }
            if (categoryId != null) {
                hql.append(" and c.categoryId = :cid ");
            }
            if (isActive != null) {
                hql.append(" and sv.isActive = :act ");
            }

            String col = switch (sortBy == null ? "serviceId" : sortBy) {
                case "serviceName" -> "sv.serviceName";
                case "price"       -> "sv.price";
                case "duration"    -> "sv.durationMinutes";
                case "category"    -> "c.name";
                case "updated"     -> "sv.updatedAt";
                default            -> "sv.serviceId";
            };
            String dir = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";
            hql.append(" order by ").append(col).append(" ").append(dir);

            Query<Service> q = s.createQuery(hql.toString(), Service.class);
            if (keyword != null && !keyword.isBlank()) q.setParameter("kw", "%"+keyword.toLowerCase()+"%");
            if (categoryId != null) q.setParameter("cid", categoryId);
            if (isActive != null) q.setParameter("act", isActive);

            List<Service> results = q.list();
            if (results == null || results.isEmpty()) {
                return Collections.emptyList();
            }
            return new ArrayList<>(new LinkedHashSet<>(results));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to search services", ex);
            return Collections.emptyList();
        }
    }


    /** Lấy 1 service kèm category */
    public Service getServiceById(int serviceId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT s FROM Service s " +
                                    "LEFT JOIN FETCH s.category " +
                                    "WHERE s.serviceId = :id",
                            Service.class
                    ).setParameter("id", serviceId)
                    .uniqueResult();
        }
    }

    /**
     * Kiểm tra tên service có trùng với service khác không (case-insensitive)
     * @param serviceName Tên service cần kiểm tra
     * @param excludeServiceId ID của service cần loại trừ (khi update, null khi create)
     * @return true nếu tên đã tồn tại, false nếu không trùng
     */
    public boolean isServiceNameExists(String serviceName, Integer excludeServiceId) {
        if (serviceName == null || serviceName.trim().isEmpty()) {
            return false;
        }
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql = "SELECT COUNT(s) FROM Service s WHERE LOWER(TRIM(s.serviceName)) = LOWER(TRIM(:name))";
            if (excludeServiceId != null && excludeServiceId > 0) {
                hql += " AND s.serviceId != :excludeId";
            }
            
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("name", serviceName.trim());
            if (excludeServiceId != null && excludeServiceId > 0) {
                query.setParameter("excludeId", excludeServiceId);
            }
            
            Long count = query.uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking service name existence", e);
            return false;
        }
    }

    /** Tạo service */
    public boolean createService(Service service) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(service);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Cập nhật service */
    public boolean updateService(Service service) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(service);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Soft delete: set isActive = false */
    public boolean deleteService(int serviceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Service s = session.get(Service.class, serviceId);
            if (s != null) {
                s.setActive(false);
                session.merge(s);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Hard delete */
    public boolean hardDeleteService(int serviceId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            Service s = session.get(Service.class, serviceId);
            if (s != null) {
                session.remove(s);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            return false;
        }
    }

    /** Active services */
    public List<Service> getActiveServices() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String hql =
                    "SELECT s FROM Service s " +
                            "JOIN FETCH s.category c " +               // dùng LEFT nếu category có thể null
                            "WHERE s.isActive = true " +
                            "ORDER BY c.name, s.serviceName";

            return session.createQuery(hql, Service.class)
                    .setReadOnly(true)
                    .getResultList();
        }
    }


    /** Dịch vụ theo categoryId */
    public List<Service> getServicesByCategoryId(int categoryId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery(
                            "SELECT s FROM Service s " +
                                    "LEFT JOIN FETCH s.category c " +
                                    "WHERE c.categoryId = :cid " +
                                    "ORDER BY s.serviceName",
                            Service.class
                    ).setParameter("cid", categoryId)
                    .list();
        }
    }

    public PagedResult<Service> findServices(String keyword, Integer categoryId, Boolean isActive,
                                             String sortBy, String sortOrder, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);
        String normalizedKeyword = normalizeKeyword(keyword);

        // Nếu có keyword, sử dụng fuzzy search
        if (normalizedKeyword != null && !normalizedKeyword.isEmpty()) {
            try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                // Lấy tất cả services trước
                List<Service> allServices = getAllServices();
                
                // Lọc theo category và active status
                List<Service> filteredServices = allServices.stream()
                    .filter(service -> {
                        if (categoryId != null && (service.getCategory() == null || 
                            service.getCategory().getCategoryId() != categoryId)) {
                            return false;
                        }
                        if (isActive != null && service.isActive() != isActive) {
                            return false;
                        }
                        return true;
                    })
                    .collect(Collectors.toList());

                // Tính điểm relevance
                List<ServiceWithScore> scoredServices = filteredServices.stream()
                    .map(service -> new ServiceWithScore(service, calculateRelevanceScore(service, normalizedKeyword)))
                    .filter(serviceWithScore -> serviceWithScore.score > 0)
                    .collect(Collectors.toList());

                // Sắp xếp theo điểm (giảm dần) và sau đó theo tiêu chí sắp xếp gốc
                scoredServices.sort((a, b) -> {
                    int scoreComparison = Double.compare(b.score, a.score);
                    if (scoreComparison != 0) return scoreComparison;
                    
                    // Sắp xếp phụ theo tiêu chí gốc
                    return compareServices(a.service, b.service, sortBy, sortOrder);
                });

                // Phân trang
                int startIndex = (safePage - 1) * safeSize;
                int endIndex = Math.min(startIndex + safeSize, scoredServices.size());
                
                List<Service> pagedResults = scoredServices.subList(startIndex, endIndex)
                    .stream()
                    .map(ServiceWithScore::getService)
                    .collect(Collectors.toList());

                return new PagedResult<>(pagedResults, scoredServices.size(), safePage, safeSize);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Failed to perform fuzzy search pagination", ex);
                return new PagedResult<>(Collections.emptyList(), 0, safePage, safeSize);
            }
        }

        // Nếu không có keyword, sử dụng tìm kiếm thường
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            String whereClause = buildWhereClause(null, categoryId, isActive);
            String orderClause = buildOrderClause(sortBy, sortOrder);

            Query<Long> countQuery = session.createQuery(
                    "SELECT COUNT(DISTINCT sv.serviceId) FROM Service sv LEFT JOIN sv.category c " + whereClause,
                    Long.class
            );
            applyFilters(countQuery, null, categoryId, isActive);
            long total = countQuery.uniqueResultOptional().orElse(0L);
            if (total == 0) {
                return new PagedResult<>(Collections.emptyList(), 0, safePage, safeSize);
            }

            Query<Integer> idQuery = session.createQuery(
                    "SELECT sv.serviceId FROM Service sv LEFT JOIN sv.category c " + whereClause + orderClause,
                    Integer.class
            );
            applyFilters(idQuery, null, categoryId, isActive);
            idQuery.setFirstResult((safePage - 1) * safeSize);
            idQuery.setMaxResults(safeSize);
            List<Integer> ids = idQuery.list();
            if (ids == null || ids.isEmpty()) {
                return new PagedResult<>(Collections.emptyList(), total, safePage, safeSize);
            }

            Query<Service> dataQuery = session.createQuery(
                    "SELECT DISTINCT sv FROM Service sv LEFT JOIN FETCH sv.category WHERE sv.serviceId IN (:ids)",
                    Service.class
            );
            dataQuery.setParameterList("ids", ids);
            List<Service> fetched = dataQuery.list();
            if (fetched == null) {
                fetched = Collections.emptyList();
            }

            Map<Integer, Service> serviceById = fetched.stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.toMap(
                            Service::getServiceId,
                            svc -> svc,
                            (first, second) -> first,
                            LinkedHashMap::new
                    ));
            List<Service> ordered = new ArrayList<>();
            for (Integer id : ids) {
                Service svc = serviceById.get(id);
                if (svc != null) {
                    ordered.add(svc);
                }
            }

            return new PagedResult<>(ordered, total, safePage, safeSize);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to paginate services", ex);
            return new PagedResult<>(Collections.emptyList(), 0, safePage, safeSize);
        }
    }

    private String buildWhereClause(String keyword, Integer categoryId, Boolean isActive) {
        StringBuilder where = new StringBuilder("WHERE 1=1 ");
        if (keyword != null && !keyword.isEmpty()) {
            where.append("AND (lower(sv.serviceName) like :kw OR lower(sv.description) like :kw) ");
        }
        if (categoryId != null) {
            where.append("AND c.categoryId = :cid ");
        }
        if (isActive != null) {
            where.append("AND sv.isActive = :act ");
        }
        return where.toString();
    }

    private String buildOrderClause(String sortBy, String sortOrder) {
        String column = switch (sortBy == null ? "serviceId" : sortBy) {
            case "serviceName" -> "sv.serviceName";
            case "price" -> "sv.price";
            case "duration" -> "sv.durationMinutes";
            case "category" -> "c.name";
            case "updated" -> "sv.updatedAt";
            default -> "sv.serviceId";
        };
        String direction = "DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC";
        return " ORDER BY " + column + direction;
    }

    private void applyFilters(Query<?> query, String keyword, Integer categoryId, Boolean isActive) {
        if (keyword != null && !keyword.isEmpty()) {
            query.setParameter("kw", "%" + keyword + "%");
        }
        if (categoryId != null) {
            query.setParameter("cid", categoryId);
        }
        if (isActive != null) {
            query.setParameter("act", isActive);
        }
    }

    private String normalizeKeyword(String keyword) {
        if (keyword == null) {
            return null;
        }
        String trimmed = keyword.trim().toLowerCase();
        return trimmed.isEmpty() ? null : trimmed;
    }

    /**
     * Fuzzy search for services with relevance scoring
     * Uses multiple search strategies for better matching
     */
    public List<Service> fuzzySearchServices(String keyword, Integer categoryId, Boolean isActive,
                                             String sortBy, String sortOrder) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return searchServices(keyword, categoryId, isActive, sortBy, sortOrder);
        }

        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
            // Get all services first
            List<Service> allServices = getAllServices();
            
            // Filter by category and active status
            List<Service> filteredServices = allServices.stream()
                .filter(service -> {
                    if (categoryId != null && (service.getCategory() == null || 
                        service.getCategory().getCategoryId() != categoryId)) {
                        return false;
                    }
                    if (isActive != null && service.isActive() != isActive) {
                        return false;
                    }
                    return true;
                })
                .collect(Collectors.toList());

            // Calculate relevance scores
            List<ServiceWithScore> scoredServices = filteredServices.stream()
                .map(service -> new ServiceWithScore(service, calculateRelevanceScore(service, keyword)))
                .filter(serviceWithScore -> serviceWithScore.score > 0)
                .collect(Collectors.toList());

            // Sort by score (descending) and then by the original sort criteria
            scoredServices.sort((a, b) -> {
                int scoreComparison = Double.compare(b.score, a.score);
                if (scoreComparison != 0) return scoreComparison;
                
                // Secondary sort by original criteria
                return compareServices(a.service, b.service, sortBy, sortOrder);
            });

            return scoredServices.stream()
                .map(ServiceWithScore::getService)
                .collect(Collectors.toList());
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to perform fuzzy search", ex);
            return Collections.emptyList();
        }
    }

    /**
     * Calculate relevance score for a service based on keyword matching
     */
    private double calculateRelevanceScore(Service service, String keyword) {
        String normalizedKeyword = keyword.toLowerCase().trim();
        String serviceName = service.getServiceName() != null ? service.getServiceName().toLowerCase() : "";
        String description = service.getDescription() != null ? service.getDescription().toLowerCase() : "";
        
        double score = 0.0;
        
        // Exact match in service name (highest priority)
        if (serviceName.equals(normalizedKeyword)) {
            score += 100.0;
        }
        // Service name starts with keyword
        else if (serviceName.startsWith(normalizedKeyword)) {
            score += 80.0;
        }
        // Service name contains keyword
        else if (serviceName.contains(normalizedKeyword)) {
            score += 60.0;
        }
        // Fuzzy match in service name using Levenshtein distance
        else {
            double nameSimilarity = calculateStringSimilarity(serviceName, normalizedKeyword);
            if (nameSimilarity > 0.6) {
                score += nameSimilarity * 50.0;
            }
        }
        
        // Description contains keyword (lower priority)
        if (description.contains(normalizedKeyword)) {
            score += 20.0;
        }
        
        // Word-by-word matching
        String[] keywordWords = normalizedKeyword.split("\\s+");
        String[] serviceWords = serviceName.split("\\s+");
        
        for (String kw : keywordWords) {
            for (String sw : serviceWords) {
                if (sw.startsWith(kw)) {
                    score += 15.0;
                } else if (sw.contains(kw)) {
                    score += 10.0;
                } else {
                    double wordSimilarity = calculateStringSimilarity(sw, kw);
                    if (wordSimilarity > 0.7) {
                        score += wordSimilarity * 8.0;
                    }
                }
            }
        }
        
        return score;
    }

    /**
     * Calculate string similarity using Levenshtein distance
     */
    private double calculateStringSimilarity(String s1, String s2) {
        if (s1 == null || s2 == null) return 0.0;
        if (s1.equals(s2)) return 1.0;
        
        int maxLength = Math.max(s1.length(), s2.length());
        if (maxLength == 0) return 1.0;
        
        int distance = levenshteinDistance(s1, s2);
        return 1.0 - (double) distance / maxLength;
    }

    /**
     * Calculate Levenshtein distance between two strings
     */
    private int levenshteinDistance(String s1, String s2) {
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];
        
        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0) {
                    dp[i][j] = j;
                } else if (j == 0) {
                    dp[i][j] = i;
                } else {
                    dp[i][j] = Math.min(Math.min(
                        dp[i - 1][j] + 1,
                        dp[i][j - 1] + 1),
                        dp[i - 1][j - 1] + (s1.charAt(i - 1) == s2.charAt(j - 1) ? 0 : 1)
                    );
                }
            }
        }
        
        return dp[s1.length()][s2.length()];
    }

    /**
     * Compare services based on sort criteria
     */
    private int compareServices(Service a, Service b, String sortBy, String sortOrder) {
        if (sortBy == null) sortBy = "serviceId";
        boolean ascending = !"DESC".equalsIgnoreCase(sortOrder);
        
        int result = 0;
        switch (sortBy) {
            case "serviceName":
                result = a.getServiceName().compareToIgnoreCase(b.getServiceName());
                break;
            case "price":
                result = a.getPrice().compareTo(b.getPrice());
                break;
            case "duration":
                Integer durationA = a.getDurationMinutes() != null ? a.getDurationMinutes() : 0;
                Integer durationB = b.getDurationMinutes() != null ? b.getDurationMinutes() : 0;
                result = durationA.compareTo(durationB);
                break;
            case "category":
                String catA = a.getCategory() != null ? a.getCategory().getName() : "";
                String catB = b.getCategory() != null ? b.getCategory().getName() : "";
                result = catA.compareToIgnoreCase(catB);
                break;
            case "updated":
                if (a.getUpdatedAt() != null && b.getUpdatedAt() != null) {
                    result = a.getUpdatedAt().compareTo(b.getUpdatedAt());
                }
                break;
            default: // serviceId
                result = Integer.compare(a.getServiceId(), b.getServiceId());
                break;
        }
        
        return ascending ? result : -result;
    }

    /**
     * Helper class to hold service with its relevance score
     */
    private static class ServiceWithScore {
        private final Service service;
        private final double score;

        public ServiceWithScore(Service service, double score) {
            this.service = service;
            this.score = score;
        }

        public Service getService() {
            return service;
        }

        public double getScore() {
            return score;
        }
    }

    /**
     * Get service distribution by category (percentage of total services)
     * Lấy từ database: đếm số service theo category và tính phần trăm
     * Returns list of maps with category name, count, and percentage
     */
    public List<Map<String, Object>> getServiceDistributionByCategory() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Đếm tổng số service active từ database
            Long totalServices = session.createQuery(
                    "SELECT COUNT(s.serviceId) FROM Service s WHERE s.isActive = true",
                    Long.class
            ).uniqueResult();
            
            if (totalServices == null || totalServices == 0) {
                LOGGER.info("No active services found in database");
                return Collections.emptyList();
            }
            
            LOGGER.info("Total active services from database: " + totalServices);
            
            // Đếm số service theo từng category từ database
            // Query lấy: categoryId, categoryName, và số lượng service trong category đó
            String hql = """
                SELECT c.categoryId, c.name, COUNT(s.serviceId) as serviceCount
                FROM Service s
                INNER JOIN s.category c
                WHERE s.isActive = true
                GROUP BY c.categoryId, c.name
                ORDER BY serviceCount DESC
                """;
            
            @SuppressWarnings("unchecked")
            List<Object[]> results = session.createQuery(hql, Object[].class).list();
            
            LOGGER.info("Found " + results.size() + " categories with services");
            
            // Tính toán phần trăm cho mỗi category
            // Phần trăm = (số service trong category / tổng số service) * 100
            List<Map<String, Object>> distribution = new ArrayList<>();
            for (Object[] row : results) {
                Integer categoryId = (Integer) row[0];
                String categoryName = (String) row[1];
                Long count = ((Number) row[2]).longValue();
                
                // Tính phần trăm: (số service category / tổng số service) * 100
                double percentage = totalServices > 0 ? (count * 100.0 / totalServices) : 0.0;
                percentage = Math.round(percentage * 10.0) / 10.0; // Làm tròn 1 chữ số thập phân
                
                Map<String, Object> item = new HashMap<>();
                item.put("categoryId", categoryId);
                item.put("categoryName", categoryName);
                item.put("count", count);
                item.put("percentage", percentage);
                
                LOGGER.fine("Category: " + categoryName + ", Count: " + count + ", Percentage: " + percentage + "%");
                
                distribution.add(item);
            }
            
            return distribution;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to get service distribution by category from database", e);
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
