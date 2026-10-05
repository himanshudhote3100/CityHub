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
import com.city.pojo.PostQuestions;

@WebServlet("/InsertQuestionServlet")
@MultipartConfig
public class InsertQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String mail = request.getParameter("mail");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        String category = request.getParameter("category");

        // Upload image to Cloudinary (folder: cityhub/questions)
        String imageUrl = null;
        try {
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getFileName(filePart);
                try (java.io.InputStream is = filePart.getInputStream()) {
                    byte[] fileBytes = is.readAllBytes();
                    imageUrl = com.city.util.CloudinaryUtil.upload(fileBytes, fileName, "cityhub/questions");
                }
            }
        } catch (Exception e) {
            System.err.println("InsertQuestionServlet: Cloudinary image upload failed. Error: " + e.getMessage());
            e.printStackTrace();
        }

        String message = "Question posted successfully!";

        PostQuestions p = new PostQuestions();
        p.setMail(mail);
        p.setTitle(title);
        p.setDescription(description);
        p.setLocation(location);
        p.setCategory(category);
        p.setImage(imageUrl);
        p.setLikesCount(0);

        CityUsersDaoImpl dao = new CityUsersDaoImpl();
        boolean result = dao.addquestions(p);

        if (result) {
            session.setAttribute("toastMsg", message);
            session.setAttribute("toastType", "success");
            response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
        } else {
            session.setAttribute("questionMsg", "Failed to post question. Please check details.");
            session.setAttribute("questionMsgType", "error");
            response.sendRedirect(request.getContextPath() + "/askquestion.jsp");
        }
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
        return "uploaded_image.jpg";
    }
}
