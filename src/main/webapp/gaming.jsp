<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.city.pojo.CityUsers" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gaming Zone — CityHub</title>
  <link rel="stylesheet" href="styles.css">
  <style>
    /* Premium Gaming Zone styles */
    .gaming-menu-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 24px;
      margin-top: 30px;
    }
    .game-select-card {
      padding: 32px;
      text-align: center;
      cursor: pointer;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: space-between;
      height: 100%;
    }
    .game-large-icon {
      font-size: 64px;
      margin-bottom: 16px;
    }
    .game-card-title {
      font-size: 20px;
      font-weight: 700;
      margin-bottom: 8px;
      color: var(--text);
    }
    .game-card-desc {
      font-size: 14px;
      color: var(--text-secondary);
      margin-bottom: 20px;
      line-height: 1.6;
    }
    
    /* Shared Game Container Styles */
    .game-container {
      max-width: 650px;
      margin: 20px auto 80px;
      padding: 36px;
      background: white;
      border: 1px solid var(--border);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow);
      display: none;
    }
    
    .game-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid var(--border);
      padding-bottom: 16px;
      margin-bottom: 24px;
    }
    
    .back-btn-wrap {
      margin-bottom: 20px;
    }

    /* Quiz Styling */
    .quiz-box {
      background: var(--bg-subtle);
      border-radius: var(--radius);
      padding: 24px;
      min-height: 200px;
      margin-top: 16px;
      border: 1px solid var(--border);
    }
    .quiz-q-text {
      font-size: 17px;
      font-weight: 600;
      line-height: 1.5;
      margin-bottom: 20px;
    }
    .quiz-options-list {
      display: grid;
      grid-template-columns: 1fr;
      gap: 10px;
    }
    .opt-btn {
      width: 100%;
      padding: 12px 16px;
      background: white;
      border: 1px solid var(--border);
      border-radius: var(--radius);
      font-size: 14px;
      font-weight: 500;
      cursor: pointer;
      text-align: left;
      transition: all 0.15s;
    }
    .opt-btn:hover {
      border-color: var(--accent);
      background: var(--accent-light);
      color: var(--accent);
    }
    .opt-btn.correct {
      background: #dcfce7;
      border-color: #16a34a;
      color: #15803d;
    }
    .opt-btn.incorrect {
      background: #fee2e2;
      border-color: #dc2626;
      color: #b91c1c;
    }

    /* Pokemon Silhouette Game Styling */
    .poke-img-box {
      background: var(--bg-subtle);
      border-radius: var(--radius);
      padding: 30px;
      text-align: center;
      margin-bottom: 24px;
      border: 1px solid var(--border);
      height: 220px;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
    }
    .poke-sprite {
      height: 160px;
      object-fit: contain;
      transition: filter 0.4s ease;
    }
    /* Hidden state (Silhouette shadow) */
    .poke-sprite.silhouette {
      filter: brightness(0);
    }
    
    .status-msg {
      font-size: 16px;
      font-weight: 600;
      margin-top: 14px;
      text-align: center;
      min-height: 24px;
    }

    .loader {
      font-size: 16px;
      font-weight: 500;
      color: var(--text-secondary);
      text-align: center;
      padding: 40px 0;
    }
  </style>
</head>
<body>

<%
  String userEmail = (session != null) ? (String) session.getAttribute("email") : null;
  CityUsers user = (CityUsers) request.getAttribute("user");
  Integer hubPoints = (Integer) request.getAttribute("hubPoints");
  
  if (userEmail == null || user == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
  }
  
  int pts = hubPoints != null ? hubPoints : 0;
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
    <li><a href="<%=request.getContextPath() %>/GamingServlet" class="active">Gaming Zone</a></li>
    <li><a href="<%=request.getContextPath() %>/FriendServlet">Friends</a></li>
    <li><a href="<%=request.getContextPath() %>/ProfileServlet">Profile</a></li>
  </ul>
  <div class="nav-right">
    <a href="askquestion.jsp" class="btn btn-ghost">+ Post Question</a>
    <a href="<%=request.getContextPath() %>/CityLogoutServlet" class="btn btn-primary">Sign out</a>
  </div>
</nav>

