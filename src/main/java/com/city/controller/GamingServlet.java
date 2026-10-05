package com.city.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.AnswerDaoImpl;
import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.CityUsers;

@WebServlet("/GamingServlet")
public class GamingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        CityUsersDaoImpl userDao = new CityUsersDaoImpl();
        AnswerDaoImpl answerDao = new AnswerDaoImpl();

        CityUsers user = userDao.getUserByMail(email);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int pts = user.getHubPoints();

        request.setAttribute("user", user);
        request.setAttribute("hubPoints", pts);

        RequestDispatcher rd = request.getRequestDispatcher("/gaming.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
