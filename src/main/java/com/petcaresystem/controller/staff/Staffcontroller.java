package com.petcaresystem.controller.staff;

import com.petcaresystem.dao.StaffDAO;
import com.petcaresystem.dto.staff.StaffDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/staff")
public class Staffcontroller extends HttpServlet {
    private StaffDAO staffDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
    }

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");
    if (action == null) {
        action = "list";
    }

    switch (action) {
        case "new":

            break;
        case "edit":

            break;
        case "delete":

            break;
        default:

            break;
    }
}
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";

            switch (action) {
                case "insert":

                    break;
                case "update":

                    break;
                default:
                    response.sendRedirect("staff?action=list");
                    break;
            }
        }

