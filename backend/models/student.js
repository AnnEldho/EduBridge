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
        type: Date,
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
    },
    instituition: {
        type: String,
        required: true,
    },
    course: {
        type: String,
        required: true,
    },
    year_of_enrollment: {
        type: Number,
        required: true,
    },
    academic_year: {
        type: String,
        required: true,
    },
    percentage: {
        type: Number,
        required: true,
    },
    
	account_number: {
		type: String,
		required: true,
	},
	account_type: {
		type: String,
		required: true,
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
	},
    status: {
        type: String,
        
    }
});

module.exports = mongoose.model('Student', studentSchema);