package com.petcaresystem.controller.service;
import com.petcaresystem.dao.ServiceDAO;
import com.petcaresystem.enities.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
@WebServlet(name = "ServiceController", urlPatterns = {"/services"})
public class ServiceController extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        this.serviceDAO = new ServiceDAO();
    }
    private String getDetailedDescription(String serviceName) {
        if (serviceName == null) return "This is a specialized pet care service at PetCare System. Please contact us for more details.";
        return switch (serviceName.toLowerCase().trim()) {
            case "general checkup" ->
                    "Our General Health Checkup offers a cornerstone of preventative care. This comprehensive package includes a thorough physical examination, vital signs assessment, and basic blood screening (CBC and Chemistry Profile) to establish baseline health. We focus on early detection of age-related diseases, parasite prevention, and personalized nutritional and behavioral counseling. Schedule this annual exam to ensure your pet maintains optimal wellness and a longer, happier life.";

            case "emergency consultation" ->
                    "The Emergency Consultation provides immediate, critical care for unexpected illness, trauma, or poisoning. Our dedicated veterinary team is on-call 24/7, equipped with advanced diagnostic tools (digital radiography, ultrasound) and life support systems. The consultation includes rapid stabilization, pain management, and a definitive diagnosis plan. We are committed to providing swift, expert intervention when every second counts for your beloved pet.";

            case "vaccination" ->
                    "Our Vaccination program is tailored to your pet's lifestyle, environment, and age. We provide essential core vaccines (such as Rabies, Canine Distemper, and Feline Panleukopenia) as well as non-core vaccines (like Bordetella or Feline Leukemia) based on risk assessment. Each appointment includes a brief physical exam to ensure your pet is healthy enough for vaccination, protecting them against devastating infectious diseases and complying with public health mandates.";

            case "basic grooming" ->
                    "The Basic Grooming service is designed for routine maintenance and comfort. This luxurious experience includes a deep cleansing bath with professional-grade shampoo, a high-velocity drying, full brush-out to prevent matting, ear cleaning, and a nail trim. Regular grooming promotes a healthy coat and skin, reduces shedding, and allows our staff to perform quick checks for external parasites or skin irregularities.";

            case "dental cleaning" ->
                    "Our comprehensive Dental Cleaning service is performed under general anesthesia for your pet's safety and comfort. The procedure includes full mouth scaling (removing plaque and tartar above and below the gum line), tooth polishing to smooth the enamel, and a complete oral health assessment with digital dental X-rays. Addressing dental disease is crucial, as oral infections can significantly impact heart, liver, and kidney health.";

            case "spay/neuter surgery" ->
                    "The Spay/Neuter Surgery is a routine but significant procedure performed in a sterile surgical suite. We prioritize patient safety with pre-anesthetic blood work, continuous heart rate and oxygen saturation monitoring, and dedicated anesthetic support. The procedure is key to controlling pet population, significantly reduces the risk of mammary and testicular cancers, and often mitigates unwanted behaviors like roaming and aggression. Comprehensive post-operative pain management is included.";

            default -> "This is a specialized pet care service offered by PetCare System. This service is essential for maintaining the health and happiness of your companion. Please contact our reception team directly for a full breakdown of the procedures and benefits included in this package.";
        };
    }
    private String getServiceImageName(String serviceName) {
        if (serviceName == null) return "service-placeholder.jpg";
        return switch (serviceName.toLowerCase().trim()) {
            case "general checkup" -> "generalhealth.jpg";
            case "emergency consultation" -> "emergency.jpg";
            case "vaccination" -> "vacciation.jpg";
            case "basic grooming" -> "grooming.jpg";
            case "dental cleaning" -> "dentalpet.jpg";
            case "spay/neuter surgery" -> "spay.jpg";
            default -> "pethome.jpg";
        };
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String serviceIdParam = request.getParameter("id");

        if (serviceIdParam == null || serviceIdParam.isEmpty()) {
            showServiceListPage(request, response);
        } else {
            showServiceDetailPage(request, response, serviceIdParam);
        }
    }
    private void showServiceListPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Service> serviceList = serviceDAO.getActiveServices();

            // Prepare Maps to hold custom data for JSP
            Map<Integer, String> detailedDescriptions = new HashMap<>();
            Map<Integer, String> imageNames = new HashMap<>();

            for (Service service : serviceList) {
                // Ánh xạ mô tả chi tiết và tên ảnh cho từng service
                detailedDescriptions.put(service.getServiceId(), getDetailedDescription(service.getServiceName()));
                imageNames.put(service.getServiceId(), getServiceImageName(service.getServiceName()));
            }

            request.setAttribute("serviceList", serviceList);
            request.setAttribute("detailedDescriptions", detailedDescriptions); // NEW ATTRIBUTE
            request.setAttribute("imageNames", imageNames); // NEW ATTRIBUTE

            request.getRequestDispatcher("/customer/services.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showServiceDetailPage(HttpServletRequest request, HttpServletResponse response, String serviceIdParam)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(serviceIdParam);
            Service service = serviceDAO.getServiceById(serviceId);

            if (service != null && service.isActive()) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/customer/service-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Service not found or is no longer available.");
                showServiceListPage(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid service ID.");
            showServiceListPage(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching service details.");
            showServiceListPage(request, response);
        }
    }
}