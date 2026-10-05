<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Post a Question — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  if (userEmail == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }
  
  String questionMsg = (String) session.getAttribute("questionMsg");
  String questionMsgType = (String) session.getAttribute("questionMsgType");
  if (questionMsg != null) {
      session.removeAttribute("questionMsg");
      session.removeAttribute("questionMsgType");
  }
%>

<!-- AUTH NAV -->
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
  <div class="nav-right">
    <a href="askquestion.jsp" class="btn btn-primary active">+ Post Question</a>
    <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-ghost">Sign out</a>
  </div>
</nav>

<!-- CONTENT -->
<div class="post-wrap">
  <div style="margin-bottom:32px">
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet" style="font-size:13px;color:var(--text-muted);text-decoration:none">&#8592; Back to feed</a>
  </div>
  <h1>Post a Question</h1>
  <p class="post-sub">Get answers from locals who know your city best. Be specific for faster, better responses.</p>

  <% if (questionMsg != null) { %>
    <div class="form-alert <%= "error".equals(questionMsgType) ? "error" : "success" %>" style="display:block; margin-bottom:16px; padding:12px; border-radius:8px; font-size:13px; background: <%= "error".equals(questionMsgType) ? "#fef2f2" : "#f0fdf4" %>; color: <%= "error".equals(questionMsgType) ? "#dc2626" : "#16a34a" %>; border: 1px solid <%= "error".equals(questionMsgType) ? "#fecaca" : "#bbf7d0" %>;">
      <%= questionMsg %>
    </div>
  <% } %>

  <form id="postForm" action="InsertQuestionServlet" method="post" enctype="multipart/form-data">
    <input type="hidden" name="mail" value="<%= userEmail %>">

    <!-- TITLE -->
    <div class="form-group">
      <label class="form-label" for="qTitle">Question Title <span style="color:#dc2626">*</span></label>
      <input type="text" id="qTitle" name="title" class="form-input" placeholder="e.g. Best biryani places near Andheri East open late?" required maxlength="120">
      <div style="font-size:11px;color:var(--text-muted);margin-top:4px">Be specific — good titles get answered faster.</div>
    </div>

    <!-- CATEGORY -->
    <div class="form-group">
      <label class="form-label" for="qCategory">Category <span style="color:#dc2626">*</span></label>
      <select id="qCategory" name="category" class="form-input" required style="width: 100%; height: 42px; border: 1px solid var(--border); border-radius: var(--radius); padding: 0 10px;">
        <option value="">Select a category...</option>
        <option value="restaurant">🍽 Restaurants &amp; Food</option>
        <option value="park">🌿 Parks &amp; Outdoors</option>
        <option value="culture">🎨 Culture &amp; Art</option>
        <option value="shopping">🛍 Shopping</option>
        <option value="transport">🚌 Transport &amp; Commute</option>
        <option value="events">🎉 Events &amp; Entertainment</option>
        <option value="safety">🛡 Safety</option>
        <option value="service">🏢 Civic Services</option>
        <option value="healthcare">💊 Healthcare</option>
        <option value="education">📚 Education</option>
      </select>
    </div>

    <!-- DESCRIPTION -->
    <div class="form-group">
      <label class="form-label" for="qBody">Question Description <span style="color:#dc2626">*</span></label>
      <textarea id="qBody" name="description" class="form-input" style="min-height: 120px; resize: vertical;" placeholder="Provide details — location, time, budget, or any other context that would help someone answer you accurately..." required></textarea>
    </div>

    <!-- LOCATION -->
    <div class="form-group">
      <label class="form-label" for="qLocation">Location</label>
      <div class="form-input-wrap">
        <span class="form-input-icon">&#128205;</span>
        <input type="text" id="qLocation" name="location" class="form-input" placeholder="e.g. Andheri East, Mumbai">
      </div>
    </div>

    <!-- IMAGE FILE -->
    <div class="form-group">
      <label class="form-label" for="qImage">Upload Image (optional)</label>
      <div class="form-input-wrap">
        <span class="form-input-icon">&#128247;</span>
        <input type="file" id="qImage" name="imageFile" class="form-input" accept="image/*">
      </div>
    </div>



    <div style="display:flex;gap:10px;margin-top:20px">
      <button type="submit" class="btn btn-primary btn-lg">Post Question</button>
      <a href="<%=request.getContextPath() %>/ViewQuestionsServlet" class="btn btn-outline btn-lg">Cancel</a>
    </div>

  </form>
</div>

</body>
</html>
