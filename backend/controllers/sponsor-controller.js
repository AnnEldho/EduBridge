const Sponsor=require('../models/sponsor');
const User=require('../models/user');
const SponsorRequest=require('../models/sponsorrequest');
const SponsorshipJoin=require('../models/sponsorshipjoin');
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

//add sponsor request
exports.AddSponsorRequest=(req,res)=>{
	const sponsorRequest=new SponsorRequest(req.body);
	sponsorRequest.save().then((sponsorRequest)=>{
		if(sponsorRequest){
			return res.status(200).json({message:"Sponsor request added successfully"});
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}
//view sponsor request by sponsorid
exports.ViewSponsorRequestBySponsorId=(req,res)=>{
	SponsorRequest.find({sponsorid:req.body.sponsorid}).populate('ngoid').then((sponsorRequest)=>{
		if(sponsorRequest){
			return res.status(200).json(sponsorRequest);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}
//view sponsor request by ngoid
exports.ViewSponsorRequestByNgoId=(req,res)=>{
	SponsorRequest.find({ngoid:req.body.ngoid}).populate('sponsorid').then((sponsorRequest)=>{
		if(sponsorRequest){
			return res.status(200).json(sponsorRequest);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}
//update sponsor request status
exports.UpdateSponsorRequestStatus=(req,res)=>{
	SponsorRequest.findByIdAndUpdate(req.body.id,{$set:{status:req.body.status}}).then((sponsorRequest)=>{
		if(sponsorRequest){
			return res.status(200).json({message:"Sponsor request updated successfully"});
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}

//get all sponsors
exports.GetAllSponsors=(req,res)=>{
	console.log("get all sponsors");
	User.find({usertype:'Sponsor'}).then((sponsors)=>{
		console.log(sponsors);
		if(sponsors){
			return res.status(200).json(sponsors);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}

//view accepted sponsor request
exports.ViewAcceptedSponsorRequest=(req,res)=>{
	console.log("view accepted sponsor request");
	SponsorRequest.find({status:'Accepted'}).populate('ngoid').populate('sponsorid').then((sponsorRequest)=>{
		if(sponsorRequest){
			return res.status(200).json(sponsorRequest);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}

//join sponsorship
exports.JoinSponsorship=(req,res)=>{
	SponsorshipJoin.findOne({userid:req.body.userid,sponsorid:req.body.sponsorid,sponsorshipid:req.body.sponsorshipid}).then((sponsorshipjoin)=>{
		if(sponsorshipjoin){
			return res.status(400).json({message:"Already joined"});
		}
		else{
			const sponsorshipjoin=new SponsorshipJoin(req.body);
			sponsorshipjoin.save().then((sponsorshipjoin)=>{
				if(sponsorshipjoin){
					return res.status(200).json({message:"Sponsorship joined successfully"});
				}
				else{
					return res.status(500).json({message:"Internal error"});
				}
			})
		}
	})
}
//view joined sponsorship by userid
exports.ViewJoinedSponsorship=(req,res)=>{
	SponsorshipJoin.find({userid:req.body.userid}).populate('sponsorshipid').populate('sponsorid').then((sponsorshipjoin)=>{
		if(sponsorshipjoin){
			return res.status(200).json(sponsorshipjoin);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}
//view joined sponsorship by sponsorid
exports.ViewJoinedSponsorshipBySponsorId=(req,res)=>{
	SponsorshipJoin.find({sponsorid:req.body.sponsorid}).populate('sponsorshipid').populate('userid').then((sponsorshipjoin)=>{
		if(sponsorshipjoin){
			return res.status(200).json(sponsorshipjoin);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}
//view joined sponsorship by ngoid
exports.ViewJoinedSponsorshipByNgoId=(req,res)=>{
	SponsorshipJoin.find({ngoid:req.body.ngoid}).populate('sponsorshipid').populate('userid').then((sponsorshipjoin)=>{
		if(sponsorshipjoin){
			return res.status(200).json(sponsorshipjoin);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}
//view joined sponsorship by sponsorshipid
exports.ViewJoinedSponsorshipBySponsorshipId=(req,res)=>{
	SponsorshipJoin.find({sponsorshipid:req.body.sponsorshipid}).populate('userid').populate('sponsorid').then((sponsorshipjoin)=>{
		if(sponsorshipjoin){
			return res.status(200).json(sponsorshipjoin);
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}


