<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.PostQuestions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Explore Questions — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  List<PostQuestions> qList = (List<PostQuestions>) request.getAttribute("qList");
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

<!-- PAGE TOP -->
<div class="page-top">
  <div>
    <h1>Explore Questions</h1>
    <p>Browse questions from your city community — sorted by newest, most popular, or unanswered.</p>
  </div>
  <% if (userEmail != null) { %>
    <a href="askquestion.jsp" class="btn btn-primary" id="askBtn">+ Ask a Question</a>
  <% } else { %>
    <a href="login.jsp" class="btn btn-primary" id="askBtn">Sign in to Ask</a>
  <% } %>
</div>

<!-- LAYOUT -->
<div class="questions-layout">
  <!-- SIDEBAR FILTERS -->
  <aside class="sidebar-filters">
    <h3>Sort by</h3>
    <ul class="filter-list" id="sortList">
      <li class="active"><button onclick="setSort('newest',this)">&#128337; Newest</button></li>
      <li><button onclick="setSort('popular',this)">&#128293; Popular</button></li>
    </ul>

    <h3>Category</h3>
    <ul class="filter-list" id="catList">
      <li class="active"><button onclick="setCat('all',this)">&#127759; All Categories</button></li>
      <li><button onclick="setCat('restaurant',this)">🍽 Restaurants</button></li>
      <li><button onclick="setCat('park',this)">🌿 Parks</button></li>
      <li><button onclick="setCat('culture',this)">🎨 Culture</button></li>
      <li><button onclick="setCat('shopping',this)">🛍 Shopping</button></li>
      <li><button onclick="setCat('transport',this)">🚌 Transport</button></li>
      <li><button onclick="setCat('events',this)">🎉 Events</button></li>
      <li><button onclick="setCat('safety',this)">🛡 Safety</button></li>
      <li><button onclick="setCat('service',this)">🏢 Services</button></li>
      <li><button onclick="setCat('healthcare',this)">💊 Healthcare</button></li>
      <li><button onclick="setCat('education',this)">📚 Education</button></li>
    </ul>
  </aside>

  <!-- MAIN CONTENT -->
  <div>
    <div class="q-controls">
      <div class="search-wrap">
        <span class="search-icon">&#128269;</span>
        <input type="text" id="searchInput" placeholder="Search questions..." oninput="applyFilters()">
      </div>
      <select class="sort-select" id="sortSelect" onchange="setSort(this.value, null)">
        <option value="newest">Newest First</option>
        <option value="popular">Most Popular</option>
      </select>
    </div>

    <div class="results-info" id="resultsInfo">Showing questions</div>
    <div class="questions-grid" id="questionsGrid"></div>
  </div>
</div>

<script src="app.js"></script>
<script>
// Serialize database query results directly to JS
var DB_QUESTIONS = [
  <%
    if (qList != null) {
        for (int i = 0; i < qList.size(); i++) {
            PostQuestions q = qList.get(i);
  %>
    {
      id: <%= q.getId() %>,
      author: "<%= q.getMail() %>",
      avatar: "<%= q.getProfilePic() != null && !q.getProfilePic().trim().isEmpty() ? q.getProfilePic() : "https://ui-avatars.com/api/?name=" + q.getMail() + "&background=dbeafe&color=1d4ed8" %>",
      time: "Just now",
      cat: "<%= q.getCategory() != null ? q.getCategory().toLowerCase() : "" %>",
      badge: "badge-<%= q.getCategory() != null ? q.getCategory().toLowerCase() : "restaurant" %>",
      label: "<%= q.getCategory() != null ? q.getCategory().substring(0, 1).toUpperCase() + q.getCategory().substring(1) : "" %>",
      title: "<%= q.getTitle().replace("\"", "\\\"") %>",
      body: "<%= q.getDescription() != null ? q.getDescription().replace("\"", "\\\"").replace("\n", " ") : "" %>",
      excerpt: "<%= q.getDescription() != null ? (q.getDescription().length() > 80 ? q.getDescription().substring(0, 80).replace("\"", "\\\"").replace("\n", " ") + "..." : q.getDescription().replace("\"", "\\\"").replace("\n", " ")) : "" %>",
      image: "<%= q.getImage() != null ? q.getImage() : "" %>",
      answers: 0,
      likes: <%= q.getLikesCount() %>,
      location: "<%= q.getLocation() %>"
    }<%= i < qList.size() - 1 ? "," : "" %>
  <%
        }
    }
  %>
];

var currentSort = 'newest';
var currentCat = 'all';

document.addEventListener('DOMContentLoaded', function() {
  var params = new URLSearchParams(window.location.search);
  var catParam = params.get('cat');
  if (catParam) {
    currentCat = catParam;
    var catBtns = document.querySelectorAll('#catList li');
    catBtns.forEach(function(li) { li.classList.remove('active'); });
    var found = document.querySelector('#catList button[onclick*="' + catParam + '"]');
    if (found) found.parentElement.classList.add('active');
  }

  applyFilters();
  
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

function setSort(val, btn) {
  currentSort = val;
  document.getElementById('sortSelect').value = val;
  if (btn) {
    document.querySelectorAll('#sortList li').forEach(function(li) { li.classList.remove('active'); });
    btn.parentElement.classList.add('active');
  }
  applyFilters();
}

function setCat(val, btn) {
  currentCat = val;
  document.querySelectorAll('#catList li').forEach(function(li) { li.classList.remove('active'); });
  btn.parentElement.classList.add('active');
  applyFilters();
}

function applyFilters() {
  var search = document.getElementById('searchInput').value.toLowerCase();
  
  var filtered = DB_QUESTIONS.filter(function(q) {
    var matchCat = currentCat === 'all' || q.cat === currentCat;
    var matchSearch = !search || q.title.toLowerCase().includes(search) || q.body.toLowerCase().includes(search);
    return matchCat && matchSearch;
  });

  if (currentSort === 'popular') {
    filtered.sort(function(a, b) { return b.likes - a.likes; });
  } else {
    // Newest is default
    filtered.sort(function(a, b) { return b.id - a.id; });
  }

  document.getElementById('resultsInfo').textContent = 'Showing ' + filtered.length + ' question' + (filtered.length !== 1 ? 's' : '');

  var grid = document.getElementById('questionsGrid');
  grid.innerHTML = '';
  if (filtered.length === 0) {
    grid.innerHTML = '<div class="empty-state" style="grid-column:1/-1"><p>No questions found matching the selection.</p><a href="askquestion.jsp" class="btn btn-primary">Ask the first question</a></div>';
    return;
  }
  filtered.forEach(function(q) { 
    grid.innerHTML += renderQuestionCard(q, 'QuestionDetailServlet?id=' + q.id); 
  });
  initFadeUp();
}
</script>
</body>
</html>
