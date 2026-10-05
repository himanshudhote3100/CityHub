<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Account — CityHub</title>
  <link rel="stylesheet" href="styles.css">
</head>
<body>

<%
  String regError = (String) request.getAttribute("regError");

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
    <img src="https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=900&h=1000&fit=crop" alt="City">
    <div class="auth-left-overlay">
      <a href="index.jsp" class="nav-logo" style="margin-bottom:32px;padding-top:8px">
        <div class="nav-logo-mark">C</div>
        <span class="nav-logo-name" style="color:white">CityHub</span>
      </a>
      <h2 style="font-family:'Playfair Display',Georgia,serif;font-size:26px;font-weight:700;color:white;margin-bottom:24px;line-height:1.3">Join thousands of city explorers</h2>
      <ul class="auth-benefits">
        <li>
          <span class="benefit-icon">&#128172;</span>
          <div><strong style="display:block;margin-bottom:3px">Ask anything about your city</strong>Get answers from locals within hours, not days.</div>
        </li>
        <li>
          <span class="benefit-icon">&#11088;</span>
          <div><strong style="display:block;margin-bottom:3px">Earn Hub Points &amp; Badges</strong>Build your reputation as a top local contributor.</div>
        </li>
        <li>
          <span class="benefit-icon">&#128101;</span>
          <div><strong style="display:block;margin-bottom:3px">Connect with neighbours</strong>Follow friends and see what's happening in your area.</div>
        </li>
        <li>
          <span class="benefit-icon">&#128205;</span>
          <div><strong style="display:block;margin-bottom:3px">320+ cities covered</strong>Whether in Mumbai, Pune, Delhi or Bangalore — we've got you covered.</div>
        </li>
      </ul>
    </div>
  </div>

  <!-- RIGHT FORM PANEL -->
  <div class="auth-right">
    <div class="auth-header">
      <h1>Create your account</h1>
      <p>Already have an account? <a href="login.jsp">Sign in</a></p>
    </div>

    <div class="divider" style="margin-bottom:20px">register with your email</div>

    <div id="regAlert" class="form-alert" style="display:none; margin-bottom:15px; padding:12px; border-radius:8px; font-size:13px;"></div>

    <% if (regError != null) { %>
      <div class="form-alert error" style="display:block; margin-bottom:15px; padding:12px; border-radius:8px; background:#fef2f2; color:#dc2626; border:1px solid #fecaca; font-size:13px;">
        <%= regError %>
      </div>
    <% } %>

    <form id="regForm" action="CityRegisterServlet" method="post" onsubmit="return handleRegister(event)">
      <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
        <div class="form-group">
          <label class="form-label" for="firstName">First name</label>
          <input type="text" id="firstName" name="firstname" class="form-input" placeholder="Riya" required autocomplete="given-name">
        </div>
        <div class="form-group">
          <label class="form-label" for="lastName">Last name</label>
          <input type="text" id="lastName" name="lastname" class="form-input" placeholder="Patel" required autocomplete="family-name">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label" for="regEmail">Gmail address</label>
        <div class="form-input-wrap">
          <span class="form-input-icon">&#9993;</span>
          <input type="email" id="regEmail" name="mail" class="form-input" placeholder="yourname@gmail.com" required autocomplete="email">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label" for="regCity">City</label>
        <input type="text" id="regCity" name="city" class="form-input" placeholder="Mumbai" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="regPassword">Password</label>
        <div class="form-input-wrap">
          <span class="form-input-icon">&#128274;</span>
          <input type="password" id="regPassword" name="passcode" class="form-input" placeholder="At least 6 characters" required autocomplete="new-password">
        </div>
      </div>
      <div class="form-group">
        <label class="form-label" for="regConfirm">Confirm password</label>
        <div class="form-input-wrap">
          <span class="form-input-icon">&#128274;</span>
          <input type="password" id="regConfirm" class="form-input" placeholder="Repeat password" required autocomplete="new-password">
        </div>
      </div>
      <div class="form-group" style="margin-bottom:20px">
        <label class="form-check">
          <input type="checkbox" id="termsCheck" required>
          I agree to the <a href="#" class="form-link">Terms of Service</a> and <a href="#" class="form-link">Privacy Policy</a>
        </label>
      </div>
      <button type="submit" class="btn btn-primary btn-full btn-lg">Create my account</button>
    </form>

    <div class="divider" style="margin: 20px 0;">or</div>

    <button type="button" class="social-btn" onclick="signUpWithGoogle()" style="width: 100%; display: flex; align-items: center; justify-content: center; gap: 10px; border: 1px solid var(--border); background: white; padding: 12px; border-radius: var(--radius); cursor: pointer; font-weight: 500; font-family: 'Inter', sans-serif;">
      <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg" alt="Google" style="width: 18px; height: 18px;">
      <span>Continue with Google</span>
    </button>
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

function handleRegister(e) {
  var email = document.getElementById('regEmail').value.trim();
  var password = document.getElementById('regPassword').value;
  var confirm = document.getElementById('regConfirm').value;
  var alert = document.getElementById('regAlert');
  
  alert.style.display = 'none';

  if (!email.endsWith('@gmail.com') && !email.endsWith('@googlemail.com')) {
    alert.textContent = 'Only registered Google email accounts (@gmail.com) are allowed.';
    alert.className = 'form-alert error';
    alert.style.display = 'block';
    alert.style.background = '#fef2f2';
    alert.style.color = '#dc2626';
    alert.style.border = '1px solid #fecaca';
    return false;
  }
  if (password.length < 6) {
    alert.textContent = 'Password must be at least 6 characters long.';
    alert.className = 'form-alert error';
    alert.style.display = 'block';
    alert.style.background = '#fef2f2';
    alert.style.color = '#dc2626';
    alert.style.border = '1px solid #fecaca';
    return false;
  }
  if (password !== confirm) {
    alert.textContent = 'Passwords do not match. Please try again.';
    alert.className = 'form-alert error';
    alert.style.display = 'block';
    alert.style.background = '#fef2f2';
    alert.style.color = '#dc2626';
    alert.style.border = '1px solid #fecaca';
    return false;
  }

  return true;
}

function signUpWithGoogle() {
  const provider = new firebase.auth.GoogleAuthProvider();
  firebase.auth().signInWithPopup(provider)
  .then((result) => {
    return result.user.getIdToken();
  })
  .then((idToken) => {
    postToken(idToken, 'check');
  })
  .catch((error) => {
    console.error("Firebase Auth Sign-Up Error: ", error);
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
