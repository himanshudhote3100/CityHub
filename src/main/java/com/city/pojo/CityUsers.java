package com.city.pojo;

public class CityUsers {
	private String mail;
	private String passcode;
	private String city;
	private String firstname;
	private String lastname;
	private String profilePic;
	private int hubPoints;
	private String firebaseUid;

	public CityUsers() {
		super();
	}

	public CityUsers(String mail, String passcode) {
		super();
		this.mail = mail;
		this.passcode = passcode;
	}
	
	public CityUsers(String mail, String passcode, String city, String firstname, String lastname) {
		super();
		this.mail = mail;
		this.passcode = passcode;
		this.city = city;
		this.firstname = firstname;
		this.lastname = lastname;
	}

	public CityUsers(String mail, String passcode, String city, String firstname, String lastname, String profilePic, int hubPoints) {
		super();
		this.mail = mail;
		this.passcode = passcode;
		this.city = city;
		this.firstname = firstname;
		this.lastname = lastname;
		this.profilePic = profilePic;
		this.hubPoints = hubPoints;
	}

	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	public String getPasscode() {
		return passcode;
	}

	public void setPasscode(String passcode) {
		this.passcode = passcode;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getFirstname() {
		return firstname;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getProfilePic() {
		return profilePic;
	}

	public void setProfilePic(String profilePic) {
		this.profilePic = profilePic;
	}

	public int getHubPoints() {
		return hubPoints;
	}

	public void setHubPoints(int hubPoints) {
		this.hubPoints = hubPoints;
	}

	public String getFirebaseUid() {
		return firebaseUid;
	}

	public void setFirebaseUid(String firebaseUid) {
		this.firebaseUid = firebaseUid;
	}
}
