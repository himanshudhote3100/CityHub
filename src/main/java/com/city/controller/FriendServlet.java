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

import com.city.daoimpl.FriendDaoImpl;
import com.city.pojo.CityUsers;

@WebServlet("/FriendServlet")
public class FriendServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        String action = request.getParameter("action");

        FriendDaoImpl friendDao = new FriendDaoImpl();

        if (action != null && !action.trim().isEmpty()) {
            String friendMail = request.getParameter("friendMail");
            if (friendMail != null && !friendMail.trim().isEmpty()) {
                if ("add".equalsIgnoreCase(action)) {
                    friendDao.addFriend(email, friendMail);
                    session.setAttribute("toastMsg", "Added " + friendMail + " to friends!");
                    session.setAttribute("toastType", "success");
                } else if ("remove".equalsIgnoreCase(action)) {
                    friendDao.removeFriend(email, friendMail);
                    session.setAttribute("toastMsg", "Removed " + friendMail + " from friends.");
                    session.setAttribute("toastType", "success");
                }
            }
            String redirect = request.getParameter("redirect");
            if ("profile".equalsIgnoreCase(redirect)) {
                response.sendRedirect(request.getContextPath() + "/ProfileServlet?mail=" + friendMail);
            } else {
                response.sendRedirect(request.getContextPath() + "/FriendServlet");
            }
            return;
        }

        List<CityUsers> friends = friendDao.getFriends(email);
        List<CityUsers> nonFriends = friendDao.getNonFriends(email);

        request.setAttribute("friendsList", friends);
        request.setAttribute("nonFriendsList", nonFriends);

        RequestDispatcher rd = request.getRequestDispatcher("/friends.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
