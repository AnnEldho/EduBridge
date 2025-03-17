const Notification = require('../models/notification');

// Add a new notification
exports.addNotification = (req, res) => {
    const { title, description } = req.body;

    if (!title || !description) {
        return res.status(400).json({ message: "Title and description are required" });
    }

    const newNotification = new Notification({ title, description });
    newNotification.save().then((notification) => {
        if (notification) {
            return res.status(201).json({ message: "Notification added successfully", notification });
        } else {
            return res.status(500).json({ message: "Internal error" });
        }
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    });


};
exports.getAllNotifications = async (req, res) => {
    try {
        const notifications = await Notification.find();

        return res.status(200).json(notifications);
    } catch (err) {
        console.error("Error fetching notifications:", err);
        return res.status(500).json({ message: "Internal server error", error: err.message });
    }
};

exports.getNotificationById = async(req,res)=> {
	Notification.findOne({_id:req.body.notificationid}).then((notification)=>{
		if(notification){
			return res.status(201).json(notification)
		} else{
			return res.status(404).json({msg:"Error"})
		}
	})
};
