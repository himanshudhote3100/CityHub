<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.*, com.city.daoimpl.*" %>
<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  if (userEmail == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }

  CityUsersDaoImpl userDao = new CityUsersDaoImpl();
  AnswerDaoImpl answerDao = new AnswerDaoImpl();
  FriendDaoImpl friendDao = new FriendDaoImpl();

  CityUsers currentUser = userDao.getUserByMail(userEmail);
  if (currentUser == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }

  // Read Hub Points from database record
  int calculatedPoints = currentUser.getHubPoints();

  // Fetch top contributors
  List<CityUsers> topContributors = userDao.getTopContributors();

  // Get friends list to check questions
  List<CityUsers> friends = friendDao.getFriends(userEmail);
  Set<String> friendEmails = new HashSet<>();
  for (CityUsers f : friends) {
      friendEmails.add(f.getMail());
  }

  // Fetch all questions and sort/partition them
  List<PostQuestions> allQs = userDao.getAllQuestions();
  List<PostQuestions> friendsQs = new ArrayList<>();
  List<PostQuestions> recentQs = new ArrayList<>();
  List<PostQuestions> myQs = new ArrayList<>();

  for (PostQuestions q : allQs) {
      if (q.getMail().equals(userEmail)) {
          myQs.add(q);
      }
      
      if (friendEmails.contains(q.getMail())) {
          friendsQs.add(q);
      } else if (!q.getMail().equals(userEmail)) {
          recentQs.add(q);
      }
  }

  int hubPts = currentUser.getHubPoints();
  double levelProgress = (hubPts % 100);
  int currentLevel = (hubPts / 100) + 1;
  
  // Greet message based on time of day
  int hour = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY);
  String greet = hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home Feed — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<!-- NAV -->
<nav>
  <a href="home.jsp" class="nav-logo">
    <div class="nav-logo-mark">C</div>
    <span class="nav-logo-name">CityHub</span>
  </a>
  <ul class="nav-links">
    <li><a href="home.jsp" class="active">Home</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet">Explore</a></li>
    <li><a href="<%=request.getContextPath() %>/MarketplaceServlet">Marketplace</a></li>
    <li><a href="<%=request.getContextPath() %>/GamingServlet">Gaming Zone</a></li>
    <li><a href="<%=request.getContextPath() %>/FriendServlet">Friends</a></li>
    <li><a href="<%=request.getContextPath() %>/ProfileServlet">Profile</a></li>
  </ul>
  <div class="nav-right">
    <a href="askquestion.jsp" class="btn btn-primary">+ Post Question</a>
    <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-ghost">Sign out</a>
  </div>
</nav>

<!-- PAGE TOP BAND -->
<div style="background:white;border-bottom:1px solid var(--border);padding:20px 48px">
  <div style="max-width:1100px;margin:0 auto;display:flex;align-items:center;justify-content:space-between">
    <div>
      <h1 style="font-size:22px;font-weight:700;margin-bottom:2px"><%= greet %>, <%= currentUser.getFirstname() %>!</h1>
      <p style="font-size:14px;color:var(--text-secondary)">Here's what's happening in your city today.</p>
    </div>
    <div style="display:flex;gap:8px">
      <button class="btn btn-outline btn-sm" onclick="location.reload()">&#8635; Refresh Feed</button>
    </div>
  </div>
</div>

