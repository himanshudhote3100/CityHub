package com.city.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.city.dao.FriendDao;
import com.city.pojo.CityUsers;
import com.city.dbutil.DBUtil;

public class FriendDaoImpl implements FriendDao {

    @Override
    public boolean addFriend(String userMail, String friendMail) {
        String sql = "INSERT IGNORE INTO city_friends (user_mail, friend_mail) VALUES (?, ?), (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userMail);
            ps.setString(2, friendMail);
            ps.setString(3, friendMail);
            ps.setString(4, userMail);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in addFriend: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeFriend(String userMail, String friendMail) {
        String sql = "DELETE FROM city_friends WHERE (user_mail = ? AND friend_mail = ?) OR (user_mail = ? AND friend_mail = ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userMail);
            ps.setString(2, friendMail);
            ps.setString(3, friendMail);
            ps.setString(4, userMail);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in removeFriend: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

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
    public List<CityUsers> getFriends(String userMail) {
        List<CityUsers> list = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN city_friends f ON u.email = f.friend_mail WHERE f.user_mail = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userMail);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CityUsers u = new CityUsers();
                    u.setMail(rs.getString("email"));
                    u.setCity(rs.getString("city"));
                    u.setProfilePic(rs.getString("profile_pic"));
                    u.setHubPoints(rs.getInt("hub_points"));
                    parseAndSetNames(u, rs.getString("name"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getFriends: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<CityUsers> getNonFriends(String userMail) {
        List<CityUsers> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE email != ? AND email NOT IN (SELECT friend_mail FROM city_friends WHERE user_mail = ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userMail);
            ps.setString(2, userMail);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CityUsers u = new CityUsers();
                    u.setMail(rs.getString("email"));
                    u.setCity(rs.getString("city"));
                    u.setProfilePic(rs.getString("profile_pic"));
                    u.setHubPoints(rs.getInt("hub_points"));
                    parseAndSetNames(u, rs.getString("name"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getNonFriends: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean isFriend(String userMail, String friendMail) {
        String sql = "SELECT 1 FROM city_friends WHERE user_mail = ? AND friend_mail = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userMail);
            ps.setString(2, friendMail);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.err.println("Exception in isFriend: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
