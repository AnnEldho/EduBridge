const mongoose=require('mongoose');

var scholarshipSchema= new mongoose.Schema({
	scholarship_name:{
		type:String,
		required:true,
	},
	description:{	
		type:String,
		required:true,
	},
	user_id:{
		type:mongoose.Schema.Types.ObjectId,
		ref:'User',
		required:true,
	},
	eligibility:{
		type:String,
		required:true,
	},
	amount:{
		type:Number,
		required:true,
	},
	opening_date:{
		type: Date,
        default: Date.now,
	},
	due_date:{
		type:Date,
		required:true,
	}
});
module.exports= mongoose.model('Scholarship',scholarshipSchema);