<!-- FEED -->
<div class="feed-wrap">
  <!-- MAIN FEED -->
  <div class="feed-main">


    <!-- FRIENDS QUESTIONS -->
    <div class="feed-section">
      <div class="feed-section-header">
        <div>
          <div class="feed-section-label">From your network</div>
          <div class="feed-section-title">&#128101; Friends' Questions</div>
        </div>
        <a href="<%=request.getContextPath() %>/FriendServlet" class="btn btn-sm btn-outline">Manage friends</a>
      </div>
      <div class="questions-grid">
        <%
          int fCount = 0;
          for (PostQuestions q : friendsQs) {
              if (fCount >= 4) break;
              fCount++;
        %>
          <a href="<%=request.getContextPath() %>/QuestionDetailServlet?id=<%= q.getId() %>" class="card q-card fade-up">
            <div class="q-card-top">
              <img src="<%= q.getProfilePic() != null && !q.getProfilePic().trim().isEmpty() ? q.getProfilePic() : "https://ui-avatars.com/api/?name=" + q.getMail() + "&background=dbeafe&color=1d4ed8" %>" class="q-avatar" alt="<%= q.getMail() %>" onclick="event.preventDefault(); event.stopPropagation(); window.location.href='ProfileServlet?mail=<%= q.getMail() %>';" style="cursor:pointer;">
              <span class="q-author" onclick="event.preventDefault(); event.stopPropagation(); window.location.href='ProfileServlet?mail=<%= q.getMail() %>';" style="cursor:pointer; text-decoration:underline; font-weight:600;"><%= q.getMail() %></span>
              <span class="q-time">Active</span>
            </div>
            <% if (q.getImage() != null && !q.getImage().trim().isEmpty()) { %>
              <img src="<%= q.getImage() %>" class="q-img" alt="<%= q.getTitle() %>" onerror="this.style.display='none'">
            <% } %>
            <span class="q-badge badge-<%= q.getCategory().toLowerCase() %>"><%= q.getCategory() %></span>
            <div class="q-title"><%= q.getTitle() %></div>
            <div class="q-excerpt"><%= q.getDescription() %></div>
            <div class="q-footer">
              <span class="q-stat">&#128172; Answers</span>
              <span class="q-stat">&#9825; <%= q.getLikesCount() %></span>
              <span class="q-location">&#128205; <%= q.getLocation() %></span>
            </div>
          </a>
        <%
          }
          if (fCount == 0) {
        %>
          <div class="empty-state" style="grid-column: 1 / -1; padding:20px 0">
            <p>No questions from friends yet.</p>
            <a href="<%=request.getContextPath() %>/FriendServlet" class="btn btn-sm btn-outline" style="margin-top: 8px;">Find Friends</a>
          </div>
        <% } %>
      </div>
    </div>

    <!-- RECENTLY POSTED -->
    <div class="feed-section">
      <div class="feed-section-header">
        <div>
          <div class="feed-section-label">Latest from the community</div>
          <div class="feed-section-title">&#128337; Recently Posted</div>
        </div>
        <a href="<%=request.getContextPath() %>/ViewQuestionsServlet" class="btn btn-sm btn-outline">Browse all</a>
      </div>
      <div class="questions-grid">
        <%
          int rCount = 0;
          for (PostQuestions q : recentQs) {
              if (rCount >= 4) break;
              rCount++;
        %>
          <a href="<%=request.getContextPath() %>/QuestionDetailServlet?id=<%= q.getId() %>" class="card q-card fade-up">
            <div class="q-card-top">
              <img src="<%= q.getProfilePic() != null && !q.getProfilePic().trim().isEmpty() ? q.getProfilePic() : "https://ui-avatars.com/api/?name=" + q.getMail() + "&background=dbeafe&color=1d4ed8" %>" class="q-avatar" alt="<%= q.getMail() %>" onclick="event.preventDefault(); event.stopPropagation(); window.location.href='ProfileServlet?mail=<%= q.getMail() %>';" style="cursor:pointer;">
              <span class="q-author" onclick="event.preventDefault(); event.stopPropagation(); window.location.href='ProfileServlet?mail=<%= q.getMail() %>';" style="cursor:pointer; text-decoration:underline; font-weight:600;"><%= q.getMail() %></span>
              <span class="q-time">Active</span>
            </div>
            <% if (q.getImage() != null && !q.getImage().trim().isEmpty()) { %>
              <img src="<%= q.getImage() %>" class="q-img" alt="<%= q.getTitle() %>" onerror="this.style.display='none'">
            <% } %>
            <span class="q-badge badge-<%= q.getCategory().toLowerCase() %>"><%= q.getCategory() %></span>
            <div class="q-title"><%= q.getTitle() %></div>
            <div class="q-excerpt"><%= q.getDescription() %></div>
            <div class="q-footer">
              <span class="q-stat">&#128172; Answers</span>
              <span class="q-stat">&#9825; <%= q.getLikesCount() %></span>
              <span class="q-location">&#128205; <%= q.getLocation() %></span>
            </div>
          </a>
        <%
          }
          if (rCount == 0) {
        %>
          <div class="empty-state" style="grid-column: 1 / -1; padding:20px 0">
            <p>No questions posted yet.</p>
          </div>
        <% } %>
      </div>
    </div>

  </div>

  <!-- SIDEBAR -->
  <aside>
    <!-- User Card -->
    <div class="card sidebar-widget" style="text-align:center;margin-bottom:14px">
      <img src="<%= currentUser.getProfilePic() %>" alt="User" style="width:60px;height:60px;border-radius:50%;object-fit:cover;border:2px solid var(--border);margin:0 auto 10px;display:block" onerror="this.src='https://ui-avatars.com/api/?name=<%= currentUser.getFirstname() %>+<%= currentUser.getLastname() %>&background=dbeafe&color=1d4ed8'">
      <div style="font-size:15px;font-weight:700;margin-bottom:2px"><%= currentUser.getFirstname() %> <%= currentUser.getLastname() %></div>
      <div style="font-size:13px;color:var(--text-muted);margin-bottom:12px">📍 <%= currentUser.getCity() %></div>
      <div style="display:flex;gap:0;border:1px solid var(--border);border-radius:8px;overflow:hidden">
        <a href="<%=request.getContextPath() %>/ProfileServlet" class="btn btn-ghost btn-sm" style="flex:1;border-radius:0;border-right:1px solid var(--border)">Profile</a>
        <a href="askquestion.jsp" class="btn btn-ghost btn-sm" style="flex:1;border-radius:0">Ask Q</a>
      </div>
    </div>

    <!-- Hub Points -->
    <div class="card sidebar-widget" style="margin-bottom:14px">
      <div class="widget-title">Hub Points</div>
      <div style="font-size:28px;font-weight:700;color:var(--accent)"><%= hubPts %></div>
      <div style="font-size:12px;color:var(--text-muted);margin-bottom:8px">Points earned</div>
      <div class="rep-bar"><div class="rep-bar-fill" style="width: <%= levelProgress %>%"></div></div>
      <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--text-muted)">
        <span>Level <%= currentLevel %></span>
        <span>Progress to Level <%= currentLevel + 1 %></span>
      </div>
    </div>

    <!-- Top Contributors -->
    <div class="card sidebar-widget">
      <div class="widget-title">Top Contributors</div>
      <div id="topContributors">
        <%
          int rank = 1;
          for (CityUsers contributor : topContributors) {
        %>
          <div class="top-contributor" onclick="window.location.href='ProfileServlet?mail=<%= contributor.getMail() %>';" style="cursor:pointer;">
            <img src="<%= contributor.getProfilePic() %>" class="tc-avatar" alt="<%= contributor.getFirstname() %>" onerror="this.src='https://ui-avatars.com/api/?name=<%= contributor.getFirstname() %>+<%= contributor.getLastname() %>&background=dbeafe&color=1d4ed8'">
            <div>
              <div class="tc-name" style="font-weight:600; text-decoration:underline;"><%= contributor.getFirstname() %> <%= contributor.getLastname() %></div>
              <div class="tc-points"><%= contributor.getHubPoints() %> pts</div>
            </div>
            <span class="tc-rank">#<%= rank++ %></span>
          </div>
        <%
          }
        %>
      </div>
    </div>
  </aside>
</div>

<script src="app.js"></script>
<script>
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
