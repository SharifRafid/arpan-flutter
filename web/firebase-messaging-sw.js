importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp(
{
  apiKey: "AIzaSyDctRyIIPNgGE8IDxgZolyki_9wGrBm-J0",
  authDomain: "arpon-app.firebaseapp.com",
  databaseURL: "https://arpon-app-default-rtdb.firebaseio.com",
  projectId: "arpon-app",
  storageBucket: "arpon-app.appspot.com",
  messagingSenderId: "943541700401",
  appId: "1:943541700401:web:50f2ac3696ea2bbfd25210",
  measurementId: "G-EB40LH3JG1"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});