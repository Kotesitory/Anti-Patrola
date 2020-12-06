const mongoose = require('mongoose')
const timestamps = require('mongoose-timestamp');

const UserSchema = new mongoose.Schema({
    googleId: {
        type: String,
        required: true
    },
    displayName: {
        type: String,
        required: true
    },
    lastSubmitedAt: {
        type: Date,
        required: false
    }
});
UserSchema.plugin(timestamps);

module.exports = mongoose.model('User', UserSchema);