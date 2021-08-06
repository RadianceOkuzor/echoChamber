// import firebase from 'firebase';
import * as firebase from 'firebase/app';
import 'firebase/firestore' ;
import 'firebase/analytics'
import "firebase/auth";


// import 'firebase/firestore';
// const firebase = require("firebase/firebase");
// // Required for side-effects
// require("firebase/firestore");
// require("firebase/auth");



const firebaseConfig = {
  apiKey: "AIzaSyAZ_ZdGDdA-W2HU_TC4al0anJQmEm4Q1fI",
  authDomain: "kingsecho-f64eb.firebaseapp.com",
  databaseURL: "https://kingsecho-f64eb-default-rtdb.firebaseio.com",
  projectId: "kingsecho-f64eb",
  storageBucket: "kingsecho-f64eb.appspot.com",
  messagingSenderId: "445033485685",
  appId: "1:445033485685:web:9c722d46f16ad4c060ef3c",
  measurementId: "G-Y6G7603QMM"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();

// Initialize Firebase
export const app = firebase.initializeApp(firebaseConfig);
firebase.analytics()




export const firestore = app.firestore();
export const auth = app.auth();

export const provider = new firebase.auth.GoogleAuthProvider();
export const signInWithGoogle = () => auth.signInWithRedirect(provider);
export const signOut = () => auth.signOut();

// Signup form into Creating a User
export const createUserProfileDocument = async (user, additionalData) =>{
  if (!user) return;

  const userRef = firestore.doc(`users/${user.id}`)

  const snapshot = await userRef.get();

  if (!snapshot.exits){
    const {displayName, email, photoUrl} = user;
    const createdAt = new Date();
      try{
        await userRef.set({
displayName,
email,
photoUrl,
createdAt,
...additionalData,
        })
      } catch (error){
      console.error('Error Creating User', error.message)
      }
  }

  return getUserDocument(user.uid);
};

export const getUserDocument = (uid => {
  if (!uid) return null
  try{
    const userDocument =  firestore.collection('users').doc(uid).get();

    return {uid, ...userDocument.data()}
  } catch (error){
    console.error('Error Fetching User', error.message);
  }
})

export default app;



  // Be wary of and figure out why this doesn't work
//  const setting = {Timestamp: true}
//  firestore.settings(setting);


