<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.PostQuestions, com.city.pojo.Answer" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Question — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  PostQuestions q = (PostQuestions) request.getAttribute("question");
  List<Answer> answers = (List<Answer>) request.getAttribute("answers");
  if (q == null) {
      response.sendRedirect(request.getContextPath() + "/ViewQuestionsServlet");
      return;
  }
  
  int answersCount = (answers != null) ? answers.size() : 0;
%>

<!-- NAV -->
<nav>
  <a href="home.jsp" class="nav-logo">
    <div class="nav-logo-mark">C</div>
    <span class="nav-logo-name">CityHub</span>
  </a>
  <ul class="nav-links">
    <li><a href="home.jsp">Home</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet" class="active">Explore</a></li>
    <li><a href="<%=request.getContextPath() %>/MarketplaceServlet">Marketplace</a></li>
    <li><a href="<%=request.getContextPath() %>/GamingServlet">Gaming Zone</a></li>
    <li><a href="<%=request.getContextPath() %>/FriendServlet">Friends</a></li>
    <li><a href="<%=request.getContextPath() %>/ProfileServlet">Profile</a></li>
  </ul>
  <div class="nav-right" id="navRight">
    <% if (userEmail != null) { %>
      <a href="askquestion.jsp" class="btn btn-ghost">+ Post Question</a>
      <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-primary">Sign out</a>
    <% } else { %>
      <a href="login.jsp" class="btn btn-ghost">Sign in</a>
      <a href="register.jsp" class="btn btn-primary">Join free</a>
    <% } %>
  </div>
</nav>

<!-- BREADCRUMB -->
<div class="breadcrumb" style="max-width:1196px">
  <a href="home.jsp">Home</a><span>›</span>
  <a href="<%=request.getContextPath() %>/ViewQuestionsServlet">Questions</a><span>›</span>
  <span><%= q.getCategory() %></span>
</div>

