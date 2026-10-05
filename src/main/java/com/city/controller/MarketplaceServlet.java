package com.city.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.MarketplaceDaoImpl;
import com.city.pojo.MarketplaceItem;
import com.city.pojo.CityUsers;

@WebServlet("/MarketplaceServlet")
public class MarketplaceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String category = request.getParameter("cat");
        String city = request.getParameter("city");

        MarketplaceDaoImpl dao = new MarketplaceDaoImpl();
        List<MarketplaceItem> itemList;

        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("all")) {
            itemList = dao.getItemsByCategory(category.trim());
        } else {
            itemList = dao.getAllItems();
        }

        if (city != null && !city.trim().isEmpty()) {
            String lowerCity = city.trim().toLowerCase();
            List<MarketplaceItem> filtered = new ArrayList<>();
            for (MarketplaceItem item : itemList) {
                if (item.getCity() != null && item.getCity().toLowerCase().contains(lowerCity)) {
                    filtered.add(item);
                }
            }
            itemList = filtered;
        }

        request.setAttribute("itemList", itemList);
        RequestDispatcher rd = request.getRequestDispatcher("/marketplace.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        MarketplaceDaoImpl dao = new MarketplaceDaoImpl();

        if ("add".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String category = request.getParameter("category");
            String contactInfo = request.getParameter("contactInfo");
            String imageUrl = request.getParameter("imageUrl");
            String city = request.getParameter("city");

            double price = 0.0;
            try {
                if (priceStr != null && !priceStr.trim().isEmpty()) {
                    price = Double.parseDouble(priceStr);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid price format: " + priceStr);
            }

            CityUsers loggedInUser = (CityUsers) session.getAttribute("user");
            String sellerMail = (String) session.getAttribute("email");
            
            if (city == null || city.trim().isEmpty()) {
                city = loggedInUser != null ? loggedInUser.getCity() : "Unknown";
            }

            MarketplaceItem item = new MarketplaceItem();
            item.setTitle(title);
            item.setDescription(description);
            item.setPrice(price);
            item.setCategory(category);
            item.setSellerMail(sellerMail);
            item.setContactInfo(contactInfo);
            item.setImageUrl(imageUrl != null && !imageUrl.trim().isEmpty() ? imageUrl : "https://images.unsplash.com/photo-1542838132-92c53300491e?w=300");
            item.setCity(city);

            boolean success = dao.addItem(item);
            if (success) {
                session.setAttribute("toastMsg", "Listing added successfully!");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMsg", "Failed to add listing.");
                session.setAttribute("toastType", "error");
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("itemId");
            try {
                if (idStr != null) {
                    int id = Integer.parseInt(idStr);
                    boolean success = dao.deleteItem(id);
                    if (success) {
                        session.setAttribute("toastMsg", "Listing deleted.");
                        session.setAttribute("toastType", "success");
                    } else {
                        session.setAttribute("toastMsg", "Failed to delete listing.");
                        session.setAttribute("toastType", "error");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/MarketplaceServlet");
    }
}
