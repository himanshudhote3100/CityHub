package com.city.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.city.dao.MarketplaceDao;
import com.city.pojo.MarketplaceItem;
import com.city.dbutil.DBUtil;

public class MarketplaceDaoImpl implements MarketplaceDao {

    @Override
    public boolean addItem(MarketplaceItem item) {
        String sql = "INSERT INTO city_marketplace (title, description, price, category, seller_mail, contact_info, image_url, city) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, item.getTitle());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, item.getCategory());
            ps.setString(5, item.getSellerMail());
            ps.setString(6, item.getContactInfo());
            ps.setString(7, item.getImageUrl());
            ps.setString(8, item.getCity());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in addItem: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<MarketplaceItem> getAllItems() {
        List<MarketplaceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM city_marketplace ORDER BY id DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MarketplaceItem item = new MarketplaceItem();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setPrice(rs.getDouble("price"));
                item.setCategory(rs.getString("category"));
                item.setSellerMail(rs.getString("seller_mail"));
                item.setContactInfo(rs.getString("contact_info"));
                item.setImageUrl(rs.getString("image_url"));
                item.setCity(rs.getString("city"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (Exception e) {
            System.err.println("Exception in getAllItems: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<MarketplaceItem> getItemsByCategory(String category) {
        List<MarketplaceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM city_marketplace WHERE category = ? ORDER BY id DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MarketplaceItem item = new MarketplaceItem();
                    item.setId(rs.getInt("id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getDouble("price"));
                    item.setCategory(rs.getString("category"));
                    item.setSellerMail(rs.getString("seller_mail"));
                    item.setContactInfo(rs.getString("contact_info"));
                    item.setImageUrl(rs.getString("image_url"));
                    item.setCity(rs.getString("city"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getItemsByCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<MarketplaceItem> getItemsByCity(String city) {
        List<MarketplaceItem> list = new ArrayList<>();
        String sql = "SELECT * FROM city_marketplace WHERE city = ? ORDER BY id DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, city);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MarketplaceItem item = new MarketplaceItem();
                    item.setId(rs.getInt("id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getDouble("price"));
                    item.setCategory(rs.getString("category"));
                    item.setSellerMail(rs.getString("seller_mail"));
                    item.setContactInfo(rs.getString("contact_info"));
                    item.setImageUrl(rs.getString("image_url"));
                    item.setCity(rs.getString("city"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getItemsByCity: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean deleteItem(int id) {
        String sql = "DELETE FROM city_marketplace WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in deleteItem: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
