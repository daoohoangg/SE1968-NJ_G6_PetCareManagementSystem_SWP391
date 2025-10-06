package com.petcaresystem.service.admin;

import com.petcaresystem.enities.Service;

import java.util.List;

public interface IServiceManageService {
    List<Service> getAllServices();
    Service getServiceById(int serviceId);
    boolean createService(Service service);
    boolean updateService(Service service);
    boolean deleteService(int serviceId);
    boolean hardDeleteService(int serviceId);
    List<Service> searchServices(String keyword, String category, Boolean isActive, String sortBy, String sortOrder);
    List<Service> getActiveServices();
    List<Service> getServicesByCategory(String category);
    List<String> getAllCategories();
}
