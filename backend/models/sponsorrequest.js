const mongoose = require('mongoose');
var sponsorRequest = new mongoose.Schema({
    description: {
        type: String,
        required: true,
        
    },
    amount: {
        type: Number,
        required: true
    },
    ngoid: {
        type: String,
       required: true,
       ref: 'User'
    },
    sponsorid: {
       type: String,
       required: true,
       ref: 'User'
    },
    status: {
        type: String,
        default: "requested"
    },
    datetime: {
        type: Date,
        default: Date.now
    }

    })
module.exports = mongoose.model('SponsorRequest', sponsorRequest);