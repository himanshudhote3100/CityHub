package com.city.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.ByteArrayInputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.PublicKey;
import java.security.Signature;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.Base64;

public class FirebaseAuthVerifier {

    public static class FirebaseUser {
        public String uid;
        public String email;
        public boolean emailVerified;
        public String name;
        public String photoUrl;
    }

    public static FirebaseUser verifyToken(String idToken, String projectId) throws Exception {
        String[] parts = idToken.split("\\.");
        if (parts.length != 3) {
            throw new IllegalArgumentException("Invalid JWT token format: expected 3 parts, got " + parts.length);
        }

        // 1. Decode Header and Payload
        String headerJson = new String(Base64.getUrlDecoder().decode(parts[0]), "UTF-8");
        String payloadJson = new String(Base64.getUrlDecoder().decode(parts[1]), "UTF-8");

        // 2. Extract Key ID (kid) from Header
        String kid = getJsonStringValue(headerJson, "kid");
        if (kid == null || kid.isEmpty()) {
            throw new IllegalArgumentException("Token header is missing 'kid' field.");
        }

        // 3. Fetch Google's Public Certificates
        String certsJson = fetchPublicCertificates();

        // 4. Extract PEM certificate corresponding to 'kid'
        String certPem = getJsonStringValue(certsJson, kid);
        if (certPem == null || certPem.isEmpty()) {
            throw new IllegalArgumentException("Google certificate not found for key ID: " + kid);
        }

        // 5. Parse X509 Certificate and obtain Public Key
        certPem = certPem.replace("\\n", "\n");
        ByteArrayInputStream certStream = new ByteArrayInputStream(certPem.getBytes("UTF-8"));
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate cert = (X509Certificate) cf.generateCertificate(certStream);
        PublicKey publicKey = cert.getPublicKey();

        // 6. Verify RSA Cryptographic Signature (RS256)
        byte[] signatureBytes = Base64.getUrlDecoder().decode(parts[2]);
        Signature sig = Signature.getInstance("SHA256withRSA");
        sig.initVerify(publicKey);
        sig.update((parts[0] + "." + parts[1]).getBytes("US-ASCII"));
        
        if (!sig.verify(signatureBytes)) {
            throw new SecurityException("Cryptographic signature verification failed.");
        }

        // 7. Verify Claims (Audience, Issuer, Expiration)
        String iss = getJsonStringValue(payloadJson, "iss");
        String aud = getJsonStringValue(payloadJson, "aud");
        String expStr = getJsonStringValue(payloadJson, "exp");
        
        if (expStr == null) {
            throw new SecurityException("Token is missing expiration claim ('exp').");
        }

        long exp = Long.parseLong(expStr);
        long now = System.currentTimeMillis() / 1000;
        if (now >= exp) {
            throw new SecurityException("Token has expired. Expiration: " + exp + ", Current: " + now);
        }

        String expectedIss = "https://securetoken.google.com/" + projectId;
        if (!expectedIss.equals(iss)) {
            throw new SecurityException("Invalid token issuer. Expected " + expectedIss + ", got " + iss);
        }

        if (!projectId.equals(aud)) {
            throw new SecurityException("Invalid token audience. Expected " + projectId + ", got " + aud);
        }

        // 8. Enforce Verified Email address
        String emailVerifiedStr = getJsonStringValue(payloadJson, "email_verified");
        if (!"true".equalsIgnoreCase(emailVerifiedStr)) {
            throw new SecurityException("Google email account is not verified in Firebase.");
        }

        // 9. Extract and return FirebaseUser info
        FirebaseUser user = new FirebaseUser();
        user.uid = getJsonStringValue(payloadJson, "sub"); // sub is localId/UID in Firebase tokens
        user.email = getJsonStringValue(payloadJson, "email");
        user.name = getJsonStringValue(payloadJson, "name");
        user.photoUrl = getJsonStringValue(payloadJson, "picture");
        user.emailVerified = true;

        return user;
    }

    private static String fetchPublicCertificates() throws Exception {
        URL url = new URL("https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line.trim());
            }
        }
        return response.toString();
    }

    private static String getJsonStringValue(String json, String key) {
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
        // Handle boolean or number values
        int end = start;
        while (end < json.length() && json.charAt(end) != ',' && json.charAt(end) != '}' && json.charAt(end) != ']') {
            end++;
        }
        return json.substring(start, end).trim();
    }
}
