package com.city.pojo;

public class Answer {
    private int answerId;
    private int questionId;
    private String question;
    private String questionUsername;
    private String answer;
    private String answerUsername;
    private int upvotes;
    private int downvotes;
    private double rating;

    public Answer() {
    }

    public Answer(int answerId, int questionId, String question, String questionUsername, String answer, String answerUsername, int upvotes, int downvotes, double rating) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.question = question;
        this.questionUsername = questionUsername;
        this.answer = answer;
        this.answerUsername = answerUsername;
        this.upvotes = upvotes;
        this.downvotes = downvotes;
        this.rating = rating;
    }

    public int getAnswerId() {
        return answerId;
    }

    public void setAnswerId(int answerId) {
        this.answerId = answerId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getQuestionUsername() {
        return questionUsername;
    }

    public void setQuestionUsername(String questionUsername) {
        this.questionUsername = questionUsername;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getAnswerUsername() {
        return answerUsername;
    }

    public void setAnswerUsername(String answerUsername) {
        this.answerUsername = answerUsername;
    }

    public int getUpvotes() {
        return upvotes;
    }

    public void setUpvotes(int upvotes) {
        this.upvotes = upvotes;
    }

    public int getDownvotes() {
        return downvotes;
    }

    public void setDownvotes(int downvotes) {
        this.downvotes = downvotes;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
}
