package com.petcaresystem.controller.staff;

import com.petcaresystem.dao.AppointmentDAO;
import com.petcaresystem.enities.Account;
import com.petcaresystem.enities.Appointment;
import com.petcaresystem.enities.enu.AccountRoleEnum;
import com.petcaresystem.enities.enu.AppointmentStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
@WebServlet(name = "StaffTaskController", urlPatterns = {"/staff/task"})
public class StaffTaskController extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Account loggedInAccount = (Account) session.getAttribute("account");
        if (loggedInAccount == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (loggedInAccount.getRole() != AccountRoleEnum.STAFF) {
            if (loggedInAccount.getRole() == AccountRoleEnum.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }

        try {
            Long staffId = loggedInAccount.getAccountId();
            List<Appointment> taskList = appointmentDAO.getTasksForStaff(staffId);

            request.setAttribute("taskList", taskList);
            request.getRequestDispatcher("/staff/task.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading task list.");
            request.getRequestDispatcher("/staff/task.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Account loggedInStaff = (Account) session.getAttribute("account");

        if (loggedInStaff == null || loggedInStaff.getRole() != AccountRoleEnum.STAFF) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            Long staffId = loggedInStaff.getAccountId();
            Long appointmentId = Long.parseLong(request.getParameter("appointmentId"));
            String action = request.getParameter("action");
            String notes = request.getParameter("notes");

            AppointmentStatus newStatus = null;
            String successMessage = "";

            if ("start".equals(action)) {
                newStatus = AppointmentStatus.IN_PROGRESS;
                successMessage = "Task #" + appointmentId + " started / note saved.";
            } else if ("complete".equals(action)) {
                newStatus = AppointmentStatus.COMPLETED;
                successMessage = "Task #" + appointmentId + " completed.";
            }

            if (newStatus != null) {
                boolean success = appointmentDAO.updateTaskStatus(appointmentId, staffId, newStatus, notes);

                if (success) {
                    request.getSession().setAttribute("success", successMessage);
                } else {
                    request.getSession().setAttribute("error", "Error: You do not have permission for this task.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error processing task.");
        }
        response.sendRedirect(request.getContextPath() + "/staff/task");
    }
}