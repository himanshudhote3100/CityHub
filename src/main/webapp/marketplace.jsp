<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.MarketplaceItem, com.city.pojo.CityUsers" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Marketplace — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  CityUsers currentUser = (session != null) ? (CityUsers) session.getAttribute("user") : null;
  List<MarketplaceItem> itemList = (List<MarketplaceItem>) request.getAttribute("itemList");
  
  if (userEmail == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }
  
  String currentCat = request.getParameter("cat");
  if (currentCat == null) currentCat = "all";
  String currentCity = request.getParameter("city");
  if (currentCity == null) currentCity = "";
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
    <li><a href="<%=request.getContextPath() %>/MarketplaceServlet" class="active">Marketplace</a></li>
    <li><a href="<%=request.getContextPath() %>/GamingServlet">Gaming Zone</a></li>
    <li><a href="<%=request.getContextPath() %>/FriendServlet">Friends</a></li>
    <li><a href="<%=request.getContextPath() %>/ProfileServlet">Profile</a></li>
  </ul>
  <div class="nav-right">
    <a href="askquestion.jsp" class="btn btn-ghost">+ Post Question</a>
    <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-primary">Sign out</a>
  </div>
</nav>

<!-- LOCKED STATE -->
<div class="section" style="max-width: 650px; margin: 80px auto; padding: 40px 24px; text-align: center;">
  <div class="card fade-up" style="padding: 48px 32px; border: 1px solid var(--border); border-radius: var(--radius-lg); box-shadow: var(--shadow); background: white; display: flex; flex-direction: column; align-items: center; gap: 24px;">
    <div style="font-size: 80px; filter: drop-shadow(0 4px 6px rgba(0,0,0,0.1)); line-height: 1;">🔒</div>
    <h2 style="font-family:'Playfair Display',Georgia,serif; font-size: 28px; font-weight: 700; color: var(--text); margin: 0;">Marketplace is Locked</h2>
    <p style="color: var(--text-secondary); font-size: 16px; line-height: 1.6; max-width: 450px; margin: 0 auto; font-weight: 500;">
      Marketplace is locked ,once unlocked you can access it using hub points 
    </p>
    <div style="margin-top: 12px; display: flex; gap: 12px; justify-content: center;">
      <a href="home.jsp" class="btn btn-primary">Go Back Home</a>
      <a href="<%=request.getContextPath() %>/GamingServlet" class="btn btn-outline">Play Games to Earn Points</a>
    </div>
  </div>
</div>


<script src="app.js"></script>
<script>
function openAddModal() {
  document.getElementById('addModal').classList.add('open');
}

function closeAddModal() {
  document.getElementById('addModal').classList.remove('open');
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
