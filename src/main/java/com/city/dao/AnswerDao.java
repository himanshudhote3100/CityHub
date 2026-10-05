package com.city.dao;

import java.util.List;
import com.city.pojo.Answer;

public interface AnswerDao {
    boolean postAnswer(Answer answer);
    List<Answer> getAnswersForQuestion(int questionId);
    boolean upvoteAnswer(int answerId);
    boolean downvoteAnswer(int answerId);
    boolean rateAnswer(int answerId, int rating);
    int getAnswerCountByUser(String email);
}
