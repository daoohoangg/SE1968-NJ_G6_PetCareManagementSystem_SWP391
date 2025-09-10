# SE1968-NJ_G6_PetCareManagementSystem_SWP391

> Pet Care Management System – SWP391 course project.

![Java](https://img.shields.io/badge/Java-17-blue)
![Maven](https://img.shields.io/badge/Maven-3%2B-orange)
![Servlet](https://img.shields.io/badge/Jakarta%20Servlet-6.1-green)
![Status](https://img.shields.io/badge/Status-Work%20in%20progress-yellow)

---

## 1) What – What is this project?
A web application to manage pet care services: booking, grooming, medical checkups, and payments for admins, staff, and pet owners.

### Planned core features
- User management: Administrator, Manager, Staff (Receptionist/Cashier/Caretaker/Groomer/Veterinarian), Pet Owner.
- Pet profiles, medical/vaccine records, appointments, services, invoices.
- Scheduler/Reminders, notifications (email/sms – optional).
- (Extended) Inventory management for supplies/tools.

---

## 2) Why – Why build this?
- Standardize service and payment workflows.  
- Enhance customer experience (online booking, notifications).  
- Reduce manual errors and support business scalability.  

---

## 3) Who – Who are the users?
- **Admin/Manager**: system setup, permissions, reports.  
- **Staff**: receptionist, cashier, caretaker, groomer, veterinarian.  
- **Pet Owner**: booking and tracking their pets’ records.  

---

## 4) Where – Where does it run?
- Development: local machine + Tomcat 10.1+.  
- Production: Java server (on-prem or cloud) / container.  

---

## 5) When – When to use?
- During the SWP391 semester and potentially extended into a real-world product.  

---

## 6) How – Architecture & Usage

### 6.1. Tech stack
- **Java 17**, **Maven**  
- **Jakarta Servlet API 6.1** (`provided`)  
- **Hibernate ORM** (7.x Beta – may switch to stable 6.x later)  
- **JAXB Runtime**  

### 6.2. Suggested folder structure
```
src/
 └─ main/
     ├─ java/               
     ├─ resources/          
     └─ webapp/             
         └─ WEB-INF/
             ├─ web.xml     
             └─ views/      
```

### 6.3. Example URL mapping
- `GET /home` → HomeServlet → forward to `WEB-INF/views/home.jsp`

### 6.4. Build & Run
```bash
# clone
git clone https://github.com/daoohoangg/SE1968-NJ_G6_PetCareManagementSystem_SWP391.git
cd SE1968-NJ_G6_PetCareManagementSystem_SWP391

# build
mvn clean package

# deploy WAR to Tomcat and open http://localhost:8080/home
```

---

## Short Roadmap
- [ ] Design ERD + migration script.  
- [ ] Implement “Booking Appointment” workflow.  
- [ ] Manage services and pricing.  
- [ ] Basic invoices/payments.  
- [ ] Role-based access control.  
- [ ] Notifications (email/SMS) – optional.  

---

## Contribution
- Branch naming: `feature/*`, `fix/*`, `chore/*`.  
- Small PRs with clear **What/Why/How** and screenshots for UI.  
- Run `mvn test` before submitting PR.  

---

## Contact
- Team: SE1968-NJ_G6 – SWP391  
- Maintainer: add name + email here.  
