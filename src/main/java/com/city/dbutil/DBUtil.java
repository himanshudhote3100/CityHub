package com.city.dbutil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBUtil {
    private static String getEnv(String name, String fallback) {
        String val = System.getenv(name);
        return (val != null && !val.trim().isEmpty()) ? val.trim() : fallback;
    }

    private static final String HOST = getEnv("MYSQLHOST", getEnv("MYSQL_HOST", "localhost"));
    private static final String PORT = getEnv("MYSQLPORT", getEnv("MYSQL_PORT", "3306"));
    private static final String DBNAME = getEnv("MYSQLDATABASE", getEnv("MYSQL_DATABASE", "cityhub"));
    private static final String USER = getEnv("MYSQLUSER", getEnv("MYSQL_USER", "root"));
    private static final String PASSWORD = getEnv("MYSQLPASSWORD", getEnv("MYSQL_PASSWORD", "root"));

    private static final String MYSQL_URL = getEnv("MYSQL_URL", "jdbc:mysql://" + HOST + ":" + PORT + "/?useSSL=false&allowPublicKeyRetrieval=true");
    private static final String DB_URL = getEnv("DATABASE_URL", "jdbc:mysql://" + HOST + ":" + PORT + "/" + DBNAME + "?useSSL=false&allowPublicKeyRetrieval=true");


    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(MYSQL_URL, USER, PASSWORD);
                 Statement stmt = conn.createStatement()) {
                stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS cityhub");
            }

            try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
                 Statement stmt = conn.createStatement()) {

                // Check if users table exists
                boolean usersTableExists = false;
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "users", null)) {
                    if (rs.next()) {
                        usersTableExists = true;
                    }
                }

                // Check if any foreign key constraints reference the old city_login table
                boolean hasStaleConstraints = false;
                try (ResultSet checkRs = stmt.executeQuery(
                        "SELECT COUNT(*) FROM information_schema.KEY_COLUMN_USAGE " +
                        "WHERE REFERENCED_TABLE_SCHEMA = 'cityhub' AND REFERENCED_TABLE_NAME = 'city_login'")) {
                    if (checkRs.next() && checkRs.getInt(1) > 0) {
                        hasStaleConstraints = true;
                    }
                } catch (Exception e) {
                    System.err.println("Could not check for stale constraints: " + e.getMessage());
                }

                // Check if the is_urgent column exists (so we can migrate/drop old questions schema)
                boolean hasIsUrgentColumn = false;
                try (ResultSet rs = conn.getMetaData().getColumns(null, null, "city_questions", "is_urgent")) {
                    if (rs.next()) {
                        hasIsUrgentColumn = true;
                    }
                } catch (Exception e) {
                    // Ignored if table doesn't exist yet
                }

                if (!usersTableExists || hasStaleConstraints || hasIsUrgentColumn) {
                    System.out.println("Migrating database schema: Recreating tables to remove urgent questions concept...");
                    stmt.executeUpdate("SET FOREIGN_KEY_CHECKS = 0");
                    stmt.executeUpdate("DROP TABLE IF EXISTS city_marketplace");
                    stmt.executeUpdate("DROP TABLE IF EXISTS question_likes");
                    stmt.executeUpdate("DROP TABLE IF EXISTS city_friends");
                    stmt.executeUpdate("DROP TABLE IF EXISTS answers");
                    stmt.executeUpdate("DROP TABLE IF EXISTS city_questions");
                    stmt.executeUpdate("DROP TABLE IF EXISTS city_login");
                    if (!usersTableExists) {
                        stmt.executeUpdate("DROP TABLE IF EXISTS users");
                    }
                    stmt.executeUpdate("SET FOREIGN_KEY_CHECKS = 1");
                }

                // Create users
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                        "user_id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "firebase_uid VARCHAR(128) UNIQUE NOT NULL, " +
                        "name VARCHAR(100), " +
                        "email VARCHAR(150) UNIQUE NOT NULL, " +
                        "passcode VARCHAR(255), " +
                        "profile_pic VARCHAR(500) DEFAULT 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150', " +
                        "hub_points INT DEFAULT 0, " +
                        "city VARCHAR(100), " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                        ")");

                // Create city_questions (without is_urgent)
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS city_questions (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "mail VARCHAR(255), " +
                        "title VARCHAR(255) NOT NULL, " +
                        "description TEXT, " +
                        "location VARCHAR(255), " +
                        "category VARCHAR(100), " +
                        "image VARCHAR(500), " +
                        "likes_count INT DEFAULT 0, " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (mail) REFERENCES users(email) ON DELETE CASCADE" +
                        ")");

                // Create answers
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS answers (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "question_id INT, " +
                        "answer_text TEXT NOT NULL, " +
                        "answer_username VARCHAR(255), " +
                        "upvotes INT DEFAULT 0, " +
                        "downvotes INT DEFAULT 0, " +
                        "rating_sum INT DEFAULT 0, " +
                        "rating_count INT DEFAULT 0, " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (question_id) REFERENCES city_questions(id) ON DELETE CASCADE, " +
                        "FOREIGN KEY (answer_username) REFERENCES users(email) ON DELETE CASCADE" +
                        ")");

                // Create city_friends
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS city_friends (" +
                        "user_mail VARCHAR(255), " +
                        "friend_mail VARCHAR(255), " +
                        "PRIMARY KEY (user_mail, friend_mail), " +
                        "FOREIGN KEY (user_mail) REFERENCES users(email) ON DELETE CASCADE, " +
                        "FOREIGN KEY (friend_mail) REFERENCES users(email) ON DELETE CASCADE" +
                        ")");

                // Create question_likes
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS question_likes (" +
                        "question_id INT, " +
                        "user_mail VARCHAR(255), " +
                        "PRIMARY KEY (question_id, user_mail), " +
                        "FOREIGN KEY (question_id) REFERENCES city_questions(id) ON DELETE CASCADE, " +
                        "FOREIGN KEY (user_mail) REFERENCES users(email) ON DELETE CASCADE" +
                        ")");

                // Create city_marketplace
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS city_marketplace (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "title VARCHAR(255) NOT NULL, " +
                        "description TEXT, " +
                        "price DOUBLE DEFAULT 0.0, " +
                        "category VARCHAR(100) NOT NULL, " +
                        "seller_mail VARCHAR(255) NOT NULL, " +
                        "contact_info VARCHAR(255) NOT NULL, " +
                        "image_url VARCHAR(500), " +
                        "city VARCHAR(100), " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (seller_mail) REFERENCES users(email) ON DELETE CASCADE" +
                        ")");

                // Create game_scores
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS game_scores (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "email VARCHAR(255) NOT NULL, " +
                        "game_name VARCHAR(100) NOT NULL, " +
                        "score INT NOT NULL, " +
                        "points_earned INT NOT NULL, " +
                        "played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE" +
                        ")");

                // Purge demo users
                stmt.executeUpdate("DELETE FROM users WHERE email LIKE '%demo%' OR name LIKE '%demo%'");
                
                System.out.println("CityHub Database initialized successfully in root project.");
            }
        } catch (Exception e) {
            System.err.println("Error initializing database in root project: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, USER, PASSWORD);
    }
}
