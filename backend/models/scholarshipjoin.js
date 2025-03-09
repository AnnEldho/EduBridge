const mongoose = require('mongoose');

const scholorshipJoinSchema = new mongoose.Schema({
    userid: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    providerid: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    scholorshipid: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Scholarship',
        required: true
    },
    status: {
        type: String,
        default: "Joined"
    },
    datetime: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('ScholorShipJoin', scholorshipJoinSchema);