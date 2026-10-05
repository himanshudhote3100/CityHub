package com.city.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.CityUsers;
import com.city.util.EmailValidator;

@WebServlet("/CityRegisterServlet")
public class CityRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String mail = request.getParameter("mail");
        String passcode = request.getParameter("passcode");
        String city = request.getParameter("city");

        if (!EmailValidator.isValidGoogleEmail(mail)) {
            request.setAttribute("regError", "Only valid registered Google email IDs (@gmail.com) are allowed.");
            RequestDispatcher rd = request.getRequestDispatcher("/register.jsp");
            rd.forward(request, response);
            return;
        }

        CityUsers c = new CityUsers();
        c.setFirstname(firstname);
        c.setLastname(lastname);
        c.setMail(mail);
        c.setPasscode(passcode);
        c.setCity(city);
        c.setHubPoints(0);
        c.setProfilePic("https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150");

        CityUsersDaoImpl dao = new CityUsersDaoImpl();
        if (dao.registeruser(c)) {
            request.setAttribute("regSuccess", "Account created successfully! Please sign in.");
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
        } else {
            request.setAttribute("regError", "Registration failed. Email might already be registered.");
            RequestDispatcher rd = request.getRequestDispatcher("/register.jsp");
            rd.forward(request, response);
        }
    }
}
