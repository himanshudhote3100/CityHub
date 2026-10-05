<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.city.pojo.PostQuestions, com.city.daoimpl.CityUsersDaoImpl" %>
<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  if (userEmail != null) {
      response.sendRedirect(request.getContextPath() + "/home.jsp");
      return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CityHub — Connecting Corners of Your Town</title>
  <link rel="stylesheet" href="styles.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
</head>
<body>

<!-- NAV -->
<nav>
  <a href="index.jsp" class="nav-logo">
    <div class="nav-logo-mark">C</div>
    <span class="nav-logo-name">CityHub</span>
  </a>
  <ul class="nav-links">
    <li><a href="index.jsp" class="active">Home</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet">Explore</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=restaurant">Restaurants</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=culture">Culture</a></li>
    <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=events">Events</a></li>
  </ul>
  <div class="nav-right">
    <% if (userEmail != null) { %>
      <a href="<%=request.getContextPath() %>/FriendServlet" class="btn btn-ghost">Friends</a>
      <a href="<%=request.getContextPath() %>/ProfileServlet" class="btn btn-ghost">Profile</a>
      <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-primary">Sign out</a>
    <% } else { %>
      <a href="login.jsp" class="btn btn-ghost">Sign in</a>
      <a href="register.jsp" class="btn btn-primary">Join free</a>
    <% } %>
  </div>
</nav>

<!-- HERO -->
<div class="hero">
  <span class="hero-eyebrow">City review &amp; Q&amp;A platform</span>
  <h1>Discover every corner of <em>your city</em></h1>
  <p class="hero-sub">Ask questions, share reviews, and connect with people who know your neighborhood inside out. Real answers from real locals.</p>
  <div class="hero-actions">
    <% if (userEmail != null) { %>
      <a href="askquestion.jsp" class="btn btn-primary btn-lg">Ask a question</a>
    <% } else { %>
      <a href="register.jsp" class="btn btn-primary btn-lg">Get started free</a>
    <% } %>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet" class="btn btn-outline btn-lg">Browse questions</a>
  </div>
  <div class="hero-numbers">
    <div class="hero-num-item">
      <span class="hero-num">48K+</span>
      <span class="hero-num-label">Members</span>
    </div>
    <div class="hero-num-item">
      <span class="hero-num">120K+</span>
      <span class="hero-num-label">Questions answered</span>
    </div>
    <div class="hero-num-item">
      <span class="hero-num">320+</span>
      <span class="hero-num-label">Cities covered</span>
    </div>
    <div class="hero-num-item">
      <span class="hero-num">98%</span>
      <span class="hero-num-label">Satisfaction rate</span>
    </div>
  </div>
</div>

<!-- PHOTO STRIP -->
<div class="photo-strip">
  <div class="photo-strip-track">
    <img src="https://images.unsplash.com/photo-1529963183134-61a90db47eaf?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1444723121867-7a241cacace9?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1534430480872-3498386e7856?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1486325212027-8081e485255e?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1496568816309-51d7c20e3b21?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=260&h=160&fit=crop" alt="City">
    <!-- duplicate for seamless loop -->
    <img src="https://images.unsplash.com/photo-1529963183134-61a90db47eaf?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1444723121867-7a241cacace9?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1534430480872-3498386e7856?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1486325212027-8081e485255e?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1496568816309-51d7c20e3b21?w=260&h=160&fit=crop" alt="City">
    <img src="https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=260&h=160&fit=crop" alt="City">
  </div>
</div>

<!-- FEATURES -->
<div class="section">
  <div class="section-header">
    <div class="section-label">Everything you need</div>
    <h2 class="section-title">Your city, fully explored</h2>
    <p class="section-sub">From the best restaurant to the fastest commute route — get reliable local knowledge instantly.</p>
  </div>
  <div class="features-grid">
    <div class="card feature-card fade-up">
      <div class="feature-icon">&#127860;</div>
      <h3>Food &amp; Dining</h3>
      <p>Discover hidden gems, late-night spots, and the best value meals — curated by locals who eat there daily.</p>
    </div>
    <div class="card feature-card fade-up">
      <div class="feature-icon">&#128664;</div>
      <h3>Getting Around</h3>
      <p>Real-time commute tips, local transport hacks, and the best routes for every time of day.</p>
    </div>
    <div class="card feature-card fade-up">
      <div class="feature-icon">&#127807;</div>
      <h3>Parks &amp; Outdoors</h3>
      <p>Find green spaces, running trails, weekend picnic spots, and nature escapes within the city.</p>
    </div>
    <div class="card feature-card fade-up">
      <div class="feature-icon">&#127912;</div>
      <h3>Events &amp; Culture</h3>
      <p>Never miss a festival, exhibition, open mic, or neighbourhood event happening near you.</p>
    </div>
    <div class="card feature-card fade-up">
      <div class="feature-icon">&#128737;</div>
      <h3>Safety Tips</h3>
      <p>Community-sourced safety advice, trusted local insights, and area ratings from people who live there.</p>
    </div>
    <div class="card feature-card fade-up">
      <div class="feature-icon">&#127963;</div>
      <h3>Civic Services</h3>
      <p>Navigate permits, utilities, and local government services with step-by-step guides from experienced locals.</p>
    </div>
  </div>
</div>

<!-- CATEGORIES -->
<div class="section" style="padding-top:0">
  <div class="section-header">
    <div class="section-label">Browse by topic</div>
    <h2 class="section-title">What are you looking for?</h2>
  </div>
  <div class="pill-row">
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=restaurant" class="pill">&#127860; Restaurants</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=park" class="pill">&#127807; Parks</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=culture" class="pill">&#127912; Culture</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=shopping" class="pill">&#128722; Shopping</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=transport" class="pill">&#128664; Transport</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=events" class="pill">&#127881; Events</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=safety" class="pill">&#128737; Safety</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=service" class="pill">&#127963; Services</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=healthcare" class="pill">&#128138; Healthcare</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=education" class="pill">&#127979; Education</a>
  </div>
</div>

<!-- RECENT QUESTIONS -->
<div class="section" style="padding-top:0">
  <div class="section-header-row">
    <div>
      <div class="section-label">Community questions</div>
      <h2 class="section-title">Recently asked</h2>
    </div>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet" class="btn btn-outline">View all</a>
  </div>
  <div class="questions-grid">
    <%
      CityUsersDaoImpl userDao = new CityUsersDaoImpl();
      List<PostQuestions> qList = userDao.getAllQuestions();
      int count = 0;
      if (qList != null) {
          for (PostQuestions q : qList) {
              if (count >= 6) break;
              count++;
    %>
      <a href="<%=request.getContextPath() %>/QuestionDetailServlet?id=<%= q.getId() %>" class="card q-card fade-up">
        <div class="q-card-top">
          <img src="https://ui-avatars.com/api/?name=<%= q.getMail() %>&background=dbeafe&color=1d4ed8" class="q-avatar" alt="<%= q.getMail() %>">
          <span class="q-author"><%= q.getMail() %></span>
          <span class="q-time">Just now</span>
        </div>
        <% if (q.getImage() != null && !q.getImage().trim().isEmpty()) { %>
          <img src="<%= q.getImage() %>" class="q-img" alt="<%= q.getTitle() %>" onerror="this.style.display='none'">
        <% } %>
        <span class="q-badge badge-restaurant"><%= q.getCategory() %></span>
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
      }
      if (count == 0) {
    %>
      <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: var(--text-secondary);">
        <p>No questions posted yet. Be the first to ask!</p>
        <% if (userEmail != null) { %>
          <a href="askquestion.jsp" class="btn btn-primary" style="margin-top: 15px;">Ask a question</a>
        <% } %>
      </div>
    <% } %>
  </div>
</div>

<!-- HOW IT WORKS -->
<div style="background: white; border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); margin: 0;">
  <div class="section">
    <div class="section-header" style="text-align:center">
      <div class="section-label">Simple process</div>
      <h2 class="section-title">How CityHub works</h2>
      <p class="section-sub" style="margin:0 auto">Join thousands of city explorers sharing local knowledge every day.</p>
    </div>
    <div class="steps-grid">
      <div class="card step-card fade-up">
        <div class="step-num">Step 01</div>
        <h3>Create your account</h3>
        <p>Sign up with your email in under a minute. Choose your city and interests to personalise your feed.</p>
      </div>
      <div class="card step-card fade-up">
        <div class="step-num">Step 02</div>
        <h3>Pick your city</h3>
        <p>Select your neighbourhood or city to see questions and reviews most relevant to where you live and work.</p>
      </div>
      <div class="card step-card fade-up">
        <div class="step-num">Step 03</div>
        <h3>Ask or answer</h3>
        <p>Post a question and get answers within hours, or share your local knowledge to help neighbours.</p>
      </div>
      <div class="card step-card fade-up">
        <div class="step-num">Step 04</div>
        <h3>Build reputation</h3>
        <p>Earn Hub Points, unlock badges, and become a Top Contributor in your neighbourhood community.</p>
      </div>
    </div>
  </div>
</div>

<!-- TESTIMONIALS -->
<div class="section">
  <div class="section-header" style="text-align:center">
    <div class="section-label">Loved by locals</div>
    <h2 class="section-title">What people are saying</h2>
  </div>
  <div class="testimonials-grid">
    <div class="card testimonial-card fade-up">
      <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
      <p class="testimonial-text">"I found the best cardiologist near my office, a late-night dhaba that delivers, and the fastest route to the airport — all in one week. CityHub is now my first stop for anything Mumbai-related."</p>
      <div class="testimonial-author">
        <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop&crop=face" alt="Riya Patel">
        <div>
          <div class="t-name">Riya Patel</div>
          <div class="t-city">Andheri East, Mumbai</div>
        </div>
      </div>
    </div>
    <div class="card testimonial-card fade-up">
      <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
      <p class="testimonial-text">"As someone who just relocated from Bengaluru to Pune, CityHub was a lifesaver. Within days I had a local doctor, a trusted mechanic, and three great coffee shops near my flat."</p>
      <div class="testimonial-author">
        <img src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=80&h=80&fit=crop&crop=face" alt="Vikram Nair">
        <div>
          <div class="t-name">Vikram Nair</div>
          <div class="t-city">Koregaon Park, Pune</div>
        </div>
      </div>
    </div>
    <div class="card testimonial-card fade-up">
      <div class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</div>
      <p class="testimonial-text">"I answered a question about my neighbourhood park and got 40 upvotes! The feeling of genuinely helping someone new to the city is unlike any other platform. I am addicted."</p>
      <div class="testimonial-author">
        <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=80&h=80&fit=crop&crop=face" alt="Meera Joshi">
        <div>
          <div class="t-name">Meera Joshi</div>
          <div class="t-city">Bandra West, Mumbai</div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- CTA BAND -->
<div class="cta-band">
  <h2>Ready to explore your city?</h2>
  <p>Join 48,000+ locals sharing knowledge about their neighbourhoods every day.</p>
  <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap">
    <a href="register.jsp" class="btn btn-white btn-lg">Create free account</a>
    <a href="<%=request.getContextPath() %>/ViewQuestionsServlet" class="btn btn-white-outline btn-lg">Browse questions</a>
  </div>
</div>

<!-- FOOTER -->
<footer>
  <div class="footer-inner">
    <div class="footer-top">
      <div class="footer-col">
        <a href="index.jsp" class="nav-logo" style="margin-bottom:12px;display:inline-flex">
          <div class="nav-logo-mark">C</div>
          <span class="nav-logo-name">CityHub</span>
        </a>
        <p class="footer-brand-desc">Connecting city residents with the local knowledge they need to live, work, and explore their neighbourhoods confidently.</p>
      </div>
      <div class="footer-col">
        <h4>Platform</h4>
        <ul>
          <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet">Explore Questions</a></li>
          <li><a href="askquestion.jsp">Ask a Question</a></li>
          <li><a href="register.jsp">Join CityHub</a></li>
          <li><a href="#">Leaderboard</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Categories</h4>
        <ul>
          <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=restaurant">Restaurants</a></li>
          <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=events">Events</a></li>
          <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=safety">Safety</a></li>
          <li><a href="<%=request.getContextPath() %>/ViewQuestionsServlet?cat=transport">Transport</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Company</h4>
        <ul>
          <li><a href="#">About</a></li>
          <li><a href="#">Blog</a></li>
          <li><a href="#">Privacy</a></li>
          <li><a href="#">Terms</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <span>&#169; 2025 CityHub. Made for city explorers.</span>
      <span>Built with care for local communities.</span>
    </div>
  </div>
</footer>

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
