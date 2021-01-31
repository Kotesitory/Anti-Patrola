const mongoose = require('mongoose')
const timestamp = require('mongoose-timestamp');

const PatrolScheme = new mongoose.Schema({
    userId: {
        type: String,
        required: true
    },
    lat: {
        type: Number,
        required: true
    },
    lon: {
        type: Number,
        required: true
    },
    confidence: {
        type: Number,
        required: true,
        default: 0.5
    },
    userConfirmations: [
        {
            userId: {
                type: String,
                required: true
            },
            confirmation: {
                type: Boolean,
                required: true
            }
        }
    ]
});
PatrolScheme.plugin(timestamp);

module.exports = mongoose.model('PatrolLocation', PatrolScheme);