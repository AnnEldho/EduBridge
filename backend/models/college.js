const mongoose= require('mongoose');
const Schema = mongoose.Schema;

var collegeSchema= new mongoose.Schema({
	user_id:{
		type:mongoose.Schema.Types.ObjectId,
		ref:'User',
		required:true,
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
	status:{
		type:String,
	},
})
module.exports= mongoose.model('College',collegeSchema);