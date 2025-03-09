const mongoose = require('mongoose');
const Schema = mongoose.Schema;

var studentSchema = new mongoose.Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    house_name: {
        type: String,
        required: true,
    },
    dob: {
        type: String,
        required: true,
    },
    gender: {
        type: String,
        required: true,
    },
    nationality: {
        type: String,
        required: true,
    },
    aadhar_number: {
        type: String,
        required: true,
        unique: true,
    },
    instituition: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    course: {
        type: String,
        required: true,
    },
    academic_year: {
        type: String,
        required: true,
    },    
	account_number: {
		type: String,
		required: true,
        unique: true,
	},
	bank_name: {
		type: String,
		required: true,
	},
	branch_name: {
		type: String,
		required: true,
	},
	ifsc_code: {
		type: String,
		required: true,
	}
});

module.exports = mongoose.model('Student', studentSchema);