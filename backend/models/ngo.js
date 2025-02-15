const mongoose = require('mongoose');
const Schema = mongoose.Schema;

var ngoSchema = new mongoose.Schema({
	user_id: {
		type: Schema.Types.ObjectId,
		ref: 'User',
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
	incharge_name:{
		type:String,
		required:true,
	},
	incharge_email:{
		type:String,
		required:true,
	},
	incharge_phone:{
		type:String,
		required:true,
	},
	status: {
		type: String,
		
	}
});
module.exports = mongoose.model('Ngo', ngoSchema);