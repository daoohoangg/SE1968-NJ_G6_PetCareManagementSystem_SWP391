package com.petcaresystem.service.admin.impl;

import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.enities.Service;
import com.petcaresystem.service.admin.IServiceManageService;

import java.util.List;

public class ServiceManageServiceImpl implements IServiceManageService {
    private final ServiceDAO serviceDAO;

    public ServiceManageServiceImpl() {
        this.serviceDAO = new ServiceDAO();
    }

    @Override
    public List<Service> getAllServices() {
        return serviceDAO.getAllServices();
    }

    @Override
    public Service getServiceById(int serviceId) {
        return serviceDAO.getServiceById(serviceId);
    }

    @Override
    public boolean createService(Service service) {
        // Validate service data
        if (service == null || service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
            return false;
        }
        if (service.getPrice() == null || service.getPrice().signum() <= 0) {
            return false;
        }
        return serviceDAO.createService(service);
    }

    @Override
    public boolean updateService(Service service) {
        // Validate service data
        if (service == null || service.getServiceId() <= 0) {
            return false;
        }
        if (service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
            return false;
        }
        if (service.getPrice() == null || service.getPrice().signum() <= 0) {
            return false;
        }
        return serviceDAO.updateService(service);
    }

    @Override
    public boolean deleteService(int serviceId) {
        if (serviceId <= 0) {
            return false;
        }
        return serviceDAO.deleteService(serviceId);
    }

    @Override
    public boolean hardDeleteService(int serviceId) {
        if (serviceId <= 0) {
            return false;
        }
        return serviceDAO.hardDeleteService(serviceId);
    }

    @Override
    public List<Service> searchServices(String keyword, String category, Boolean isActive,
                                       String sortBy, String sortOrder) {
        return serviceDAO.searchServices(keyword, category, isActive, sortBy, sortOrder);
    }

    @Override
    public List<Service> getActiveServices() {
        return serviceDAO.getActiveServices();
    }

    @Override
    public List<Service> getServicesByCategory(String category) {
        return serviceDAO.getServicesByCategory(category);
    }

    @Override
    public List<String> getAllCategories() {
        return serviceDAO.getAllCategories();
    }
}
