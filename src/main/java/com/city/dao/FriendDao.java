package com.city.dao;

import java.util.List;
import com.city.pojo.CityUsers;

public interface FriendDao {
    boolean addFriend(String userMail, String friendMail);
    boolean removeFriend(String userMail, String friendMail);
    List<CityUsers> getFriends(String userMail);
    List<CityUsers> getNonFriends(String userMail);
    boolean isFriend(String userMail, String friendMail);
}
