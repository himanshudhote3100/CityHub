package com.city.pojo;

public class Friend {
    private String userMail;
    private String friendMail;

    public Friend() {
    }

    public Friend(String userMail, String friendMail) {
        this.userMail = userMail;
        this.friendMail = friendMail;
    }

    public String getUserMail() {
        return userMail;
    }

    public void setUserMail(String userMail) {
        this.userMail = userMail;
    }

    public String getFriendMail() {
        return friendMail;
    }

    public void setFriendMail(String friendMail) {
        this.friendMail = friendMail;
    }
}
