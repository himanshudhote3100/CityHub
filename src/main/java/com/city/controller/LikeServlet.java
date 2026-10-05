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

import com.city.dbutil.DBUtil;

@WebServlet("/LikeServlet")
public class LikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        String qIdStr = request.getParameter("questionId");
        String redirectStr = request.getParameter("redirect");

        if (qIdStr == null || qIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
            return;
        }

        int questionId = Integer.parseInt(qIdStr);

        try (Connection con = DBUtil.getConnection()) {
            boolean alreadyLiked = false;
            String checkSql = "SELECT 1 FROM question_likes WHERE question_id = ? AND user_mail = ?";
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, questionId);
                ps.setString(2, email);
                try (ResultSet rs = ps.executeQuery()) {
                    alreadyLiked = rs.next();
                }
            }

            if (alreadyLiked) {
                String deleteSql = "DELETE FROM question_likes WHERE question_id = ? AND user_mail = ?";
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setInt(1, questionId);
                    ps.setString(2, email);
                    ps.executeUpdate();
                }

                String decrementSql = "UPDATE city_questions SET likes_count = GREATEST(likes_count - 1, 0) WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(decrementSql)) {
                    ps.setInt(1, questionId);
                    ps.executeUpdate();
                }
            } else {
                String insertSql = "INSERT INTO question_likes (question_id, user_mail) VALUES (?, ?)";
                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, questionId);
                    ps.setString(2, email);
                    ps.executeUpdate();
                }

                String incrementSql = "UPDATE city_questions SET likes_count = likes_count + 1 WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(incrementSql)) {
                    ps.setInt(1, questionId);
                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            System.err.println("Exception handling like: " + e.getMessage());
            e.printStackTrace();
        }

        if ("detail".equalsIgnoreCase(redirectStr)) {
            response.sendRedirect(request.getContextPath() + "/QuestionDetailServlet?id=" + questionId);
        } else {
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
