const mongoose = require('mongoose');

const sponsorShipJoinSchema = new mongoose.Schema({
    userid: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    sponsorid: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    sponsorshipid: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'SponsorRequest',
        required: true
    },
    ngoid:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
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

module.exports = mongoose.model('SponsorshipJoin', sponsorShipJoinSchema);