
const Scholarship=require('../models/scholarship');
const ScholarshipJoin=require('../models/scholarshipjoin');

//add scholorship
exports.AddScholorship=(req,res)=>{
    const scholorship=new Scholarship(req.body);
    scholorship.save().then((scholorship)=>{
        if(scholorship){
            return res.status(200).json({message:"Scholorship added successfully"});
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}
//view scholorship by userid
exports.ViewScholorship=(req,res)=>{
    Scholarship.find({userid:req.body.userid}).then((scholorship)=>{
        if(scholorship){
            return res.status(200).json(scholorship);
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}
//view all scholorship
exports.ViewAllScholorship=(req,res)=>{
    Scholarship.find().then((scholorship)=>{
        if(scholorship){
            return res.status(200).json(scholorship);
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}
//view scholorship by id
exports.ViewScholorShipById=(req,res)=>{
    Scholarship.findById(req.body.id).then((scholorship)=>{
        if(scholorship){
            return res.status(200).json(scholorship);
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}
// change status of scholorship
exports.ChangeScholorshipStatus=(req,res)=>{
    ScholarshipJoin.update

    ({scholorshipid:req.body.scholorshipid},{$set:{status:req.body.status}}).then((scholorshipjoin)=>{
        if(scholorshipjoin){
            return res.status(200).json({message:"Status changed successfully"});
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}

//join scholorship
exports.JoinScholorship=(req,res)=>{
    ScholarshipJoin.findOne({userid:req.body.userid,providerid:req.body.providerid,scholorshipid:req.body.scholorshipid}).then((scholorshipjoin)=>{
        if(scholorshipjoin){
            return res.status(400).json({message:"Already joined"});
        }
        else{
    const scholorshipjoin=new ScholarshipJoin(req.body);
    scholorshipjoin.save().then((scholorshipjoin)=>{
        if(scholorshipjoin){
            return res.status(200).json({message:"Scholorship joined successfully"});
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}
    })
}
//view joined scholorship
exports.ViewJoinedScholorship=(req,res)=>{
    ScholarshipJoin.find({userid:req.body.userid}).populate('scholorshipid').populate('providerid').then((scholorshipjoin)=>{
        if(scholorshipjoin){
            return res.status(200).json(scholorshipjoin);
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}
//view joined scholorship by ngo
exports.ViewJoinedScholorshipByNgo=(req,res)=>{
    ScholarshipJoin.find({providerid:req.body.providerid}).then((scholorshipjoin)=>{
        if(scholorshipjoin){
            return res.status(200).json({scholorshipjoin});
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}

exports.viewJoinedScholarshipBySholarShipId=(req,res)=>{
    console.log(req.body);
    ScholarshipJoin.find({scholorshipid:req.body.scholorshipid}).populate('userid').then((scholorshipjoin)=>{
        if(scholorshipjoin){
            return res.status(200).json(scholorshipjoin);
        }
        else{
            return res.status(500).json({message:"Internal error"});
        }
    })
}