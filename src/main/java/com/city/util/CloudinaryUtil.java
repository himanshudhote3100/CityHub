package com.city.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Utility class to handle uploading files directly to Cloudinary using standard Java HTTP.
 * Avoids heavy external SDK libraries and works out of the box.
 */
public class CloudinaryUtil {

    // Cloudinary Credentials (Hardcoded on backend only)
    private static final String CLOUD_NAME = "dakadlxce";
    private static final String API_KEY = "152759757955751";
    private static final String API_SECRET = "wobV95rqmlYoVEEj7AjK059Bpa0";

    /**
     * Uploads file bytes to Cloudinary.
     * @param fileBytes Binary content of the image.
     * @param fileName Name of the uploaded file.
     * @param folder Destination folder on Cloudinary (e.g. "cityhub/questions").
     * @return The secure URL (https) of the uploaded image on Cloudinary.
     * @throws Exception If anything goes wrong during upload.
     */
    public static String upload(byte[] fileBytes, String fileName, String folder) throws Exception {
        String uploadUrl = "https://api.cloudinary.com/v1_1/" + CLOUD_NAME + "/image/upload";
        
        // Generate a random boundary string for the multipart request
        String boundary = "===Boundary_" + System.currentTimeMillis() + "===";
        String lineEnd = "\r\n";
        String twoHyphens = "--";

        // Current Unix timestamp (Cloudinary requires it in seconds)
        long timestamp = System.currentTimeMillis() / 1000;

        // Collect parameters to be signed
        Map<String, Object> parametersToSign = new HashMap<>();
        parametersToSign.put("folder", folder);
        parametersToSign.put("timestamp", timestamp);

        // Generate signature
        String signature = generateSignature(parametersToSign, API_SECRET);

        // Connect to Cloudinary
        URL url = new URL(uploadUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setDoInput(true);
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Connection", "Keep-Alive");
        conn.setRequestProperty("User-Agent", "Java Cloudinary Client");
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

        System.out.println("Starting Cloudinary upload for " + fileName + " into folder: " + folder);

        // Write the multipart request body
        try (OutputStream out = conn.getOutputStream();
             PrintWriter writer = new PrintWriter(new OutputStreamWriter(out, StandardCharsets.UTF_8), true)) {

            // 1. Write api_key parameter
            writeFormField(writer, boundary, "api_key", API_KEY);

            // 2. Write timestamp parameter
            writeFormField(writer, boundary, "timestamp", String.valueOf(timestamp));

            // 3. Write folder parameter
            writeFormField(writer, boundary, "folder", folder);

            // 4. Write signature parameter
            writeFormField(writer, boundary, "signature", signature);

            // 5. Write the file binary part header
            writer.append(twoHyphens).append(boundary).append(lineEnd);
            writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"").append(fileName).append("\"").append(lineEnd);
            writer.append("Content-Type: application/octet-stream").append(lineEnd);
            writer.append(lineEnd);
            writer.flush();

            // 6. Write file bytes
            out.write(fileBytes);
            out.flush();

            // End of the file part
            writer.append(lineEnd);
            writer.flush();

            // 7. Close the multipart request
            writer.append(twoHyphens).append(boundary).append(twoHyphens).append(lineEnd);
            writer.flush();
        }

        // Get the HTTP response code
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            // Read success response JSON
            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder responseJson = new StringBuilder();
                String line;
                while ((line = in.readLine()) != null) {
                    responseJson.append(line);
                }
                
                System.out.println("Cloudinary Upload Success response: " + responseJson.toString());
                
                // Parse secure_url from response JSON
                String secureUrl = parseSecureUrl(responseJson.toString());
                if (secureUrl == null) {
                    throw new Exception("Could not parse 'secure_url' from response: " + responseJson.toString());
                }
                return secureUrl;
            }
        } else {
            // Read error response
            try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                StringBuilder errorJson = new StringBuilder();
                String line;
                while ((line = in.readLine()) != null) {
                    errorJson.append(line);
                }
                System.err.println("Cloudinary error code: " + responseCode + ", details: " + errorJson.toString());
                throw new Exception("Cloudinary upload failed with HTTP code " + responseCode + ". Response: " + errorJson.toString());
            }
        }
    }

    /**
     * Helper to write standard text form fields in multipart/form-data.
     */
    private static void writeFormField(PrintWriter writer, String boundary, String fieldName, String fieldValue) {
        String lineEnd = "\r\n";
        String twoHyphens = "--";
        writer.append(twoHyphens).append(boundary).append(lineEnd);
        writer.append("Content-Disposition: form-data; name=\"").append(fieldName).append("\"").append(lineEnd);
        writer.append("Content-Type: text/plain; charset=UTF-8").append(lineEnd);
        writer.append(lineEnd);
        writer.append(fieldValue).append(lineEnd);
        writer.flush();
    }

    /**
     * Generates a SHA-1 signature of parameters as required by Cloudinary.
     * Sorts parameters alphabetically, joins them with '&', and appends API secret at the end.
     */
    private static String generateSignature(Map<String, Object> params, String apiSecret) throws Exception {
        // Sort keys alphabetically
        List<String> sortedKeys = new ArrayList<>(params.keySet());
        Collections.sort(sortedKeys);

        // Join parameters as key=value&key2=value2
        StringBuilder signatureString = new StringBuilder();
        for (int i = 0; i < sortedKeys.size(); i++) {
            String key = sortedKeys.get(i);
            Object value = params.get(key);
            if (value != null) {
                if (signatureString.length() > 0) {
                    signatureString.append("&");
                }
                signatureString.append(key).append("=").append(value.toString());
            }
        }

        // Append api secret to the end of the query string
        signatureString.append(apiSecret);
        
        System.out.println("Signature source string: " + signatureString.toString());

        // Calculate SHA-1 hash
        MessageDigest md = MessageDigest.getInstance("SHA-1");
        byte[] digestBytes = md.digest(signatureString.toString().getBytes(StandardCharsets.UTF_8));

        // Convert byte array to hex string
        StringBuilder hexString = new StringBuilder();
        for (byte b : digestBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        
        String sig = hexString.toString();
        System.out.println("Generated Signature: " + sig);
        return sig;
    }

    /**
     * Parses the value of "secure_url" out of the response JSON.
     * Simple, direct indexing to avoid external JSON parser dependencies.
     */
    private static String parseSecureUrl(String json) {
        String key = "\"secure_url\"";
        int index = json.indexOf(key);
        if (index != -1) {
            // Find the opening double quote of the URL string value
            int startQuote = json.indexOf("\"", index + key.length());
            if (startQuote != -1) {
                // Find the closing double quote of the URL string value
                int endQuote = json.indexOf("\"", startQuote + 1);
                if (endQuote != -1) {
                    // Extract URL and fix any backslash escape characters
                    return json.substring(startQuote + 1, endQuote).replace("\\/", "/");
                }
            }
        }
        return null;
    }
}
