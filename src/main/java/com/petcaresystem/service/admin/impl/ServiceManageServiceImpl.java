package com.petcaresystem.service.admin.impl;

import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.dao.ServiceCategoryDAO;
import com.petcaresystem.enities.Service;
import com.petcaresystem.enities.ServiceCategory;
import com.petcaresystem.service.admin.IServiceManageService;

import java.math.BigDecimal;
import java.util.List;

public class ServiceManageServiceImpl implements IServiceManageService {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final ServiceCategoryDAO categoryDAO = new ServiceCategoryDAO();

    // ===== Queries =====
    @Override
    public List<Service> getAllServices() {
        return serviceDAO.getAllServices(); // đã JOIN FETCH category trong DAO
    }

    @Override
    public Service getServiceById(int serviceId) {
        return serviceDAO.getServiceById(serviceId); // LEFT JOIN FETCH category
    }

    @Override
    public List<Service> getActiveServices() {
        return serviceDAO.getActiveServices();
    }

    // ===== Search/List =====
    @Override
    public List<Service> searchServices(String keyword, Integer categoryId, Boolean isActive,
                                        String sortBy, String sortOrder) {
        return serviceDAO.searchServices(keyword, categoryId, isActive, sortBy, sortOrder);
    }

    @Override
    public List<Service> getServicesByCategoryId(Integer categoryId) {
        if (categoryId == null) return getAllServices();
        return serviceDAO.getServicesByCategoryId(categoryId);
    }

    // ===== CRUD =====
    @Override
    public boolean createService(Service s) {
        if (!validateBase(s)) return false;
        // bắt buộc có category entity
        if (s.getCategory() == null || s.getCategory().getCategoryId() <= 0) return false;
        // có thể load lại entity sạch từ DB để tránh detached
        ServiceCategory cat = categoryDAO.getById(s.getCategory().getCategoryId());
        if (cat == null) return false;
        s.setCategory(cat);
        return serviceDAO.createService(s);
    }

    @Override
    public boolean updateService(Service s) {
        if (s == null || s.getServiceId() <= 0) return false;
        if (!validateNamePrice(s.getServiceName(), s.getPrice())) return false;

        if (s.getCategory() != null && s.getCategory().getCategoryId() > 0) {
            ServiceCategory cat = categoryDAO.getById(s.getCategory().getCategoryId());
            if (cat == null) return false;
            s.setCategory(cat);
        }
        return serviceDAO.updateService(s);
    }

    @Override
    public boolean deleteService(int serviceId) {
        if (serviceId <= 0) return false;
        return serviceDAO.deleteService(serviceId);
    }

    @Override
    public boolean hardDeleteService(int serviceId) {
        if (serviceId <= 0) return false;
        return serviceDAO.hardDeleteService(serviceId);
    }

    // ===== Category helpers (ENTITY) =====
    @Override
    public List<ServiceCategory> getAllCategories() {
        return categoryDAO.getAll();
    }

    @Override
    public ServiceCategory getCategoryById(int id) {
        return categoryDAO.getById(id);
    }

    // ===== “Move-from-controller” helpers (nhận raw params) =====
    @Override
    public boolean createService(String serviceName, String description, BigDecimal price,
                                 Integer durationMinutes, Integer categoryId, boolean isActive) {
        if (!validateNamePrice(serviceName, price)) return false;
        if (categoryId == null || categoryId <= 0) return false;

        ServiceCategory cat = categoryDAO.getById(categoryId);
        if (cat == null) return false;

        Service s = new Service();
        s.setServiceName(serviceName);
        s.setDescription(description);
        s.setPrice(price);
        s.setDurationMinutes(durationMinutes);
        s.setCategory(cat);
        s.setActive(isActive);

        return serviceDAO.createService(s);
    }

    @Override
    public boolean updateService(int serviceId, String serviceName, String description, BigDecimal price,
                                 Integer durationMinutes, Integer categoryId, boolean isActive) {
        if (serviceId <= 0) return false;
        if (!validateNamePrice(serviceName, price)) return false;

        Service s = serviceDAO.getServiceById(serviceId);
        if (s == null) return false;

        s.setServiceName(serviceName);
        s.setDescription(description);
        s.setPrice(price);
        s.setDurationMinutes(durationMinutes);
        s.setActive(isActive);

        if (categoryId != null && categoryId > 0) {
            ServiceCategory cat = categoryDAO.getById(categoryId);
            if (cat == null) return false;
            s.setCategory(cat);
        }

        return serviceDAO.updateService(s);
    }

    // ===== Validation =====
    private boolean validateBase(Service s) {
        if (s == null) return false;
        return validateNamePrice(s.getServiceName(), s.getPrice());
    }

    private boolean validateNamePrice(String name, BigDecimal price) {
        if (name == null || name.trim().isEmpty()) return false;
        if (price == null || price.signum() <= 0) return false;
        return true;
    }
}