<!-- MAIN WRAPPER -->
<div class="section" style="max-width:900px; margin:0 auto; padding:40px 24px">

  <!-- 1. GAME SELECTION MENU -->
  <div id="gameMenu" style="display:block">
    <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--border); padding-bottom:20px; margin-bottom:30px">
      <div>
        <h1 style="font-family:'Playfair Display',Georgia,serif; font-size:32px; font-weight:700">🎮 CityHub Gaming Zone</h1>
        <p style="color:var(--text-secondary); font-size:14px; margin-top:4px">Play games to earn Hub Points directly added to your profile!</p>
      </div>
      <div style="text-align:right; background:var(--accent-light); padding:10px 18px; border-radius:var(--radius); border:1px solid var(--border)">
        <div style="font-size:12px; font-weight:600; color:var(--accent); text-transform:uppercase; letter-spacing:0.5px">Total Hub Points</div>
        <div style="font-size:28px; font-weight:700; color:var(--text)" id="profileHubPoints"><%= pts %></div>
      </div>
    </div>
    
    <div class="gaming-menu-grid">
      <!-- Game Card 1: Quiz -->
      <div class="card game-select-card" onclick="startQuizGame()" style="cursor: pointer;">
        <div>
          <div class="game-large-icon">📝</div>
          <div class="game-card-title">General Trivia Quiz</div>
          <p class="game-card-desc">Answer 5 multiple-choice questions correctly. Earn 1 Hub Point for every correct answer!</p>
        </div>
        <button type="button" class="btn btn-primary btn-full" onclick="startQuizGame(); event.stopPropagation();">Start Quiz Game</button>
      </div>
      
      <!-- Game Card 2: Pokemon -->
      <div class="card game-select-card" onclick="startPokeGame()" style="cursor: pointer;">
        <div>
          <div class="game-large-icon">🐙</div>
          <div class="game-card-title">Guess the Pokémon</div>
          <p class="game-card-desc">Guess the Pokémon name from its silhouette. Correct guess awards +2 Hub Points!</p>
        </div>
        <button type="button" class="btn btn-primary btn-full" onclick="startPokeGame(); event.stopPropagation();">Start Guessing Game</button>
      </div>
    </div>
  </div>

  <!-- 2. GAME CONTAINER: QUIZ GAME -->
  <div id="quizContainer" class="game-container">
    <div class="back-btn-wrap">
      <button class="btn btn-outline btn-sm" onclick="showMenu()">&#8592; Back to Game Menu</button>
    </div>
    
    <div class="game-header">
      <div>
        <h2 style="font-size:20px; font-weight:700">📝 General Trivia Quiz</h2>
        <span style="font-size:12px; color:var(--text-muted)" id="quizProgress">Question 1 of 5</span>
      </div>
      <div style="font-size:15px; font-weight:600; color:var(--accent)" id="quizScoreDisplay">Score: 0 / 5</div>
    </div>

    <!-- Play Area -->
    <div id="quizPlayArea">
      <div class="quiz-box">
        <div class="quiz-q-text" id="quizQuestionText">Loading...</div>
        <div class="quiz-options-list" id="quizOptionsGrid"></div>
      </div>
    </div>

    <!-- Results Area -->
    <div id="quizResultArea" style="display:none; text-align:center; padding:20px 0">
      <div style="font-size:52px; margin-bottom:12px">🏆</div>
      <h3 style="font-size:22px; font-weight:700; margin-bottom:8px">Quiz Completed!</h3>
      <p style="color:var(--text-secondary); font-size:14px; margin-bottom:20px" id="quizResultDesc"></p>
      <button class="btn btn-primary" onclick="startQuizGame()">Play Again</button>
    </div>
  </div>

  <!-- 3. GAME CONTAINER: POKEMON GAME -->
  <div id="pokeContainer" class="game-container">
    <div class="back-btn-wrap">
      <button class="btn btn-outline btn-sm" onclick="showMenu()">&#8592; Back to Game Menu</button>
    </div>

    <div class="game-header">
      <div>
        <h2 style="font-size:20px; font-weight:700">🐙 Guess the Pokémon</h2>
        <span style="font-size:12px; color:var(--text-muted)">Who's that Pokémon?</span>
      </div>
    </div>

    <!-- Loader -->
    <div id="pokeLoader" class="loader">Fetching Pokémon from PokéAPI...</div>

    <!-- Play Area -->
    <div id="pokePlayArea" style="display:none">
      <div class="poke-img-box">
        <img id="pokeImage" class="poke-sprite silhouette" src="" alt="Pokemon Silhouette">
      </div>
      
      <div class="quiz-options-list" id="pokeOptionsGrid"></div>
      <div class="status-msg" id="pokeStatusMessage"></div>
      
      <div id="pokeActionArea" style="text-align:center; margin-top:20px; display:none">
        <button class="btn btn-primary" onclick="startPokeGame()">Guess Another Pokémon</button>
      </div>
    </div>
  </div>

</div>

