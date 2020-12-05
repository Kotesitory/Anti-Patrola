const {OAuth2Client} = require('google-auth-library');
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const User = require('../models/User');

async function verifyAndGetUser(token) {
    try{
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: process.env.GOOGLE_CLIENT_ID,
        });
        const payload = ticket.getPayload();
        const userid = payload['sub'];
        let user = await User.findOne({ googleId: userid });
        if(user){
            return user;
        }else {
            // DEV NOTE: Saving new user
            const newUser = {
                googleId: userid,
                displayName: name
            };

            user = User.create(newUser);
            return user;
        }
    } catch (e){
        console.error(e);
        return null;
    }
}

module.exports = verifyAndGetUser;