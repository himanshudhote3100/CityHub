<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.CityUsers, com.city.pojo.PostQuestions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  CityUsers profileUser = (CityUsers) request.getAttribute("profileUser");
  List<PostQuestions> userQuestions = (List<PostQuestions>) request.getAttribute("userQuestions");
  String badge = (String) request.getAttribute("badge");
  Integer friendsCount = (Integer) request.getAttribute("friendsCount");
  Integer totalAnswers = (Integer) request.getAttribute("totalAnswers");
  Boolean isOwnProfileObj = (Boolean) request.getAttribute("isOwnProfile");
  boolean isOwnProfile = isOwnProfileObj != null ? isOwnProfileObj : true;

  if (profileUser == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }

  int qAskedCount = (userQuestions != null) ? userQuestions.size() : 0;
  int totalAnswersCount = (totalAnswers != null ? totalAnswers : 0);
  int hubPts = profileUser.getHubPoints();
  double levelProgress = (hubPts % 100);
  int currentLevel = (hubPts / 100) + 1;
%>

<!-- NAV -->
<nav>
  <a href="home.jsp" class="nav-logo">
    <div class="nav-logo-mark">C</div>
    <span class="nav-logo-name">CityHub</span>
  </a>
  <ul class="nav-links">
    <li><a href="home.jsp">Home</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet">Explore</a></li>
    <li><a href="<%=request.getContextPath() %>/MarketplaceServlet">Marketplace</a></li>
    <li><a href="<%=request.getContextPath() %>/GamingServlet">Gaming Zone</a></li>
    <li><a href="<%=request.getContextPath() %>/FriendServlet">Friends</a></li>
    <li><a href="<%=request.getContextPath() %>/ProfileServlet" class="active">Profile</a></li>
  </ul>
  <div class="nav-right">
    <a href="askquestion.jsp" class="btn btn-ghost">+ Post Question</a>
    <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-primary">Sign out</a>
  </div>
</nav>

<!-- COVER IMAGE -->
<div class="profile-cover">
  <img src="https://images.unsplash.com/photo-1534430480872-3498386e7856?w=1200&h=220&fit=crop" alt="Cover">
</div>

