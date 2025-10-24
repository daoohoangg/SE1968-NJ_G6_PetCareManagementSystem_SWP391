package com.petcaresystem.dao;

import com.petcaresystem.enities.Service;
import com.petcaresystem.enities.ServiceCategory;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class ServiceDAOTest {

    private ServiceDAO serviceDAO;
    private ServiceCategoryDAO categoryDAO;
    private int defaultCategoryId;
    private int alternateCategoryId;

    private final List<Integer> createdServiceIds = new ArrayList<>();
    private final List<Integer> createdCategoryIds = new ArrayList<>();

    @BeforeAll
    void setUpAll() {
        serviceDAO = new ServiceDAO();
        categoryDAO = new ServiceCategoryDAO();

        List<ServiceCategory> categories = categoryDAO.getAll();
        if (categories.isEmpty()) {
            defaultCategoryId = createCategory("Default Test Category");
            alternateCategoryId = createCategory("Alternate Test Category");
        } else if (categories.size() == 1) {
            defaultCategoryId = categories.get(0).getCategoryId();
            alternateCategoryId = createCategory("Alternate Test Category");
        } else {
            defaultCategoryId = categories.get(0).getCategoryId();
            alternateCategoryId = categories.get(1).getCategoryId();
        }
    }

    @AfterEach
    void cleanUpServices() {
        for (Integer id : createdServiceIds) {
            serviceDAO.hardDeleteService(id);
        }
        createdServiceIds.clear();
    }

    @AfterAll
    void cleanUpCategories() {
        for (Integer id : createdCategoryIds) {
            categoryDAO.deleteCascade(id);
        }
        createdCategoryIds.clear();
    }

    private int createCategory(String baseName) {
        ServiceCategory cat = new ServiceCategory();
        cat.setName(baseName + " " + UUID.randomUUID());
        cat.setDescription("Integration test category");
        boolean ok = categoryDAO.create(cat);
        Assertions.assertTrue(ok, "Failed to create test category");
        createdCategoryIds.add(cat.getCategoryId());
        return cat.getCategoryId();
    }

    private Service buildService(String name, BigDecimal price,
                                 int durationMinutes, boolean active, Integer categoryId) {
        Service s = new Service();
        s.setServiceName(name);
        s.setDescription("Integration test data");
        s.setPrice(price);
        s.setDurationMinutes(durationMinutes);
        s.setActive(active);
        s.setCreatedAt(LocalDateTime.now());
        s.setUpdatedAt(LocalDateTime.now());
        ServiceCategory category = new ServiceCategory();
        category.setCategoryId(categoryId != null ? categoryId : defaultCategoryId);
        s.setCategory(category);
        return s;
    }

    private Service persist(Service service) {
        boolean ok = serviceDAO.createService(service);
        Assertions.assertTrue(ok, "Failed to persist test service");
        createdServiceIds.add(service.getServiceId());
        return service;
    }

    @Test
    void getAllServices_ShouldIncludeRecentlyCreatedServices() {
        Service s1 = persist(buildService("Integration Service 1 " + UUID.randomUUID(),
                new BigDecimal("10.00"), 30, true, defaultCategoryId));
        Service s2 = persist(buildService("Integration Service 2 " + UUID.randomUUID(),
                new BigDecimal("15.50"), 45, true, defaultCategoryId));
        Service s3 = persist(buildService("Integration Service 3 " + UUID.randomUUID(),
                new BigDecimal("20.00"), 60, false, alternateCategoryId));

        List<Service> services = serviceDAO.getAllServices();
        System.out.println("[DEBUG] getAllServices returned " + services.size() + " records");
        assertThat(services)
                .extracting(Service::getServiceId)
                .contains(s1.getServiceId(), s2.getServiceId(), s3.getServiceId());
    }

    @Test
    void getServiceById_WhenServiceExists_ShouldReturnServiceWithCategory() {
        Service persisted = persist(buildService("Lookup Service " + UUID.randomUUID(),
                new BigDecimal("25.00"), 40, true, defaultCategoryId));

        Service service = serviceDAO.getServiceById(persisted.getServiceId());

        assertThat(service).isNotNull();
        assertThat(service.getServiceId()).isEqualTo(persisted.getServiceId());
        assertThat(service.getCategory()).isNotNull();
        assertThat(service.getCategory().getCategoryId()).isEqualTo(defaultCategoryId);
    }

    @Test
    void getServiceById_WhenServiceNotExists_ShouldReturnNull() {
        Service service = serviceDAO.getServiceById(Integer.MAX_VALUE);
        assertThat(service).isNull();
    }

    @Test
    void createService_ShouldPersistServiceAndReturnTrue() {
        Service newService = buildService("Creatable Service " + UUID.randomUUID(),
                new BigDecimal("30.00"), 50, true, defaultCategoryId);

        boolean result = serviceDAO.createService(newService);
        createdServiceIds.add(newService.getServiceId());

        assertThat(result).isTrue();
        Service persisted = serviceDAO.getServiceById(newService.getServiceId());
        assertThat(persisted).isNotNull();
        assertThat(persisted.getServiceName()).isEqualTo(newService.getServiceName());
    }

    @Test
    void createService_WithInvalidPrice_ShouldReturnFalseAndNotPersist() {
        Service invalid = buildService("Invalid Price Service " + UUID.randomUUID(),
                BigDecimal.ZERO, 30, true, defaultCategoryId);

        boolean result = serviceDAO.createService(invalid);

        assertThat(result).isFalse();
        Service persisted = serviceDAO.getServiceById(invalid.getServiceId());
        assertThat(persisted).isNull();
    }

    @Test
    void updateService_ShouldUpdateAndReturnTrue() {
        Service service = persist(buildService("Updatable Service " + UUID.randomUUID(),
                new BigDecimal("18.00"), 35, true, defaultCategoryId));

        String updatedName = service.getServiceName() + " Updated";
        service.setServiceName(updatedName);
        service.setPrice(new BigDecimal("22.00"));

        boolean result = serviceDAO.updateService(service);
        assertThat(result).isTrue();

        Service updated = serviceDAO.getServiceById(service.getServiceId());
        assertThat(updated.getServiceName()).isEqualTo(updatedName);
        assertThat(updated.getPrice()).isEqualTo(new BigDecimal("22.00"));
    }

    @Test
    void updateService_WithNonExistingId_ShouldReturnFalse() {
        Service phantom = buildService("Phantom Service " + UUID.randomUUID(),
                new BigDecimal("33.00"), 45, true, defaultCategoryId);
        phantom.setServiceId(Integer.MAX_VALUE);

        boolean result = serviceDAO.updateService(phantom);

        assertThat(result).isFalse();
    }

    @Test
    void deleteService_ShouldSetIsActiveToFalse() {
        Service service = persist(buildService("Soft Delete Service " + UUID.randomUUID(),
                new BigDecimal("12.00"), 25, true, defaultCategoryId));

        boolean result = serviceDAO.deleteService(service.getServiceId());
        assertThat(result).isTrue();

        Service deleted = serviceDAO.getServiceById(service.getServiceId());
        assertThat(deleted).isNotNull();
        assertThat(deleted.isActive()).isFalse();
    }

    @Test
    void hardDeleteService_ShouldRemoveFromDatabase() {
        Service service = persist(buildService("Hard Delete Service " + UUID.randomUUID(),
                new BigDecimal("14.00"), 20, true, defaultCategoryId));

        boolean result = serviceDAO.hardDeleteService(service.getServiceId());
        assertThat(result).isTrue();

        Service deleted = serviceDAO.getServiceById(service.getServiceId());
        assertThat(deleted).isNull();

        createdServiceIds.remove(Integer.valueOf(service.getServiceId()));
    }

    @Test
    void getActiveServices_ShouldReturnOnlyActiveServices() {
        Service activeService = persist(buildService("Active Service " + UUID.randomUUID(),
                new BigDecimal("11.00"), 30, true, defaultCategoryId));
        Service inactiveService = persist(buildService("Inactive Service " + UUID.randomUUID(),
                new BigDecimal("13.00"), 30, false, defaultCategoryId));

        List<Service> activeServices = serviceDAO.getActiveServices();
        assertThat(activeServices)
                .extracting(Service::getServiceId)
                .contains(activeService.getServiceId())
                .doesNotContain(inactiveService.getServiceId());
    }

    @Test
    void getServicesByCategoryId_ShouldReturnCorrectServices() {
        Service defaultCatService = persist(buildService("Default Category Service " + UUID.randomUUID(),
                new BigDecimal("19.00"), 40, true, defaultCategoryId));
        Service alternateCatService = persist(buildService("Alternate Category Service " + UUID.randomUUID(),
                new BigDecimal("21.00"), 50, true, alternateCategoryId));

        List<Service> defaultCategoryServices = serviceDAO.getServicesByCategoryId(defaultCategoryId);
        assertThat(defaultCategoryServices)
                .extracting(Service::getServiceId)
                .contains(defaultCatService.getServiceId())
                .doesNotContain(alternateCatService.getServiceId());
    }

    @Test
    void getServicesByCategoryId_WithUnknownId_ShouldReturnEmptyList() {
        persist(buildService("Unknown Filter Service " + UUID.randomUUID(),
                new BigDecimal("17.00"), 30, true, defaultCategoryId));

        List<Service> services = serviceDAO.getServicesByCategoryId(Integer.MAX_VALUE);
        assertThat(services).isEmpty();
    }

    @Nested
    @DisplayName("Tests for searchServices method")
    class SearchServicesTests {

        @Test
        void searchByKeyword_ShouldReturnMatchingServices() {
            String token = "KeywordToken-" + UUID.randomUUID();
            Service match = persist(buildService(token + " Deluxe",
                    new BigDecimal("40.00"), 60, true, defaultCategoryId));
            persist(buildService("Random Service " + UUID.randomUUID(),
                    new BigDecimal("35.00"), 45, true, defaultCategoryId));

            List<Service> results = serviceDAO.searchServices(token, null, null, null, null);
            assertThat(results)
                    .extracting(Service::getServiceId)
                    .contains(match.getServiceId());
        }

        @Test
        void searchByCategoryId_ShouldReturnServicesInCategory() {
            String token = "CategoryToken-" + UUID.randomUUID();
            Service defaultCatService = persist(buildService(token + " Default",
                    new BigDecimal("28.00"), 40, true, defaultCategoryId));
            persist(buildService(token + " Alternate",
                    new BigDecimal("32.00"), 50, true, alternateCategoryId));

            List<Service> results = serviceDAO.searchServices(token, defaultCategoryId, null, null, null);
            assertThat(results)
                    .extracting(Service::getServiceId)
                    .contains(defaultCatService.getServiceId());
        }

        @Test
        void searchByIsActive_ShouldReturnMatchingServices() {
            String token = "ActiveToken-" + UUID.randomUUID();
            Service activeService = persist(buildService(token + " Active",
                    new BigDecimal("26.00"), 30, true, defaultCategoryId));
            Service inactiveService = persist(buildService(token + " Inactive",
                    new BigDecimal("27.00"), 30, false, defaultCategoryId));

            List<Service> activeResults = serviceDAO.searchServices(token, null, true, null, null);
            assertThat(activeResults)
                    .extracting(Service::getServiceId)
                    .contains(activeService.getServiceId())
                    .doesNotContain(inactiveService.getServiceId());
        }

        @Test
        void searchWithSortByPriceDesc_ShouldReturnSortedResults() {
            String token = "PriceToken-" + UUID.randomUUID();
            Service cheap = persist(buildService(token + " Cheap",
                    new BigDecimal("15.00"), 20, true, defaultCategoryId));
            Service mid = persist(buildService(token + " Mid",
                    new BigDecimal("25.00"), 30, true, defaultCategoryId));
            Service expensive = persist(buildService(token + " Expensive",
                    new BigDecimal("35.00"), 45, true, defaultCategoryId));

            List<Service> results = serviceDAO.searchServices(token, null, null, "price", "DESC");
            assertThat(results)
                    .extracting(Service::getServiceId)
                    .containsExactly(expensive.getServiceId(), mid.getServiceId(), cheap.getServiceId());
        }

        @Test
        void searchWithSortByCategoryNameAsc_ShouldReturnSortedResults() {
            String token = "CategorySort-" + UUID.randomUUID();
            int catA = createCategory("AAA-Category");
            int catB = createCategory("ZZZ-Category");

            Service serviceA = persist(buildService(token + " A",
                    new BigDecimal("18.00"), 25, true, catA));
            Service serviceB = persist(buildService(token + " B",
                    new BigDecimal("22.00"), 35, true, catB));

            List<Service> results = serviceDAO.searchServices(token, null, null, "category", "ASC");
            assertThat(results)
                    .extracting(Service::getServiceId)
                    .containsExactly(serviceA.getServiceId(), serviceB.getServiceId());
        }

        @Test
        void searchWithDefaultSort_ShouldFallbackToServiceIdAsc() {
            String token = "DefaultSort-" + UUID.randomUUID();
            Service first = persist(buildService(token + " First",
                    new BigDecimal("23.00"), 30, true, defaultCategoryId));
            Service second = persist(buildService(token + " Second",
                    new BigDecimal("24.00"), 30, true, defaultCategoryId));

            List<Service> results = serviceDAO.searchServices(token, null, null, null, "ASC");
            assertThat(results)
                    .extracting(Service::getServiceId)
                    .containsExactly(first.getServiceId(), second.getServiceId());
        }

        @Test
        void searchWithMultipleFilters_ShouldReturnFilteredAndSortedResults() {
            String token = "MultiToken-" + UUID.randomUUID();
            Service matching = persist(buildService(token + " Match",
                    new BigDecimal("19.00"), 30, true, defaultCategoryId));
            persist(buildService(token + " Other",
                    new BigDecimal("21.00"), 40, false, alternateCategoryId));

            List<Service> results = serviceDAO.searchServices(token, defaultCategoryId, true, "price", "ASC");
            assertThat(results)
                    .extracting(Service::getServiceId)
                    .containsExactly(matching.getServiceId());
        }
    }
}
