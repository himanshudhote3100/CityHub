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

@WebServlet("/GoogleAuthServlet")
public class GoogleAuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("mail");
        String action = request.getParameter("action");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (email == null || email.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Email is required.\"}");
            return;
        }

        email = email.trim().toLowerCase();
        CityUsersDaoImpl userDao = new CityUsersDaoImpl();
        CityUsers user = userDao.getUserByMail(email);

        if ("check".equalsIgnoreCase(action)) {
            if (user != null) {
                // User exists, log them in immediately
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("user", user);
                session.setAttribute("toastMsg", "Welcome back, " + user.getFirstname() + "!");
                session.setAttribute("toastType", "success");
                
                out.print("{\"status\":\"success\", \"exists\":true, \"redirect\":\"home.jsp\"}");
            } else {
                // User doesn't exist, need profile details
                out.print("{\"status\":\"new_user\", \"exists\":false, \"email\":\"" + email + "\"}");
            }
        } else if ("register".equalsIgnoreCase(action)) {
            String firstname = request.getParameter("firstname");
            String lastname = request.getParameter("lastname");
            String city = request.getParameter("city");
            String profilePic = request.getParameter("profile_pic");

            if (firstname == null || firstname.trim().isEmpty() ||
                lastname == null || lastname.trim().isEmpty() ||
                city == null || city.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"First name, last name and city are required to complete profile.\"}");
                return;
            }

            // Create new Google user in database
            CityUsers c = new CityUsers();
            c.setMail(email);
            c.setFirstname(firstname.trim());
            c.setLastname(lastname.trim());
            c.setCity(city.trim());
            c.setPasscode("google_authenticated_user"); // Dummy password for oauth users
            c.setHubPoints(0);
            c.setProfilePic(profilePic != null && !profilePic.trim().isEmpty() ? profilePic.trim() : "https://ui-avatars.com/api/?name=" + firstname.trim() + "+" + lastname.trim() + "&background=dbeafe&color=1d4ed8&size=200");

            boolean success = userDao.registeruser(c);
            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("user", c);
                session.setAttribute("toastMsg", "Account created successfully with Google!");
                session.setAttribute("toastType", "success");
                out.print("{\"status\":\"success\", \"exists\":true, \"redirect\":\"home.jsp\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Failed to create account in database.\"}");
            }
        } else {
            out.print("{\"status\":\"error\", \"message\":\"Invalid action.\"}");
        }
        out.flush();
    }
}