<!-- DETAIL LAYOUT -->
<div class="detail-wrap">
  <!-- LEFT: QUESTION -->
  <div>
    <% if (q.getImage() != null && !q.getImage().trim().isEmpty()) { %>
      <img src="<%= q.getImage() %>" alt="<%= q.getTitle() %>" class="detail-hero-img">
    <% } %>
    <div class="detail-badge">
      <span class="q-badge badge-restaurant"><%= q.getCategory() %></span>
    </div>
    <h1 class="detail-title"><%= q.getTitle() %></h1>

    <div class="detail-meta-row">
      <div class="d-author" onclick="window.location.href='ProfileServlet?mail=<%= q.getMail() %>';" style="cursor:pointer;">
        <img src="https://ui-avatars.com/api/?name=<%= q.getMail() %>&background=dbeafe&color=1d4ed8" class="d-author" style="width:34px;height:34px;border-radius:50%;border:1px solid var(--border)">
        <div>
          <div class="d-author-name" style="font-weight:600; text-decoration:underline;"><%= q.getMail() %></div>
          <div class="d-author-time">Asked recently</div>
        </div>
      </div>
      <span style="font-size:13px;color:var(--text-muted)">📍 <%= q.getLocation() %></span>
      <div class="d-actions">
        <!-- Like Toggle Form -->
        <form action="<%=request.getContextPath() %>/LikeServlet" method="post" style="display:inline">
          <input type="hidden" name="questionId" value="<%= q.getId() %>">
          <input type="hidden" name="redirect" value="detail">
          <button type="submit" class="action-btn">
            &#9825; <span id="likeCount"><%= q.getLikesCount() %></span>
          </button>
        </form>
        
        <button class="action-btn" id="shareBtn" onclick="sharePage()">&#8684; Share</button>
      </div>
    </div>

    <div class="detail-body">
      <p><%= q.getDescription() %></p>
    </div>

    <!-- ANSWERS -->
    <div class="answers-section">
      <h2><%= answersCount %> Answer<%= answersCount != 1 ? "s" : "" %></h2>
      <div id="answersList">
        <%
          if (answers != null) {
              for (Answer a : answers) {
        %>
          <div class="card answer-card fade-up">
            <div class="answer-top" onclick="window.location.href='ProfileServlet?mail=<%= a.getAnswerUsername() %>';" style="cursor:pointer;">
              <img src="https://ui-avatars.com/api/?name=<%= a.getAnswerUsername() %>&background=d1fae5&color=065f46" class="ans-avatar">
              <span class="ans-name" style="font-weight:600; text-decoration:underline;"><%= a.getAnswerUsername() %></span>
              <span class="ans-time">Replied recently</span>
            </div>
            <div class="answer-text"><%= a.getAnswer() %></div>
            <div class="vote-row" style="display:flex;gap:10px;align-items:center;margin-top:10px">
              <!-- Upvote -->
              <form action="<%=request.getContextPath() %>/AnswerFeedbackServlet" method="post" style="display:inline">
                <input type="hidden" name="answerId" value="<%= a.getAnswerId() %>">
                <input type="hidden" name="questionId" value="<%= q.getId() %>">
                <input type="hidden" name="action" value="upvote">
                <button type="submit" class="vote-btn" style="padding:6px 12px;border:1px solid var(--border);border-radius:6px;background:none;cursor:pointer">
                  ▲ <span><%= a.getUpvotes() %></span> Upvote
                </button>
              </form>

              <!-- Downvote -->
              <form action="<%=request.getContextPath() %>/AnswerFeedbackServlet" method="post" style="display:inline">
                <input type="hidden" name="answerId" value="<%= a.getAnswerId() %>">
                <input type="hidden" name="questionId" value="<%= q.getId() %>">
                <input type="hidden" name="action" value="downvote">
                <button type="submit" class="vote-btn" style="padding:6px 12px;border:1px solid var(--border);border-radius:6px;background:none;cursor:pointer">
                  ▼ <span><%= a.getDownvotes() %></span> Downvote
                </button>
              </form>

              <!-- Rate dropdown -->
              <form action="<%=request.getContextPath() %>/AnswerFeedbackServlet" method="post" style="display:inline-flex;gap:4px;align-items:center">
                <input type="hidden" name="answerId" value="<%= a.getAnswerId() %>">
                <input type="hidden" name="questionId" value="<%= q.getId() %>">
                <input type="hidden" name="action" value="rate">
                <select name="rating" style="padding:4px;border-radius:4px;border:1px solid var(--border)">
                  <option value="5">⭐⭐⭐⭐⭐ 5</option>
                  <option value="4">⭐⭐⭐⭐ 4</option>
                  <option value="3">⭐⭐⭐ 3</option>
                  <option value="2">⭐⭐ 2</option>
                  <option value="1">⭐ 1</option>
                </select>
                <button type="submit" class="btn btn-sm btn-outline" style="padding:4px 8px">Rate</button>
              </form>
              
              <% if (a.getRating() > 0) { %>
                <span style="font-size:12px;color:var(--text-secondary);margin-left:auto">Rating: <%= String.format(Locale.US, "%.1f", a.getRating()) %>/5</span>
              <% } %>
            </div>
          </div>
        <%
              }
          }
        %>
      </div>

      <!-- WRITE ANSWER -->
      <div class="card write-answer">
        <% if (userEmail != null) { %>
          <h3>Write your answer</h3>
          <form action="<%=request.getContextPath() %>/AnswerServlet" method="post">
            <input type="hidden" name="questionId" value="<%= q.getId() %>">
            <textarea name="answer" placeholder="Share what you know about this topic..." required style="width:100%;height:120px;padding:10px;border-radius:8px;border:1px solid var(--border);margin-bottom:12px"></textarea>
            <button type="submit" class="btn btn-primary">Post answer</button>
          </form>
        <% } else { %>
          <div style="text-align:center;padding:15px">
            <p>Please <a href="login.jsp" style="color:var(--accent);font-weight:600">sign in</a> to write an answer.</p>
          </div>
        <% } %>
      </div>
    </div>
  </div>

  <!-- RIGHT: SIDEBAR -->
  <aside>
    <!-- Location -->
    <div class="card sidebar-card">
      <div class="sidebar-card-title">Location</div>
      <img src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=320&h=140&fit=crop" class="map-img" alt="Map">
      <div class="loc-name"><%= q.getLocation() %></div>
      <div class="loc-addr">Maharashtra, India</div>
    </div>

    <!-- Stats -->
    <div class="card sidebar-card">
      <div class="sidebar-card-title">Question Stats</div>
      <div class="stat-row">
        <div class="stat-box"><div class="stat-box-num"><%= q.getLikesCount() * 8 + 19 %></div><div class="stat-box-label">Views</div></div>
        <div class="stat-box"><div class="stat-box-num"><%= answersCount %></div><div class="stat-box-label">Answers</div></div>
        <div class="stat-box"><div class="stat-box-num"><%= q.getLikesCount() %></div><div class="stat-box-label">Likes</div></div>
        <div class="stat-box"><div class="stat-box-num">3</div><div class="stat-box-label">Bookmarks</div></div>
      </div>
    </div>
  </aside>
</div>

<script src="app.js"></script>
<script>
function sharePage() {
  if (navigator.share) {
    navigator.share({ title: document.title, url: location.href });
  } else {
    navigator.clipboard && navigator.clipboard.writeText(location.href)
      .then(function() { showToast('Link copied to clipboard!', 'success'); })
      .catch(function() { showToast('Copy this URL: ' + location.href, 'success'); });
  }
}

document.addEventListener('DOMContentLoaded', function() {
  initFadeUp();
  <%
    String toastMsg = (String) session.getAttribute("toastMsg");
    String toastType = (String) session.getAttribute("toastType");
    if (toastMsg != null && toastType != null) {
  %>
    showToast("<%= toastMsg %>", "<%= toastType %>");
  <%
      session.removeAttribute("toastMsg");
      session.removeAttribute("toastType");
    }
  %>
});
</script>
</body>
</html>
