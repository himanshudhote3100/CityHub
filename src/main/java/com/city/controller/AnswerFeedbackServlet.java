package com.city.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.AnswerDaoImpl;

@WebServlet("/AnswerFeedbackServlet")
public class AnswerFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String aIdStr = request.getParameter("answerId");
        String qIdStr = request.getParameter("questionId");

        if (aIdStr == null || aIdStr.trim().isEmpty() || qIdStr == null || qIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
            return;
        }

        int answerId = Integer.parseInt(aIdStr);
        int questionId = Integer.parseInt(qIdStr);

        AnswerDaoImpl dao = new AnswerDaoImpl();

        if ("upvote".equalsIgnoreCase(action)) {
            dao.upvoteAnswer(answerId);
            session.setAttribute("toastMsg", "Answer upvoted!");
            session.setAttribute("toastType", "success");
        } else if ("downvote".equalsIgnoreCase(action)) {
            dao.downvoteAnswer(answerId);
            session.setAttribute("toastMsg", "Answer downvoted!");
            session.setAttribute("toastType", "success");
        } else if ("rate".equalsIgnoreCase(action)) {
            String ratingStr = request.getParameter("rating");
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                int rating = Integer.parseInt(ratingStr);
                dao.rateAnswer(answerId, rating);
                session.setAttribute("toastMsg", "Rating recorded!");
                session.setAttribute("toastType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/QuestionDetailServlet?id=" + questionId);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
