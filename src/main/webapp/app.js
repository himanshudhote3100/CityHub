/* CityHub — app.js  (shared across all pages) */

/* ── AUTH STATE ── */
function getUser() {
  try { return JSON.parse(localStorage.getItem('cityhub_user') || 'null'); }
  catch(e) { return null; }
}

function setUser(user) {
  localStorage.setItem('cityhub_user', JSON.stringify(user));
}

function logout() {
  localStorage.removeItem('cityhub_user');
  window.location.href = 'index.jsp';
}

function requireAuth() {
  if (!getUser()) { window.location.href = 'login.jsp'; }
}

/* ── SHARED DATA ── */
var QUESTIONS = [];
var ANSWERS = {};
var USERS = [];
var MY_QUESTIONS = [];
var MY_ANSWERS = [];

/* ── RENDER QUESTION CARD ── */
function renderQuestionCard(q, linkPath) {
  var href = linkPath || ('QuestionDetailServlet?id=' + q.id);
  return '<a href="' + href + '" class="card q-card fade-up">' +
    '<div class="q-card-top">' +
      '<img src="' + q.avatar + '" class="q-avatar" alt="' + q.author + '" onclick="event.preventDefault(); event.stopPropagation(); window.location.href=\'ProfileServlet?mail=\' + encodeURIComponent(q.author);" style="cursor:pointer;" onerror="this.src=\'https://ui-avatars.com/api/?name=' + encodeURIComponent(q.author) + '&background=dbeafe&color=1d4ed8\'">' +
      '<span class="q-author" onclick="event.preventDefault(); event.stopPropagation(); window.location.href=\'ProfileServlet?mail=\' + encodeURIComponent(q.author);" style="cursor:pointer; text-decoration:underline; font-weight:600;">' + q.author + '</span>' +
      '<span class="q-time">' + q.time + '</span>' +
    '</div>' +
    (q.image && q.image.trim() !== "" ? '<img src="' + q.image + '" class="q-img" alt="' + q.title + '">' : '') +
    '<span class="q-badge ' + q.badge + '">' + q.label + '</span>' +
    '<div class="q-title">' + q.title + '</div>' +
    '<div class="q-excerpt">' + q.excerpt + '</div>' +
    '<div class="q-footer">' +
      '<span class="q-stat">&#128172; ' + q.answers + '</span>' +
      '<span class="q-stat">&#9825; ' + q.likes + '</span>' +
      '<span class="q-location">&#128205; ' + q.location + '</span>' +
    '</div>' +
  '</a>';
}

/* ── FADE UP ON SCROLL ── */
function initFadeUp() {
  var elements = document.querySelectorAll('.fade-up');
  if (!elements.length) return;
  var observer = new IntersectionObserver(function(entries) {
    entries.forEach(function(entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.05, rootMargin: '0px 0px -20px 0px' });
  elements.forEach(function(el) { observer.observe(el); });
}

/* ── STICKY NAV SHADOW ── */
function initNavScroll() {
  var nav = document.querySelector('nav');
  if (!nav) return;
  window.addEventListener('scroll', function() {
    nav.style.boxShadow = window.scrollY > 10 ? '0 1px 4px rgba(0,0,0,0.06)' : '';
  }, { passive: true });
}

/* ── TOAST ── */
function showToast(msg, type) {
  var toast = document.createElement('div');
  toast.textContent = msg;
  var bg = type === 'error' ? '#fef2f2' : '#f0fdf4';
  var color = type === 'error' ? '#dc2626' : '#16a34a';
  var border = type === 'error' ? '#fecaca' : '#bbf7d0';
  toast.style.cssText = 'position:fixed;bottom:24px;right:24px;z-index:9999;padding:12px 20px;border-radius:8px;font-size:14px;font-family:Inter,sans-serif;font-weight:500;box-shadow:0 4px 16px rgba(0,0,0,0.12);background:' + bg + ';color:' + color + ';border:1px solid ' + border + ';transition:opacity 0.3s;';
  document.body.appendChild(toast);
  setTimeout(function() {
    toast.style.opacity = '0';
    setTimeout(function() { toast.remove(); }, 300);
  }, 3000);
}

/* ── INIT ── */
document.addEventListener('DOMContentLoaded', function() {
  initFadeUp();
  initNavScroll();
});
