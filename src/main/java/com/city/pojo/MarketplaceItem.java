package com.city.pojo;

import java.sql.Timestamp;

public class MarketplaceItem {
    private int id;
    private String title;
    private String description;
    private double price;
    private String category;
    private String sellerMail;
    private String contactInfo;
    private String imageUrl;
    private String city;
    private Timestamp createdAt;

    public MarketplaceItem() {
        super();
    }

    public MarketplaceItem(int id, String title, String description, double price, String category, String sellerMail, String contactInfo, String imageUrl, String city, Timestamp createdAt) {
        super();
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.category = category;
        this.sellerMail = sellerMail;
        this.contactInfo = contactInfo;
        this.imageUrl = imageUrl;
        this.city = city;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSellerMail() {
        return sellerMail;
    }

    public void setSellerMail(String sellerMail) {
        this.sellerMail = sellerMail;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
