// firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// Replace with your actual Firebase config!
firebase.initializeApp({
  apiKey: "AIzaSyC-kEJsC8SEUa7nyNesv6ff7OBL2c5waJU",
    authDomain: "dogslife-nz.firebaseapp.com",
    projectId: "dogslife-nz",
    storageBucket: "dogslife-nz.firebasestorage.app",
    messagingSenderId: "107604309101",
    appId: "1:107604309101:web:f145f9d9e15abf869bbb64"
});

const messaging = firebase.messaging();
