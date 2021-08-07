const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

const twilio = require('twilio');
const accoundSid = 'ACb37f57f1cc70d5d19249e621095a477c'
const authToken = '06aa40bc76a73c4286a18edc244811de'

const client = new twilio(accoundSid, authToken);

const twilioNumber = '+14157428578'
const twilioSid = 'MG4551d356d47dee5fab9feb7cb11ae8eb'
const numbers = ['+18509602169' , '+12142549989' , '+12542947773','+18172312097','+18509602169' , '+12142549989' , '+12542947773','+18172312097','+18509602169' , '+12142549989' , '+12542947773','+18172312097','+18509602169' , '+12142549989' , '+12542947773','+18172312097','+18509602169' , '+12142549989' , '+12542947773','+18172312097'];


exports.manuallyPublishArticle = functions.https.onCall(
    async (data, context) => {
    const author = data.author;  
    const translator = data.translator;
    const post = data.message;  
    const originalPublisherId = data.originalPublisherId;
    const phoneNumber = '+18509602169' 

    Promise.all(
        numbers.map(number => {
            return client.messages.create({
                to:number,
                from: twilioSid,
                body: `Congratulations you are the second 
                subscriber to Kings Echo \n\n\n
                ${author}\n
                ${post}`
            });
        })
    ).then(messages => {
        console.log('Messages all sent')
    }).catch(err => console.error(err));

    // client.messages
    // .create({
    //     body: `Congratulations you are the second 
    //             subscriber to Kings Echo \n\n\n
    //             ${author}\n
    //             ${post}`,
    //     from: twilioNumber,
    //     to: twilioSid
    // })
    // .then(message => console.log(message.sid)); 
 
  });

exports.autoPublishArticle = functions.database.ref('/Posts/MgNM5yFqEjQ1dgJs-wB/').onUpdate(event => {
    const postId = event.params.author

    return admin.database().ref(`/Posts/${postId}/`)
    .once('value')
    .then(snapshot => snapshot.val())
    .then(post => {
        const postMessage = post.post
        const phoneNumber = '+12142549989'

        // if (!validE164(phoneNumber)) {
        //     throw new Error('number not in e164 format!')
        // }

        const textMessae = {
            body: `congratulations you've been added to Radiance Okuzor's 
            Echo Chamber from now on you will be recieving updates from him via text
             messages. Here's the first one: \n ${postMessage}`,
            to: phoneNumber,
            from: twilioNumber

        }
        return client.messages .create(textMessae)
    })
    .then(message => console.log(message.sid, 'sucess'))
    .catch(err => console.log(err))
});

// const crypto  = require('crypto');



// const db = admin.firestore();