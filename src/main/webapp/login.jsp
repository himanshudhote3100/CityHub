<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign In — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String loginError = (String) request.getAttribute("loginError");
  String regSuccess = (String) request.getAttribute("regSuccess");

  String firebaseApiKey = "";
  String firebaseAuthDomain = "";
  String firebaseProjectId = "";
  String firebaseAppId = "";

  try (java.io.InputStream input = com.city.dbutil.DBUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
      if (input != null) {
          java.util.Properties prop = new java.util.Properties();
          prop.load(input);
          firebaseApiKey = prop.getProperty("firebase.api.key", "");
          firebaseAuthDomain = prop.getProperty("firebase.auth.domain", "");
          firebaseProjectId = prop.getProperty("firebase.project.id", "");
          firebaseAppId = prop.getProperty("firebase.app.id", "");
      }
  } catch (Exception e) {
      System.err.println("Could not load firebase properties: " + e.getMessage());
  }
%>

<div class="auth-wrap">
  <!-- LEFT PHOTO PANEL -->
  <div class="auth-left">
    <img src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=900&h=1000&fit=crop" alt="City at night">
    <div class="auth-left-overlay">
      <a href="index.jsp" class="nav-logo" style="margin-bottom:auto;padding-top:8px">
        <div class="nav-logo-mark">C</div>
        <span class="nav-logo-name" style="color:white">CityHub</span>
      </a>
      <div class="auth-left-quote">
        <p>"CityHub helped me find the best commute route, a late-night doctor, and hidden street food gems in my first week after moving to Mumbai. Absolute lifesaver."</p>
        <div class="auth-quote-author">
          <img src="https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=80&h=80&fit=crop&crop=face" alt="Vikram Nair">
          <div>
            <span>Vikram Nair</span>
            <small>Software Engineer, Mumbai</small>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT FORM PANEL -->
  <div class="auth-right">
    <div class="auth-header">
      <h1>Welcome back</h1>
      <p>New to CityHub? <a href="register.jsp">Create a free account</a></p>
    </div>

    <div class="divider" style="margin-bottom:20px">sign in with your email</div>

    <% if (loginError != null) { %>
      <div class="form-alert error" style="display:block; margin-bottom:15px; padding:12px; border-radius:8px; background:#fef2f2; color:#dc2626; border:1px solid #fecaca; font-size:13px;">
        <%= loginError %>
      </div>
    <% } %>
    
    <% if (regSuccess != null) { %>
      <div class="form-alert success" style="display:block; margin-bottom:15px; padding:12px; border-radius:8px; background:#f0fdf4; color:#16a34a; border:1px solid #bbf7d0; font-size:13px;">
        <%= regSuccess %>
      </div>
    <% } %>

    <form id="loginForm" action="CityLoginServlet" method="post">
      <div class="form-group">
        <label class="form-label" for="email">Email address</label>
        <div class="form-input-wrap">
          <span class="form-input-icon">&#9993;</span>
          <input type="email" id="email" name="mail" class="form-input" placeholder="yourname@gmail.com" required autocomplete="email">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <div class="form-input-wrap">
          <span class="form-input-icon">&#128274;</span>
          <input type="password" id="password" name="passcode" class="form-input" placeholder="Enter your password" required autocomplete="current-password">
        </div>
      </div>
      <button type="submit" class="btn btn-primary btn-full btn-lg" style="margin-top: 15px;">Sign in to CityHub</button>
    </form>

    <div class="divider" style="margin: 20px 0;">or</div>

    <button type="button" class="social-btn" onclick="signInWithGoogle()" style="width: 100%; display: flex; align-items: center; justify-content: center; gap: 10px; border: 1px solid var(--border); background: white; padding: 12px; border-radius: var(--radius); cursor: pointer; font-weight: 500; font-family: 'Inter', sans-serif;">
      <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg" alt="Google" style="width: 18px; height: 18px;">
      <span>Continue with Google</span>
    </button>

    <p style="font-size:12px;color:var(--text-muted);text-align:center;margin-top:20px">
      By signing in you agree to our <a href="#" class="form-link">Terms of Service</a> and <a href="#" class="form-link">Privacy Policy</a>.
    </p>
  </div>
</div>

