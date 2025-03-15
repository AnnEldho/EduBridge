const mongoose = require ('mongoose');
const Schema = mongoose.Schema;
var notificationSchema = new mongoose.Schema({
	title: {
		type: String,
		required: true,
	},
	description: {
		type: String,
		required: true,
	},
	datetime: {
		type: Date,
		default: Date.now
	},
	user_id: {
		type: Schema.Types.ObjectId,
		ref: 'User',
		required: true,
	},
});
module.exports = mongoose.model('Notification', notificationSchema);
    
