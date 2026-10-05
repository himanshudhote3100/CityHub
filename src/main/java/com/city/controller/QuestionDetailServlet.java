package com.city.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.city.daoimpl.AnswerDaoImpl;
import com.city.pojo.Answer;
import com.city.pojo.PostQuestions;
import com.city.dbutil.DBUtil;

@WebServlet("/QuestionDetailServlet")
public class QuestionDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
            return;
        }

        int qId = Integer.parseInt(idStr);
        PostQuestions q = null;

        String sql = "SELECT q.*, u.profile_pic FROM city_questions q LEFT JOIN users u ON q.mail = u.email WHERE q.id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, qId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    q = new PostQuestions();
                    q.setId(rs.getInt("id"));
                    q.setMail(rs.getString("mail"));
                    q.setTitle(rs.getString("title"));
                    q.setDescription(rs.getString("description"));
                    q.setLocation(rs.getString("location"));
                    q.setCategory(rs.getString("category"));
                    q.setImage(rs.getString("image"));
                    q.setLikesCount(rs.getInt("likes_count"));
                    q.setCreatedAt(rs.getTimestamp("created_at"));
                    q.setProfilePic(rs.getString("profile_pic"));
                }
            }
        } catch (Exception e) {
            System.err.println("Exception fetching question detail: " + e.getMessage());
            e.printStackTrace();
        }

        if (q == null) {
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
            return;
        }

        AnswerDaoImpl answerDao = new AnswerDaoImpl();
        List<Answer> answers = answerDao.getAnswersForQuestion(qId);

        request.setAttribute("question", q);
        request.setAttribute("answers", answers);

        RequestDispatcher rd = request.getRequestDispatcher("/question-detail.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
