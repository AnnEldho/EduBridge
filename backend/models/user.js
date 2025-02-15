const mongoose= require('mongoose');
var userSchema= new mongoose.Schema({
	name: {
        type: String,
    },
	email:{
		type: String,
		required:true,
		unique:true,
	},

	phone_number:{
		type:Number,
		required:true,
	},
	place:{
		type:String,
		
	},
	taluk:{
		type:String,
		required:true
	},
	district:{
		type:String,
		required:true
	},
	state:{
		type:String,
		required:true
	},
	pincode:{
		type:Number,
		required:true
	},
	password:{
		type:String,
		required:true
	},
	usertype:{
		type:String,
		
	}
})
module.exports= mongoose.model('User',userSchema);