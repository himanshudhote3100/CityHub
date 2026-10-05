package com.city.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.city.dao.AnswerDao;
import com.city.pojo.Answer;
import com.city.dbutil.DBUtil;

public class AnswerDaoImpl implements AnswerDao {

    @Override
    public boolean postAnswer(Answer answer) {
        String sql = "INSERT INTO answers (question_id, answer_text, answer_username, upvotes, downvotes, rating_sum, rating_count) VALUES(?, ?, ?, 0, 0, 0, 0)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getAnswer());
            ps.setString(3, answer.getAnswerUsername());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in postAnswer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Answer> getAnswersForQuestion(int questionId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM answers WHERE question_id = ? ORDER BY id DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Answer a = new Answer();
                    a.setAnswerId(rs.getInt("id"));
                    a.setQuestionId(rs.getInt("question_id"));
                    a.setAnswer(rs.getString("answer_text"));
                    a.setAnswerUsername(rs.getString("answer_username"));
                    a.setUpvotes(rs.getInt("upvotes"));
                    a.setDownvotes(rs.getInt("downvotes"));
                    int sum = rs.getInt("rating_sum");
                    int count = rs.getInt("rating_count");
                    a.setRating(count > 0 ? (double) sum / count : 0.0);
                    list.add(a);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getAnswersForQuestion: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean upvoteAnswer(int answerId) {
        String sql = "UPDATE answers SET upvotes = upvotes + 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, answerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in upvoteAnswer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean downvoteAnswer(int answerId) {
        String sql = "UPDATE answers SET downvotes = downvotes + 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, answerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in downvoteAnswer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean rateAnswer(int answerId, int rating) {
        String sql = "UPDATE answers SET rating_sum = rating_sum + ?, rating_count = rating_count + 1 WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setInt(2, answerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Exception in rateAnswer: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int getAnswerCountByUser(String email) {
        String sql = "SELECT COUNT(*) FROM answers WHERE answer_username = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Exception in getAnswerCountByUser: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
