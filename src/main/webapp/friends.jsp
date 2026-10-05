<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.CityUsers" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Friends — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  List<CityUsers> friendsList = (List<CityUsers>) request.getAttribute("friendsList");
  List<CityUsers> nonFriendsList = (List<CityUsers>) request.getAttribute("nonFriendsList");
  
  if (userEmail == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }
  
  int friendsCount = (friendsList != null) ? friendsList.size() : 0;
%>

<!-- AUTH NAV -->
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
    <li><a href="<%=request.getContextPath() %>/FriendServlet" class="active">Friends</a></li>
    <li><a href="<%=request.getContextPath() %>/ProfileServlet">Profile</a></li>
  </ul>
  <div class="nav-right">
    <a href="askquestion.jsp" class="btn btn-ghost">+ Post Question</a>
    <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-primary">Sign out</a>
  </div>
</nav>

<!-- CONTENT -->
<div class="friends-wrap">

  <!-- PAGE HEADER -->
  <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:32px">
    <div>
      <h1>Friends</h1>
      <p class="friends-sub">Connect with locals who share your city.</p>
    </div>
    <div style="font-size:13px;color:var(--text-muted)"><span><%= friendsCount %></span> friends</div>
  </div>

  <!-- CURRENT FRIENDS -->
  <div style="margin-bottom:44px">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:18px;padding-bottom:12px;border-bottom:1px solid var(--border)">
      <div>
        <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;color:var(--text-muted);margin-bottom:4px">Your Network</div>
        <div style="font-size:18px;font-weight:700">Current Friends</div>
      </div>
    </div>

    <div class="friends-grid">
      <%
        if (friendsList != null) {
            for (CityUsers f : friendsList) {
      %>
        <div class="card friend-card fade-up">
          <a href="<%=request.getContextPath() %>/ProfileServlet?mail=<%= f.getMail() %>" style="text-decoration: none; color: inherit;">
            <img src="<%= f.getProfilePic() %>" class="friend-avatar" alt="<%= f.getFirstname() %>" onerror="this.src='https://ui-avatars.com/api/?name=<%= f.getFirstname() %>+<%= f.getLastname() %>&background=dbeafe&color=1d4ed8'">
            <div class="friend-name" style="font-weight:600; margin-bottom: 2px;"><%= f.getFirstname() %> <%= f.getLastname() %></div>
          </a>
          <div class="friend-city">📍 <%= f.getCity() %></div>
          <div class="friend-stats">⭐ <%= f.getHubPoints() %> pts</div>
          
          <form action="<%=request.getContextPath() %>/FriendServlet" method="post">
            <input type="hidden" name="action" value="remove">
            <input type="hidden" name="friendMail" value="<%= f.getMail() %>">
            <button type="submit" class="btn btn-outline btn-sm btn-full" style="margin-top: 10px; color: #dc2626; border-color: #fecaca; background: #fef2f2">Remove Friend</button>
          </form>
        </div>
      <%
            }
        }
        if (friendsCount == 0) {
      %>
        <div class="empty-state" style="grid-column:1/-1">
          <p>No friends yet. Add some below!</p>
        </div>
      <% } %>
    </div>
  </div>

  <!-- ADD FRIENDS -->
  <div>
    <div style="margin-bottom:18px;padding-bottom:12px;border-bottom:1px solid var(--border)">
      <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.5px;color:var(--text-muted);margin-bottom:4px">Discover People</div>
      <div style="font-size:18px;font-weight:700">Add Friends</div>
    </div>

    <div class="friends-search-wrap">
      <span class="friends-search-icon">&#128269;</span>
      <input type="text" id="addSearch" placeholder="Search by name or city..." oninput="filterAdd(this.value)">
    </div>

    <div id="addList">
      <%
        if (nonFriendsList != null) {
            for (CityUsers nf : nonFriendsList) {
      %>
        <div class="card add-user-row fade-up" data-name="<%= nf.getFirstname().toLowerCase() %> <%= nf.getLastname().toLowerCase() %>" data-city="<%= nf.getCity().toLowerCase() %>" style="display: flex; align-items: center; gap: 12px; padding: 12px;">
          <a href="<%=request.getContextPath() %>/ProfileServlet?mail=<%= nf.getMail() %>" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 12px; flex-grow: 1;">
            <img src="<%= nf.getProfilePic() %>" class="add-user-avatar" alt="<%= nf.getFirstname() %>" onerror="this.src='https://ui-avatars.com/api/?name=<%= nf.getFirstname() %>+<%= nf.getLastname() %>&background=dbeafe&color=1d4ed8'">
            <div>
              <div class="add-user-name" style="font-weight:600;"><%= nf.getFirstname() %> <%= nf.getLastname() %></div>
              <div class="add-user-city" style="font-size:12px; color:var(--text-muted); margin-top:2px;">📍 <%= nf.getCity() %> &nbsp;·&nbsp; ⭐ <%= nf.getHubPoints() %> pts</div>
            </div>
          </a>
          <div class="add-user-btn" style="margin-left: auto">
            <form action="<%=request.getContextPath() %>/FriendServlet" method="post">
              <input type="hidden" name="action" value="add">
              <input type="hidden" name="friendMail" value="<%= nf.getMail() %>">
              <button type="submit" class="btn btn-sm btn-primary">+ Add Friend</button>
            </form>
          </div>
        </div>
      <%
            }
        }
        if (nonFriendsList == null || nonFriendsList.isEmpty()) {
      %>
        <div class="empty-state" style="padding:30px 0">
          <p>No new users to add right now.</p>
        </div>
      <% } %>
    </div>
  </div>

</div>

<script src="app.js"></script>
<script>
function filterAdd(val) {
  var query = val.toLowerCase().trim();
  var rows = document.querySelectorAll('#addList .add-user-row');
  rows.forEach(function(row) {
    var name = row.getAttribute('data-name');
    var city = row.getAttribute('data-city');
    if (name.includes(query) || city.includes(query)) {
      row.style.display = 'flex';
    } else {
      row.style.display = 'none';
    }
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