<!-- PROFILE MAIN -->
<div class="profile-main">

  <!-- PROFILE TOP ROW -->
  <div class="profile-top-row">
    <img src="<%= profileUser.getProfilePic() %>" alt="Avatar" class="profile-avatar" onerror="this.src='https://ui-avatars.com/api/?name=<%= profileUser.getFirstname() %>+<%= profileUser.getLastname() %>&background=dbeafe&color=1d4ed8&size=200'">
    <div class="profile-info">
      <div class="profile-name"><%= profileUser.getFirstname() %> <%= profileUser.getLastname() %></div>
      <div class="profile-handle">📍 <%= profileUser.getCity() %> &middot; <%= profileUser.getMail() %></div>
      <div class="profile-badges">
        <span class="p-badge p-badge-verified">&#10003; Verified</span>
        <span class="p-badge p-badge-top"><%= badge %></span>
      </div>
    </div>
    <div class="profile-actions">
      <% if (isOwnProfile) { %>
        <button class="btn btn-primary" onclick="openEditModal()">Edit Profile Pic</button>
      <% } else { %>
        <%
          Boolean isFriendObj = (Boolean) request.getAttribute("isFriend");
          boolean isFriend = isFriendObj != null ? isFriendObj : false;
        %>
        <form action="<%=request.getContextPath() %>/FriendServlet" method="post" style="display:inline">
          <input type="hidden" name="friendMail" value="<%= profileUser.getMail() %>">
          <input type="hidden" name="redirect" value="profile">
          <% if (isFriend) { %>
            <input type="hidden" name="action" value="remove">
            <button type="submit" class="btn btn-outline" style="color: #dc2626; border-color: #fecaca; background: #fef2f2">Remove Friend</button>
          <% } else { %>
            <input type="hidden" name="action" value="add">
            <button type="submit" class="btn btn-primary">+ Add Friend</button>
          <% } %>
        </form>
      <% } %>
      <button class="btn btn-outline" onclick="shareProfile()">Share Profile</button>
    </div>
  </div>

  <!-- STATS BAR -->
  <div class="profile-stats-bar">
    <div>
      <span class="p-stat-num"><%= qAskedCount %></span>
      <span class="p-stat-label">Questions asked</span>
    </div>
    <div>
      <span class="p-stat-num"><%= totalAnswersCount %></span>
      <span class="p-stat-label">Answers given</span>
    </div>
    <div>
      <span class="p-stat-num"><%= friendsCount %></span>
      <span class="p-stat-label">Total friends</span>
    </div>
    <div>
      <span class="p-stat-num">1.2K</span>
      <span class="p-stat-label">Profile views</span>
    </div>
  </div>

  <!-- PROFILE LAYOUT -->
  <div class="profile-layout">

    <!-- MAIN: TABS -->
    <div>
      <div class="profile-tabs">
        <button class="profile-tab active" onclick="switchTab('questions',this)">Questions Asked</button>
      </div>

      <!-- QUESTIONS TAB -->
      <div id="tab-questions">
        <div class="profile-q-grid">
          <%
            if (userQuestions != null) {
                for (PostQuestions q : userQuestions) {
          %>
            <a href="<%=request.getContextPath() %>/QuestionDetailServlet?id=<%= q.getId() %>" class="card mini-q-card fade-up">
              <% if (q.getImage() != null && !q.getImage().trim().isEmpty()) { %>
                <img src="<%= q.getImage() %>" class="mini-q-img" alt="<%= q.getTitle() %>" onerror="this.style.display='none'">
              <% } %>
              <span class="q-badge badge-<%= q.getCategory().toLowerCase() %>"><%= q.getCategory() %></span>
              <div class="mini-q-title"><%= q.getTitle() %></div>
              <div class="mini-q-stats">&#9825; <%= q.getLikesCount() %> likes</div>
            </a>
          <%
                }
            }
            if (qAskedCount == 0) {
          %>
            <div class="empty-state" style="grid-column: 1 / -1">
              <div style="font-size:36px;margin-bottom:12px">&#9711;</div>
              <p><%= isOwnProfile ? "You haven't posted any questions yet." : profileUser.getFirstname() + " hasn't posted any questions yet." %></p>
              <% if (isOwnProfile) { %>
                <a href="askquestion.jsp" class="btn btn-primary">Ask a Question</a>
              <% } %>
            </div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- SIDEBAR -->
    <aside>
      <!-- About -->
      <div class="card about-card">
        <h3>About</h3>
        <div class="about-row">&#128205; <span><%= profileUser.getCity() %>, India</span></div>
        <div class="about-row">&#128197; Joined <span>recently</span></div>
        <div class="about-row">&#11088; Interests: Q&amp;A, Local explore</div>
      </div>

      <!-- Hub Points & Reputation -->
      <div class="card about-card">
        <h3>Hub Points</h3>
        <div class="hub-points-num"><%= hubPts %></div>
        <div class="hub-points-label">Total points earned</div>
        <div class="rep-bar-wrap">
          <div class="rep-bar"><div class="rep-bar-fill" style="width: <%= levelProgress %>%"></div></div>
          <div style="display:flex;justify-content:space-between">
            <div class="rep-label">Level <%= currentLevel %></div>
            <div class="rep-label">Progress to Level <%= currentLevel + 1 %></div>
          </div>
        </div>
        <div style="margin-top:12px;font-size:12px;color:var(--text-muted);line-height:1.6">
          +3 Hub points awarded for every answer you provide!
        </div>
      </div>

      <!-- Badges -->
      <div class="card about-card">
        <h3>Badges</h3>
        <div class="earned-badge <%= (totalAnswersCount < 25) ? "badge-locked" : "" %>">
          <span class="badge-icon">🏆</span>
          <div>
            <div class="badge-name">Helping Hero</div>
            <div class="badge-req">Give 25 answers (Current: <%= totalAnswersCount %>)</div>
          </div>
        </div>
        <div class="earned-badge <%= (totalAnswersCount < 50) ? "badge-locked" : "" %>">
          <span class="badge-icon">🛡</span>
          <div>
            <div class="badge-name">Helping Guardian</div>
            <div class="badge-req">Give 50 answers (Current: <%= totalAnswersCount %>)</div>
          </div>
        </div>
        <div class="earned-badge <%= (totalAnswersCount < 100) ? "badge-locked" : "" %>">
          <span class="badge-icon">🦸‍♂️</span>
          <div>
            <div class="badge-name">Helping Avenger</div>
            <div class="badge-req">Give 100 answers (Current: <%= totalAnswersCount %>)</div>
          </div>
        </div>
      </div>
    </aside>
  </div>
</div>

<!-- EDIT PROFILE MODAL -->
<div class="modal-overlay" id="editModal">
  <div class="modal-box" style="width: 500px;">
    <button class="modal-close" onclick="closeEditModal()">&times;</button>
    <h2 class="modal-title">Edit Profile Details</h2>
    <p class="modal-sub">Update your personal information and profile picture.</p>
    <form action="<%=request.getContextPath() %>/UpdateProfileServlet" method="post" enctype="multipart/form-data">
      <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px;">
        <div class="form-group">
          <label class="form-label">First Name</label>
          <input type="text" name="firstname" class="form-input" value="<%= profileUser.getFirstname() %>" required>
        </div>
        <div class="form-group">
          <label class="form-label">Last Name</label>
          <input type="text" name="lastname" class="form-input" value="<%= profileUser.getLastname() %>" required>
        </div>
      </div>
      <div class="form-group" style="margin-bottom: 16px;">
        <label class="form-label">City</label>
        <input type="text" name="city" class="form-input" value="<%= profileUser.getCity() %>" required>
      </div>
      <div class="form-group" style="margin-bottom: 16px;">
        <label class="form-label">Profile Pic (optional)</label>
        <input type="file" name="profilePicFile" class="form-input" accept="image/*">
      </div>
      <div style="display:flex;gap:8px;margin-top:20px">
        <button type="submit" class="btn btn-primary">Save Changes</button>
        <button type="button" class="btn btn-outline" onclick="closeEditModal()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script src="app.js"></script>
<script>
function shareProfile() {
  navigator.clipboard && navigator.clipboard.writeText(location.href)
    .then(function() { showToast('Profile link copied to clipboard!', 'success'); });
}

function openEditModal() {
  document.getElementById('editModal').classList.add('open');
}

function closeEditModal() {
  document.getElementById('editModal').classList.remove('open');
}

function switchTab(tabName, btn) {
  document.querySelectorAll('.profile-tab').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  const tabs = ['questions'];
  tabs.forEach(t => {
    const el = document.getElementById('tab-' + t);
    if (el) el.style.display = (t === tabName) ? 'block' : 'none';
  });
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
