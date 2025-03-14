const Complaint=require("../models/complaint")


exports.addComplaint=(req,res)=>{
    let newComplaint=Complaint(req.body)
    newComplaint.save().then((complaint)=>{
        if(complaint){
            return res.status(201).json(complaint)
        }else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.getAllComplaint=(req,res)=>{
    console.log("Get All Complaint")
    Complaint.find().then((complaint)=>{
        if(complaint){
            return res.status(201).json(complaint)
        }else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.getComplaintByUserid=(req,res)=>{
    console.log(req.body)   
    Complaint.find({userid:req.body.userid}).then((complaint)=>{
        if(complaint){
            return res.status(201).json(complaint)
        }else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.getComplaintById=(req,res)=>{
    Complaint.findOne({_id:req.body.complaintid}).then((complaint)=>{
        if(complaint){
            return res.status(201).json(complaint)
        }else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.addReplyToComplaint=(req,res)=>{
    Complaint.updateOne({_id:req.body.complaintid},{
        $set:{
            reply:req.body.reply,
            status:"Replied"
        }
    }).then((complaint)=>{
        if(complaint){
            return res.status(201).json(complaint)
        }else{
            return res.status(404).json({msg:"Error"})
        }
    })
}