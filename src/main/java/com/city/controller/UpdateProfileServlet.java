package com.city.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.CityUsers;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String city = request.getParameter("city");

        // Retrieve existing profile pic from session/database to fallback on
        CityUsers loggedInUser = (CityUsers) session.getAttribute("user");
        String picUrl = (loggedInUser != null) ? loggedInUser.getProfilePic() : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150";

        // Check if a new profile picture is being uploaded
        try {
            Part filePart = request.getPart("profilePicFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                try (java.io.InputStream is = filePart.getInputStream()) {
                    byte[] fileBytes = is.readAllBytes();
                    picUrl = com.city.util.CloudinaryUtil.upload(fileBytes, fileName, "cityhub/profiles");
                }
            }
        } catch (Exception e) {
            System.err.println("UpdateProfileServlet: Cloudinary image upload failed. Error: " + e.getMessage());
            e.printStackTrace();
        }

        if (firstname != null && !firstname.trim().isEmpty() &&
            lastname != null && !lastname.trim().isEmpty() &&
            city != null && !city.trim().isEmpty()) {

            CityUsersDaoImpl userDao = new CityUsersDaoImpl();
            CityUsers u = new CityUsers();
            u.setMail(email);
            u.setFirstname(firstname.trim());
            u.setLastname(lastname.trim());
            u.setCity(city.trim());
            u.setProfilePic(picUrl != null && !picUrl.trim().isEmpty() ? picUrl.trim() : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150");

            boolean success = userDao.updateProfile(u);
            if (success) {
                CityUsers updatedUser = userDao.getUserByMail(email);
                session.setAttribute("user", updatedUser);
                session.setAttribute("toastMsg", "Profile updated successfully!");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMsg", "Failed to update profile.");
                session.setAttribute("toastType", "error");
            }
        }

        response.sendRedirect(request.getContextPath() + "/ProfileServlet");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * Extracts file name from HTTP header content-disposition
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf("=") + 2, token.length() - 1);
                }
            }
        }
        return "profile_picture.jpg";
    }
}
