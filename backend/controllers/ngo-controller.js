const Ngo=require('../models/ngo');
const User=require('../models/user');
exports.RegisterNgo=(req,res)=>{
	User.findOne({email:req.body.email}).then((user)=>{
		if(user){
			let newNgo=new Ngo(req.body);
			newNgo.save().then((newNgo)=>{
				if(newNgo){
					return res.status(200).json({message:"Ngo created successfully"});
				}
				else{
					return res.status(500).json({message:"Internal error"});
				}
			})
		}
		else{
			return res.status(400).json({message:"User not found"});
		}
	})
}

exports.GetNgo=(req,res)=>{	
	Ngo.find().then((ngos)=>{
		if(ngos){
			return res.status(200).json({ngos});
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}