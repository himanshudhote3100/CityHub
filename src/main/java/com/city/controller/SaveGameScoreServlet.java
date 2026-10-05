package com.city.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.CityUsers;
import com.city.dbutil.DBUtil;

/**
 * Mapped to /SaveGameScoreServlet
 * Receives the score and points earned from the frontend,
 * stores them in MySQL database, and updates the user's session profile.
 */
@WebServlet("/SaveGameScoreServlet")
public class SaveGameScoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            out.print("{\"status\":\"error\", \"message\":\"User not logged in.\"}");
            return;
        }

        String email = (String) session.getAttribute("email");
        String gameName = request.getParameter("gameName");
        String scoreStr = request.getParameter("score");
        String pointsEarnedStr = request.getParameter("pointsEarned");

        // Validate parameters
        if (gameName == null || scoreStr == null || pointsEarnedStr == null) {
            out.print("{\"status\":\"error\", \"message\":\"Missing parameters.\"}");
            return;
        }

        try {
            int score = Integer.parseInt(scoreStr);
            int pointsEarned = Integer.parseInt(pointsEarnedStr);

            // 1. Save game score in game_scores table
            String insertSql = "INSERT INTO game_scores (email, game_name, score, points_earned) VALUES (?, ?, ?, ?)";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setString(1, email);
                ps.setString(2, gameName);
                ps.setInt(3, score);
                ps.setInt(4, pointsEarned);
                ps.executeUpdate();
            }

            // 2. Update user's hub points in users table
            CityUsersDaoImpl userDao = new CityUsersDaoImpl();
            userDao.updateHubPoints(email, pointsEarned);

            // 3. Retrieve the updated user and refresh the session
            CityUsers updatedUser = userDao.getUserByMail(email);
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }

            // Send success JSON response
            out.print("{\"status\":\"success\", \"message\":\"Saved score successfully! Earned " + pointsEarned + " Hub Points.\", \"newPoints\":" + (updatedUser != null ? updatedUser.getHubPoints() : 0) + "}");

        } catch (Exception e) {
            System.err.println("Error saving game score: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"Internal server error while saving score.\"}");
        }
    }
}