<script src="app.js"></script>
<script>
// --- SHARED UTILITIES ---
function showMenu() {
  document.getElementById('gameMenu').style.display = 'block';
  document.getElementById('quizContainer').style.display = 'none';
  document.getElementById('pokeContainer').style.display = 'none';
}

function decodeHtml(html) {
  const txt = document.createElement("textarea");
  txt.innerHTML = html;
  return txt.value;
}

function shuffleArray(array) {
  return array.sort(() => Math.random() - 0.5);
}

// Safe toast notification helper
function safeShowToast(msg, type) {
  if (typeof showToast === 'function') {
    showToast(msg, type);
  } else {
    alert(msg);
  }
}

// Send score to SaveGameScoreServlet
function saveGameScore(gameName, score, pointsEarned) {
  fetch('SaveGameScoreServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'gameName=' + encodeURIComponent(gameName) + '&score=' + score + '&pointsEarned=' + pointsEarned
  })
  .then(res => res.json())
  .then(data => {
    if (data.status === 'success') {
      safeShowToast(data.message, 'success');
      // Update score display on UI
      document.getElementById('profileHubPoints').textContent = data.newPoints;
    } else {
      safeShowToast(data.message, 'error');
    }
  })
  .catch(err => {
    console.error(err);
    safeShowToast('Failed to save score on server.', 'error');
  });
}

// --- GAME 1: QUIZ GAME LOGIC ---
let quizQuestions = [];
let quizCurrentIndex = 0;
let quizScore = 0;

function startQuizGame() {
  document.getElementById('gameMenu').style.display = 'none';
  document.getElementById('quizContainer').style.display = 'block';
  document.getElementById('quizPlayArea').style.display = 'block';
  document.getElementById('quizResultArea').style.display = 'none';
  
  document.getElementById('quizQuestionText').textContent = "Fetching questions from Open Trivia DB...";
  document.getElementById('quizOptionsGrid').innerHTML = '';
  document.getElementById('quizProgress').textContent = "Loading...";
  document.getElementById('quizScoreDisplay').textContent = "Score: 0 / 5";
  
  quizQuestions = [];
  quizCurrentIndex = 0;
  quizScore = 0;
  
  // Fetch 5 questions from Open Trivia DB API
  fetch('https://opentdb.com/api.php?amount=5&type=multiple')
    .then(res => res.json())
    .then(data => {
      if (data.results && data.results.length > 0) {
        quizQuestions = data.results;
        loadQuizQuestion();
      } else {
        document.getElementById('quizQuestionText').textContent = "Error loading questions. Please try again.";
      }
    })
    .catch(err => {
      console.error(err);
      document.getElementById('quizQuestionText').textContent = "Network error loading questions.";
    });
}

function loadQuizQuestion() {
  if (quizCurrentIndex >= 5) {
    endQuizGame();
    return;
  }
  
  const qData = quizQuestions[quizCurrentIndex];
  document.getElementById('quizProgress').textContent = `Question ${quizCurrentIndex + 1} of 5`;
  document.getElementById('quizQuestionText').textContent = decodeHtml(qData.question);
  
  // Combine correct and incorrect options
  let options = [];
  options.push({ text: decodeHtml(qData.correct_answer), correct: true });
  qData.incorrect_answers.forEach(opt => {
    options.push({ text: decodeHtml(opt), correct: false });
  });
  
  // Shuffle options
  shuffleArray(options);
  
  const grid = document.getElementById('quizOptionsGrid');
  grid.innerHTML = '';
  
  options.forEach(opt => {
    const btn = document.createElement('button');
    btn.className = 'opt-btn';
    btn.textContent = opt.text;
    btn.onclick = () => selectQuizOption(btn, opt.correct);
    grid.appendChild(btn);
  });
}

function selectQuizOption(selectedBtn, isCorrect) {
  const grid = document.getElementById('quizOptionsGrid');
  const buttons = grid.querySelectorAll('button');
  
  // Disable all option buttons
  buttons.forEach(btn => btn.disabled = true);
  
  if (isCorrect) {
    selectedBtn.classList.add('correct');
    quizScore++;
    document.getElementById('quizScoreDisplay').textContent = `Score: ${quizScore} / 5`;
  } else {
    selectedBtn.classList.add('incorrect');
    // Highlight correct button
    buttons.forEach(btn => {
      // Find correct answer index
      const qData = quizQuestions[quizCurrentIndex];
      if (btn.textContent === decodeHtml(qData.correct_answer)) {
        btn.classList.add('correct');
      }
    });
  }
  
  // Wait 1.5 seconds and load next question
  setTimeout(() => {
    quizCurrentIndex++;
    loadQuizQuestion();
  }, 1500);
}

