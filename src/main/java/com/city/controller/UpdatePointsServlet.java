package com.city.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.CityUsers;

@WebServlet("/UpdatePointsServlet")
public class UpdatePointsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.setStatus(401);
            return;
        }

        String email = (String) session.getAttribute("email");
        String ptsStr = request.getParameter("points");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            if (ptsStr != null) {
                int points = Integer.parseInt(ptsStr);
                CityUsersDaoImpl userDao = new CityUsersDaoImpl();
                boolean success = userDao.updateHubPoints(email, points);
                if (success) {
                    // Refresh session user attribute
                    CityUsers updatedUser = userDao.getUserByMail(email);
                    if (updatedUser != null) {
                        session.setAttribute("user", updatedUser);
                    }
                    out.print("{\"status\":\"success\", \"message\":\"" + points + " points added successfully!\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Failed to update points in database.\"}");
                }
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Points parameter missing.\"}");
            }
        } catch (Exception e) {
            out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
}
