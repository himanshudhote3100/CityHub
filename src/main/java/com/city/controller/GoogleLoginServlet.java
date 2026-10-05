package com.city.controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.city.daoimpl.CityUsersDaoImpl;
import com.city.pojo.CityUsers;
import com.city.util.FirebaseAuthVerifier;

@WebServlet("/GoogleLoginServlet")
public class GoogleLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idToken = request.getParameter("idToken");
        String action = request.getParameter("action");
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (idToken == null || idToken.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Firebase ID Token is required.\"}");
            return;
        }

        // Load service account file path from config.properties
        String serviceAccountPath = "";
        try (java.io.InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                java.util.Properties prop = new java.util.Properties();
                prop.load(input);
                serviceAccountPath = prop.getProperty("firebase.service.account.path", "").trim();
            }
        } catch (Exception e) {
            System.err.println("Could not load config.properties: " + e.getMessage());
        }

        if (serviceAccountPath.isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Firebase Service Account Path is not configured in properties.\"}");
            return;
        }

        // Read project_id from service account file
        String projectId = loadProjectIdFromServiceAccount(serviceAccountPath);
        if (projectId == null || projectId.isEmpty()) {
            out.print("{\"status\":\"error\", \"message\":\"Could not load project_id from Firebase Service Account JSON file.\"}");
            return;
        }

        try {
            // Verify ID Token locally using local RS256 signature verifier
            FirebaseAuthVerifier.FirebaseUser firebaseUser = FirebaseAuthVerifier.verifyToken(idToken, projectId);
            
            if (firebaseUser.email == null || firebaseUser.email.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"Invalid user details returned from Firebase.\"}");
                return;
            }

            if (!firebaseUser.emailVerified) {
                out.print("{\"status\":\"error\", \"message\":\"Only verified Google accounts are allowed to access CityHub.\"}");
                return;
            }

            String email = firebaseUser.email.trim().toLowerCase();
            CityUsersDaoImpl userDao = new CityUsersDaoImpl();
            CityUsers user = userDao.getUserByMail(email);

            if ("check".equalsIgnoreCase(action)) {
                if (user != null) {
                    // Update user's firebase_uid just in case it differs or is not set
                    if (user.getFirebaseUid() == null || !user.getFirebaseUid().equals(firebaseUser.uid)) {
                        user.setFirebaseUid(firebaseUser.uid);
                        userDao.updateProfile(user);
                    }
                    
                    // User exists, log them in
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("user", user);
                    session.setAttribute("toastMsg", "Welcome back, " + user.getFirstname() + "!");
                    session.setAttribute("toastType", "success");
                    
                    out.print("{\"status\":\"success\", \"redirect\":\"home.jsp\"}");
                } else {
                    // User doesn't exist, prompt for City
                    out.print("{\"status\":\"new_user\", \"email\":\"" + email + "\", \"name\":\"" + firebaseUser.name + "\", \"profile_pic\":\"" + firebaseUser.photoUrl + "\"}");
                }
            } else if ("register".equalsIgnoreCase(action)) {
                String city = request.getParameter("city");
                if (city == null || city.trim().isEmpty()) {
                    out.print("{\"status\":\"error\", \"message\":\"City is required to complete profile.\"}");
                    return;
                }

                // Check if user already registered during this time
                if (user != null) {
                    out.print("{\"status\":\"error\", \"message\":\"User already registered.\"}");
                    return;
                }

                // Register user
                CityUsers c = new CityUsers();
                c.setMail(email);
                c.setFirebaseUid(firebaseUser.uid);
                c.setCity(city.trim());
                c.setPasscode("firebase_oauth_user"); // dummy password
                c.setHubPoints(0);
                
                // Set name
                String name = firebaseUser.name != null ? firebaseUser.name.trim() : "Google User";
                int spaceIndex = name.indexOf(' ');
                if (spaceIndex != -1) {
                    c.setFirstname(name.substring(0, spaceIndex));
                    c.setLastname(name.substring(spaceIndex + 1));
                } else {
                    c.setFirstname(name);
                    c.setLastname("");
                }

                c.setProfilePic(firebaseUser.photoUrl != null && !firebaseUser.photoUrl.trim().isEmpty() ? firebaseUser.photoUrl.trim() : "https://ui-avatars.com/api/?name=" + name + "&background=dbeafe&color=1d4ed8&size=200");

                boolean success = userDao.registeruser(c);
                if (success) {
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("user", c);
                    session.setAttribute("toastMsg", "Account created successfully with Google!");
                    session.setAttribute("toastType", "success");
                    out.print("{\"status\":\"success\", \"redirect\":\"home.jsp\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Failed to create account in database.\"}");
                }
            } else {
                out.print("{\"status\":\"error\", \"message\":\"Invalid action.\"}");
            }
        } catch (Exception e) {
            System.err.println("Firebase verification failed: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"status\":\"error\", \"message\":\"Firebase token verification failed: " + e.getMessage() + "\"}");
        }
        out.flush();
    }

    private String loadProjectIdFromServiceAccount(String path) {
        try {
            byte[] bytes = java.nio.file.Files.readAllBytes(java.nio.file.Paths.get(path));
            String content = new String(bytes, "UTF-8");
            String projectId = getJsonStringValue(content, "project_id");
            if (projectId != null) {
                return projectId.trim();
            }
        } catch (Exception e) {
            System.err.println("Error reading service account project_id: " + e.getMessage());
        }
        return null;
    }

    private String getJsonStringValue(String json, String key) {
        String search = "\"" + key + "\"";
        int index = json.indexOf(search);
        if (index == -1) return null;
        int colon = json.indexOf(":", index + search.length());
        if (colon == -1) return null;
        int start = colon + 1;
        while (start < json.length() && (Character.isWhitespace(json.charAt(start)) || json.charAt(start) == '"')) {
            if (json.charAt(start) == '"') {
                start++;
                int end = json.indexOf("\"", start);
                if (end != -1) {
                    return json.substring(start, end);
                }
                break;
            }
            start++;
        }
        return null;
    }
}
