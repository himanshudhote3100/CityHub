package com.city.dao;

import java.util.List;
import com.city.pojo.CityUsers;
import com.city.pojo.PostQuestions;

public interface CityUsersDao {
    boolean checkuser(CityUsers c);
    boolean registeruser(CityUsers c);
    boolean addquestions(PostQuestions p);
    List<PostQuestions> getAllQuestions();
    CityUsers getUserByMail(String email);
    boolean updateProfilePic(String email, String picUrl);
    boolean updateProfile(CityUsers user);
    List<PostQuestions> getQuestionsByMail(String email);
    boolean updateHubPoints(String email, int points);
    List<CityUsers> getTopContributors();
}
