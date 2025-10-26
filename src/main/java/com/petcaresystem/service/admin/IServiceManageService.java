package com.petcaresystem.service.admin;

import com.petcaresystem.dto.pageable.PagedResult;
import com.petcaresystem.enities.Service;
import com.petcaresystem.enities.ServiceCategory;

import java.math.BigDecimal;
import java.util.List;

public interface IServiceManageService {
    List<Service> getAllServices();
    Service getServiceById(int serviceId);
    List<Service> getActiveServices();

    List<Service> searchServices(String keyword, Integer categoryId, Boolean isActive,
                                 String sortBy, String sortOrder);

    List<Service> fuzzySearchServices(String keyword, Integer categoryId, Boolean isActive,
                                      String sortBy, String sortOrder);

    PagedResult<Service> getServicesPage(String keyword, Integer categoryId, Boolean isActive,
                                         String sortBy, String sortOrder, int page, int pageSize);

    List<Service> getServicesByCategoryId(Integer categoryId);

    // CRUD
    boolean createService(Service s);
    boolean updateService(Service s);
    boolean deleteService(int serviceId);
    boolean hardDeleteService(int serviceId);

    // Category helpers (ENTITY thay vì String)
    List<ServiceCategory> getAllCategories();
    ServiceCategory getCategoryById(int id);

    // (Tùy chọn) các hàm “move-from-controller”: nhận raw params, map & validate ở service
    boolean createService(String serviceName, String description, BigDecimal price,
                          Integer durationMinutes, Integer categoryId, boolean isActive);

    boolean updateService(int serviceId, String serviceName, String description, BigDecimal price,
                          Integer durationMinutes, Integer categoryId, boolean isActive);
}