<!-- GOOGLE PROFILE DETAILS MODAL -->
<div class="modal-overlay" id="googleDetailsModal">
  <div class="modal-box" style="width: 420px; padding: 30px; border-radius: 8px; text-align: left;">
    <button class="modal-close" onclick="closeGoogleDetailsModal()">&times;</button>
    <div style="text-align:center; margin-bottom: 20px;">
      <img id="googleUserPic" src="" style="width: 64px; height: 64px; border-radius: 50%; border: 2px solid var(--accent); object-fit: cover; margin:0 auto; display:block;">
      <h3 style="font-size: 18px; font-weight: 700; margin-top: 10px;" id="googleUserWelcome">Complete Profile</h3>
      <p style="font-size: 13px; color: var(--text-muted);" id="googleDetailsSubtitle">Tell us your city to finish registration</p>
    </div>
    
    <form id="googleDetailsForm" onsubmit="submitGoogleDetails(event)" style="padding:0; margin:0;">
      <input type="hidden" id="googleDetailsEmail" name="mail">
      <input type="hidden" id="googleDetailsPic" name="profile_pic">
      
      <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 12px;">
        <div class="form-group">
          <label class="form-label" style="font-size:12px;">First name</label>
          <input type="text" id="googleFirstname" name="firstname" class="form-input" style="padding:10px;" readonly disabled>
        </div>
        <div class="form-group">
          <label class="form-label" style="font-size:12px;">Last name</label>
          <input type="text" id="googleLastname" name="lastname" class="form-input" style="padding:10px;" readonly disabled>
        </div>
      </div>

      <div class="form-group" style="margin-bottom: 20px;">
        <label class="form-label" style="font-size:12px;">City</label>
        <input type="text" id="googleCity" name="city" class="form-input" placeholder="e.g. Mumbai" style="padding:10px;" required>
      </div>

      <div style="display: flex; gap: 10px; margin-top: 24px;">
        <button type="submit" class="btn btn-primary btn-full">Complete Registration</button>
        <button type="button" class="btn btn-outline" onclick="closeGoogleDetailsModal()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<!-- Firebase SDK Compatibility Libraries -->
<script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-auth-compat.js"></script>

<script src="app.js"></script>
<script>
// Initialize Firebase using server-loaded credentials
const firebaseConfig = {
  apiKey: "<%= firebaseApiKey %>",
  authDomain: "<%= firebaseAuthDomain %>",
  projectId: "<%= firebaseProjectId %>",
  appId: "<%= firebaseAppId %>"
};
firebase.initializeApp(firebaseConfig);

function signInWithGoogle() {
  const provider = new firebase.auth.GoogleAuthProvider();
  firebase.auth().signInWithPopup(provider)
  .then((result) => {
    return result.user.getIdToken();
  })
  .then((idToken) => {
    postToken(idToken, 'check');
  })
  .catch((error) => {
    console.error("Firebase Auth Sign-In Error: ", error);
    showToast(error.message, "error");
  });
}

function postToken(idToken, action, city = "") {
  let bodyStr = "idToken=" + encodeURIComponent(idToken) + "&action=" + action;
  if (city) {
    bodyStr += "&city=" + encodeURIComponent(city);
  }

  fetch('GoogleLoginServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: bodyStr
  })
  .then(res => res.json())
  .then(data => {
    if (data.status === 'success') {
      window.location.href = data.redirect;
    } else if (data.status === 'new_user') {
      // User doesn't exist, open Modal to complete City
      document.getElementById('googleDetailsEmail').value = data.email;
      document.getElementById('googleDetailsPic').value = data.profile_pic;
      document.getElementById('googleFirstname').value = data.name ? data.name.split(' ')[0] : "";
      document.getElementById('googleLastname').value = data.name && data.name.split(' ').length > 1 ? data.name.split(' ').slice(1).join(' ') : "";
      document.getElementById('googleUserPic').src = data.profile_pic || "https://ui-avatars.com/api/?name=" + encodeURIComponent(data.name || "User");
      document.getElementById('googleUserWelcome').textContent = "Welcome, " + (data.name ? data.name.split(' ')[0] : "explorer") + "!";
      document.getElementById('googleDetailsSubtitle').textContent = "To complete your registration, please enter your City.";
      
      // Save ID Token on the form to send during submit
      document.getElementById('googleDetailsForm').dataset.idToken = idToken;
      
      document.getElementById('googleDetailsModal').classList.add('open');
    } else {
      showToast(data.message || 'Authentication error', 'error');
    }
  })
  .catch(err => {
    console.error(err);
    showToast('Failed to connect to authentication server.', 'error');
  });
}

function submitGoogleDetails(event) {
  event.preventDefault();
  const idToken = document.getElementById('googleDetailsForm').dataset.idToken;
  const city = document.getElementById('googleCity').value;
  postToken(idToken, 'register', city);
}

function closeGoogleDetailsModal() {
  document.getElementById('googleDetailsModal').classList.remove('open');
}
</script>

</body>
</html>
