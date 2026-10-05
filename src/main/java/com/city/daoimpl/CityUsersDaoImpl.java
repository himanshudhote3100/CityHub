package com.city.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.city.pojo.CityUsers;
import com.city.pojo.PostQuestions;
import com.city.dao.CityUsersDao;
import com.city.dbutil.DBUtil;

public class CityUsersDaoImpl implements CityUsersDao {

    private void parseAndSetNames(CityUsers u, String fullName) {
        if (fullName != null) {
            fullName = fullName.trim();
            int spaceIndex = fullName.indexOf(' ');
            if (spaceIndex != -1) {
                u.setFirstname(fullName.substring(0, spaceIndex));
                u.setLastname(fullName.substring(spaceIndex + 1));
            } else {
                u.setFirstname(fullName);
                u.setLastname("");
            }
        } else {
            u.setFirstname("");
            u.setLastname("");
        }
    }

    @Override
    public boolean checkuser(CityUsers c) {
        String sql = "SELECT * FROM users WHERE email=? AND passcode=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getMail());
            ps.setString(2, c.getPasscode());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            System.err.println("Exception in checkuser: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean registeruser(CityUsers c) {
        String sql = "INSERT INTO users(firebase_uid, name, email, passcode, city, profile_pic, hub_points) VALUES(?,?,?,?,?,?,?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String fbUid = c.getFirebaseUid();
            if (fbUid == null || fbUid.trim().isEmpty()) {
                fbUid = java.util.UUID.randomUUID().toString();
            }
            String fullName = (c.getFirstname() + " " + c.getLastname()).trim();
            ps.setString(1, fbUid);
            ps.setString(2, fullName);
            ps.setString(3, c.getMail());
            ps.setString(4, c.getPasscode());
            ps.setString(5, c.getCity());
            ps.setString(6, c.getProfilePic() != null ? c.getProfilePic() : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150");
            ps.setInt(7, c.getHubPoints());
            int x = ps.executeUpdate();
            return x > 0;
        } catch (Exception ex) {
            System.err.println("Exception in registeruser: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean addquestions(PostQuestions p) {
        String sql = "INSERT INTO city_questions(mail, title, description, location, category, image, likes_count) VALUES(?,?,?,?,?,?,?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getMail());
            ps.setString(2, p.getTitle());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getLocation());
            ps.setString(5, p.getCategory());
            ps.setString(6, p.getImage());
            ps.setInt(7, p.getLikesCount());
            int x = ps.executeUpdate();
            return x > 0;
        } catch (Exception ex) {
            System.err.println("Exception in addquestions: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public List<PostQuestions> getAllQuestions() {
        List<PostQuestions> list = new ArrayList<>();
        String sql = "SELECT q.*, u.profile_pic FROM city_questions q LEFT JOIN users u ON q.mail = u.email ORDER BY q.id DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PostQuestions q = new PostQuestions();
                q.setId(rs.getInt("id"));
                q.setMail(rs.getString("mail"));
                q.setTitle(rs.getString("title"));
                q.setDescription(rs.getString("description"));
                q.setLocation(rs.getString("location"));
                q.setCategory(rs.getString("category"));
                q.setImage(rs.getString("image"));
                q.setLikesCount(rs.getInt("likes_count"));
                q.setCreatedAt(rs.getTimestamp("created_at"));
                q.setProfilePic(rs.getString("profile_pic"));
                list.add(q);
            }
        } catch (Exception e) {
            System.err.println("Exception in getAllQuestions: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public CityUsers getUserByMail(String email) {
        String sql = "SELECT * FROM users WHERE email=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CityUsers u = new CityUsers();
                    u.setMail(rs.getString("email"));
                    u.setPasscode(rs.getString("passcode"));
                    u.setCity(rs.getString("city"));
                    u.setProfilePic(rs.getString("profile_pic"));
                    u.setHubPoints(rs.getInt("hub_points"));
                    u.setFirebaseUid(rs.getString("firebase_uid"));
                    parseAndSetNames(u, rs.getString("name"));
                    return u;
                }
            }
        } catch (Exception ex) {
            System.err.println("Exception in getUserByMail: " + ex.getMessage());
            ex.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateProfilePic(String email, String picUrl) {
        String sql = "UPDATE users SET profile_pic=? WHERE email=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, picUrl);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("Exception in updateProfilePic: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateProfile(CityUsers c) {
        String sql = "UPDATE users SET name=?, city=?, profile_pic=? WHERE email=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String fullName = (c.getFirstname() + " " + c.getLastname()).trim();
            ps.setString(1, fullName);
            ps.setString(2, c.getCity());
            ps.setString(3, c.getProfilePic());
            ps.setString(4, c.getMail());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("Exception in updateProfile: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public List<PostQuestions> getQuestionsByMail(String email) {
        List<PostQuestions> list = new ArrayList<>();
        String sql = "SELECT q.*, u.profile_pic FROM city_questions q LEFT JOIN users u ON q.mail = u.email WHERE q.mail=? ORDER BY q.id DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PostQuestions q = new PostQuestions();
                    q.setId(rs.getInt("id"));
                    q.setMail(rs.getString("mail"));
                    q.setTitle(rs.getString("title"));
                    q.setDescription(rs.getString("description"));
                    q.setLocation(rs.getString("location"));
                    q.setCategory(rs.getString("category"));
                    q.setImage(rs.getString("image"));
                    q.setLikesCount(rs.getInt("likes_count"));
                    q.setCreatedAt(rs.getTimestamp("created_at"));
                    q.setProfilePic(rs.getString("profile_pic"));
                    list.add(q);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getQuestionsByMail: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateHubPoints(String email, int points) {
        String sql = "UPDATE users SET hub_points = hub_points + ? WHERE email=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, points);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println("Exception in updateHubPoints: " + ex.getMessage());
            ex.printStackTrace();
            return false;
        }
    }

    @Override
    public List<CityUsers> getTopContributors() {
        List<CityUsers> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY hub_points DESC LIMIT 5";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CityUsers u = new CityUsers();
                u.setMail(rs.getString("email"));
                u.setCity(rs.getString("city"));
                u.setProfilePic(rs.getString("profile_pic"));
                u.setHubPoints(rs.getInt("hub_points"));
                u.setFirebaseUid(rs.getString("firebase_uid"));
                parseAndSetNames(u, rs.getString("name"));
                list.add(u);
            }
        } catch (Exception ex) {
            System.err.println("Exception in getTopContributors: " + ex.getMessage());
            ex.printStackTrace();
        }
        return list;
    }
}
