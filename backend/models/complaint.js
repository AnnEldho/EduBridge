const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var complaintSchema = new mongoose.Schema({
	user_id: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'User',
		required: true,
	},
	complaint_title: {
		type: String,
		required: true,
	},
	complaint_description: {
		type: String,
		required: true,
	},
	complaint_status: {
		type: String,
		default: "Pending"
	},
	complaint_date: {
		type: Date,
		default: Date.now,
	},
});
module.exports = mongoose.model('Complaint', complaintSchema);