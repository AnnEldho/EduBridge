const Sponsor=require('../models/sponsor');
const User=require('../models/user');
exports.RegisterSponsor=(req,res)=>{
	User.findOne({email:req.body.email}).then((user)=>{
		if(user){
			let newSponsor=new Sponsor(req.body);
			newSponsor.save().then((newSponsor)=>{
				if(newSponsor){
					return res.status(200).json({message:"Sponsor created successfully"});
				}
				else{
					return res.status(500).json({message:"Internal error"});
				}
			})
		}
		else{
			return res.status(400).json({message:"User not found"});
		}
	});
}

exports.GetSponsor=(req,res)=>{
	Sponsor.find().then((sponsors)=>{
		if(sponsors){
			return res.status(200).json({sponsors});
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}