package com.city.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.CityUsersDaoImpl;
import com.city.daoimpl.FriendDaoImpl;
import com.city.pojo.CityUsers;
import com.city.pojo.PostQuestions;

@WebServlet("/ViewQuestionsServlet")
public class ViewQuestionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String currentUserEmail = (session != null) ? (String) session.getAttribute("email") : null;

        CityUsersDaoImpl dao = new CityUsersDaoImpl();
        List<PostQuestions> allQuestions = dao.getAllQuestions();

        Set<String> friendEmails = new HashSet<>();
        if (currentUserEmail != null) {
            FriendDaoImpl friendDao = new FriendDaoImpl();
            List<CityUsers> friends = friendDao.getFriends(currentUserEmail);
            for (CityUsers f : friends) {
                friendEmails.add(f.getMail());
            }
        }

        List<PostQuestions> sortedList = new ArrayList<>(allQuestions);
        sortedList.sort((q1, q2) -> {
            if (currentUserEmail != null) {
                boolean q1Friend = friendEmails.contains(q1.getMail());
                boolean q2Friend = friendEmails.contains(q2.getMail());
                if (q1Friend && !q2Friend) return -1;
                if (!q1Friend && q2Friend) return 1;
            }

            return Integer.compare(q2.getId(), q1.getId());
        });

        request.setAttribute("qList", sortedList);

        String categoryFilter = request.getParameter("cat");
        if (categoryFilter != null && !categoryFilter.trim().isEmpty() && !categoryFilter.equalsIgnoreCase("all")) {
            List<PostQuestions> filteredList = new ArrayList<>();
            for (PostQuestions q : sortedList) {
                if (q.getCategory() != null && q.getCategory().equalsIgnoreCase(categoryFilter)) {
                    filteredList.add(q);
                }
            }
            request.setAttribute("qList", filteredList);
        }

        RequestDispatcher rd = request.getRequestDispatcher("/questions.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
