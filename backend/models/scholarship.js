const mongoose = require('mongoose');
var scholarshipSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        unique: true,
        minlength: 3,
        maxlength: 30
    },
    description: {
        type: String,
        required: true,
        
    },
    amount: {
        type: Number,
        required: true
    },
    userid: {
        type: String,
       required: true,
       ref: 'User'
    },
    opening_date: {
        type: Date,
        required: true
    },
    closing_date: {
        type: Date,
        required: true
    },
    status: {
        type: String,
        default: "active"
    },
    datetime: {
        type: Date,
        default: Date.now
    }

    })
module.exports = mongoose.model('Scholarship', scholarshipSchema);