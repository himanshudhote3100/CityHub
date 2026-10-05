package com.city.util;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;
import java.util.Scanner;

public class EmailValidator {
    private static String abstractApiKey = null;

    static {
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);
                abstractApiKey = prop.getProperty("abstractapi.key");
            }
        } catch (Exception e) {
            System.err.println("Could not load config.properties for EmailValidator: " + e.getMessage());
        }
    }

    public static boolean isValidGoogleEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        email = email.trim().toLowerCase();
        if (!email.endsWith("@gmail.com") && !email.endsWith("@googlemail.com")) {
            return false;
        }

        if (abstractApiKey != null && !abstractApiKey.trim().isEmpty()) {
            try {
                String urlStr = "https://emailvalidation.abstractapi.com/v1/?api_key=" + abstractApiKey + "&email=" + email;
                URL url = new URL(urlStr);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(3000);
                conn.setReadTimeout(3000);

                int responseCode = conn.getResponseCode();
                if (responseCode == 200) {
                    try (Scanner scanner = new Scanner(conn.getInputStream())) {
                        String json = scanner.useDelimiter("\\A").next();
                        if (json.contains("\"deliverability\":\"DELIVERABLE\"") || json.contains("\"deliverability\": \"DELIVERABLE\"")) {
                            return true;
                        } else {
                            System.out.println("Email validation failed via Abstract API for " + email + ". Response: " + json);
                            return false;
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("API error during email validation: " + e.getMessage());
            }
        }

        return true;
    }
}
