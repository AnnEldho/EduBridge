const Notification=require('../models/notification');
exports.addNotification=(req,res)=>{
	let newNotification=Notification(req.body)
	newNotification.save().then((notification)=>{
		if(notification){
			return res.status(201).json(notification)
		}else{
			return res.status(404).json({msg:"Error"})
		}
	})
}