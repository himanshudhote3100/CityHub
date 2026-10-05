package com.city.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.AnswerDaoImpl;
import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.Answer;
import com.city.pojo.CityUsers;
import com.city.dbutil.DBUtil;

@WebServlet("/AnswerServlet")
public class AnswerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        String qIdStr = request.getParameter("questionId");
        String answerText = request.getParameter("answer");

        if (qIdStr == null || qIdStr.trim().isEmpty() || answerText == null || answerText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
            return;
        }

        int questionId = Integer.parseInt(qIdStr);
        Answer a = new Answer();
        a.setQuestionId(questionId);
        a.setAnswer(answerText);
        a.setAnswerUsername(email);

        AnswerDaoImpl answerDao = new AnswerDaoImpl();
        boolean success = answerDao.postAnswer(a);

        if (success) {
            CityUsersDaoImpl userDao = new CityUsersDaoImpl();
            int pointsToAward = 3;
            userDao.updateHubPoints(email, pointsToAward);
            
            // Refresh session user attribute to keep profile in sync
            CityUsers updatedUser = userDao.getUserByMail(email);
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            
            session.setAttribute("toastMsg", "Answer posted successfully! Earned " + pointsToAward + " Hub points!");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMsg", "Failed to post answer. Please try again.");
            session.setAttribute("toastType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/QuestionDetailServlet?id=" + questionId);
    }
}