function endQuizGame() {
  document.getElementById('quizPlayArea').style.display = 'none';
  document.getElementById('quizResultArea').style.display = 'block';
  
  const desc = document.getElementById('quizResultDesc');
  desc.textContent = `You answered ${quizScore} out of 5 questions correctly and earned +${quizScore} Hub Points!`;
  
  // Submit score to database (1 point per correct answer)
  saveGameScore("Trivia Quiz", quizScore, quizScore);
}

// --- GAME 2: POKEMON GAME LOGIC ---
function startPokeGame() {
  document.getElementById('gameMenu').style.display = 'none';
  document.getElementById('pokeContainer').style.display = 'block';
  
  document.getElementById('pokeLoader').style.display = 'block';
  document.getElementById('pokePlayArea').style.display = 'none';
  document.getElementById('pokeActionArea').style.display = 'none';
  document.getElementById('pokeStatusMessage').textContent = '';
  document.getElementById('pokeStatusMessage').style.color = '';
  
  // Generate 4 unique random Pokémon IDs between 1 and 151
  let ids = [];
  while (ids.length < 4) {
    let rId = Math.floor(Math.random() * 151) + 1;
    if (!ids.includes(rId)) {
      ids.push(rId);
    }
  }
  
  // Fetch Pokémon details for all 4 in parallel
  Promise.all(ids.map(id => fetch('https://pokeapi.co/api/v2/pokemon/' + id).then(res => res.json())))
    .then(pokemons => {
      // Pick the first fetched Pokémon as correct target
      const targetPokemon = pokemons[0];
      const correctName = targetPokemon.name;
      
      // Load target image
      const spriteUrl = targetPokemon.sprites.other['official-artwork'].front_default || targetPokemon.sprites.front_default;
      const img = document.getElementById('pokeImage');
      img.src = spriteUrl;
      img.className = 'poke-sprite silhouette'; // Keep silhouette hidden
      
      // Map names for the options
      let options = pokemons.map(p => ({
        name: p.name.charAt(0).toUpperCase() + p.name.slice(1),
        correct: p.name === correctName
      }));
      
      // Shuffle option names
      shuffleArray(options);
      
      const grid = document.getElementById('pokeOptionsGrid');
      grid.innerHTML = '';
      
      options.forEach(opt => {
        const btn = document.createElement('button');
        btn.className = 'opt-btn';
        btn.textContent = opt.name;
        btn.onclick = () => selectPokeOption(btn, opt.correct, correctName);
        grid.appendChild(btn);
      });
      
      document.getElementById('pokeLoader').style.display = 'none';
      document.getElementById('pokePlayArea').style.display = 'block';
    })
    .catch(err => {
      console.error(err);
      document.getElementById('pokeLoader').textContent = "Failed to load Pokémon from PokéAPI. Try again.";
    });
}

function selectPokeOption(selectedBtn, isCorrect, correctName) {
  const grid = document.getElementById('pokeOptionsGrid');
  const buttons = grid.querySelectorAll('button');
  
  // Disable all buttons
  buttons.forEach(btn => btn.disabled = true);
  
  // Reveal Pokémon image silhouette
  const img = document.getElementById('pokeImage');
  img.className = 'poke-sprite'; // Removes silhouette
  
  const statusMsg = document.getElementById('pokeStatusMessage');
  const displayName = correctName.charAt(0).toUpperCase() + correctName.slice(1);
  
  let pointsEarned = 0;
  let gameScore = 0;
  
  if (isCorrect) {
    selectedBtn.classList.add('correct');
    statusMsg.textContent = `Correct! It's ${displayName}!`;
    statusMsg.style.color = '#16a34a';
    pointsEarned = 2;
    gameScore = 1;
  } else {
    selectedBtn.classList.add('incorrect');
    statusMsg.textContent = `Incorrect! It's ${displayName}!`;
    statusMsg.style.color = '#dc2626';
    
    // Highlight correct option
    buttons.forEach(btn => {
      if (btn.textContent.toLowerCase() === correctName.toLowerCase()) {
        btn.classList.add('correct');
      }
    });
    pointsEarned = 0;
    gameScore = 0;
  }
  
  // Show play again button
  document.getElementById('pokeActionArea').style.display = 'block';
  
  // Save score to database (2 points if correct)
  saveGameScore("Guess the Pokemon", gameScore, pointsEarned);
}

document.addEventListener('DOMContentLoaded', function() {
  try {
    if (typeof initFadeUp === 'function') {
      initFadeUp();
    }
  } catch (e) {
    console.error(e);
  }
  showMenu();
});
</script>
</body>
</html>
