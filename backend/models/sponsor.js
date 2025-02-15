const mongoose=require('mongoose');
const Schema=mongoose.Schema;

var sponsorSchema=new mongoose.Schema({
	user_id: {
		type: Schema.Types.ObjectId,
		ref: 'User',
		required: true,
	},
	
	status: {
		type:String,
		
	}
});
module.exports=mongoose.model('Sponsor',sponsorSchema);