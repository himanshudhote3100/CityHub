package com.city.pojo;

import java.sql.Timestamp;

public class PostQuestions {
	private int id;
	private String mail;
	private String title;
	private String description;
	private String location;
	private String category;
	private String image;
	private int likesCount;
	private Timestamp createdAt;

	public PostQuestions() {
		super();
	}
	public PostQuestions(int id, String mail, String title, String description, String location, String category, String image) {
		super();
		this.id = id;
		this.mail = mail;
		this.title = title;
		this.description = description;
		this.location = location;
		this.category = category;
		this.image = image;
	}

	public PostQuestions(int id, String mail, String title, String description, String location, String category, String image, int likesCount, Timestamp createdAt) {
		super();
		this.id = id;
		this.mail = mail;
		this.title = title;
		this.description = description;
		this.location = location;
		this.category = category;
		this.image = image;
		this.likesCount = likesCount;
		this.createdAt = createdAt;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
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
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}

	public int getLikesCount() {
		return likesCount;
	}
	public void setLikesCount(int likesCount) {
		this.likesCount = likesCount;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	private String profilePic;

	public String getProfilePic() {
		return profilePic;
	}
	public void setProfilePic(String profilePic) {
		this.profilePic = profilePic;
	}
}
