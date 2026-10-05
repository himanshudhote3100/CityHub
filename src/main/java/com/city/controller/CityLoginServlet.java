package com.city.controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.pojo.CityUsers;
import com.city.daoimpl.CityUsersDaoImpl;
import com.city.util.EmailValidator;

@WebServlet("/CityLoginServlet")
public class CityLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mail = request.getParameter("mail");
        String passcode = request.getParameter("passcode");

        if (!EmailValidator.isValidGoogleEmail(mail)) {
            request.setAttribute("loginError", "Only valid registered Google email IDs (@gmail.com) are allowed.");
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
            return;
        }

        CityUsers c = new CityUsers();
        c.setMail(mail);
        c.setPasscode(passcode);

        CityUsersDaoImpl dao = new CityUsersDaoImpl();
        if (dao.checkuser(c)) {
            CityUsers userDetails = dao.getUserByMail(mail);
            HttpSession session = request.getSession();
            session.setAttribute("email", mail);
            session.setAttribute("user", userDetails);
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        } else {
            request.setAttribute("loginError", "Invalid username or password");
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
        }
    }
}
