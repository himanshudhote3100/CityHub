package com.city.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.AnswerDaoImpl;
import com.city.daoimpl.CityUsersDaoImpl;
import com.city.daoimpl.FriendDaoImpl;
import com.city.pojo.CityUsers;
import com.city.pojo.PostQuestions;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String loggedInEmail = (String) session.getAttribute("email");
        String email = request.getParameter("mail");
        boolean isOwnProfile = true;

        if (email == null || email.trim().isEmpty()) {
            email = loggedInEmail;
        } else if (!email.equals(loggedInEmail)) {
            isOwnProfile = false;
        }

        CityUsersDaoImpl userDao = new CityUsersDaoImpl();
        AnswerDaoImpl answerDao = new AnswerDaoImpl();
        FriendDaoImpl friendDao = new FriendDaoImpl();

        CityUsers user = userDao.getUserByMail(email);
        if (user == null) {
            email = loggedInEmail;
            user = userDao.getUserByMail(email);
            isOwnProfile = true;
        }

        int totalAnswers = answerDao.getAnswerCountByUser(email);
        
        String badge = "Novice Explorer";
        if (totalAnswers >= 100) {
            badge = "Helping Avenger";
        } else if (totalAnswers >= 50) {
            badge = "Helping Guardian";
        } else if (totalAnswers >= 25) {
            badge = "Helping Hero";
        }

        boolean isFriend = false;
        if (!isOwnProfile) {
            isFriend = friendDao.isFriend(loggedInEmail, email);
        }

        int friendsCount = friendDao.getFriends(email).size();
        List<PostQuestions> userQuestions = userDao.getQuestionsByMail(email);

        request.setAttribute("profileUser", user);
        request.setAttribute("userQuestions", userQuestions);
        request.setAttribute("badge", badge);
        request.setAttribute("friendsCount", friendsCount);
        request.setAttribute("totalAnswers", totalAnswers);
        request.setAttribute("isOwnProfile", isOwnProfile);
        request.setAttribute("isFriend", isFriend);

        RequestDispatcher rd = request.getRequestDispatcher("/profile.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
