const College = require('../models/college');
const User = require('../models/user');
exports.RegisterCollege = (req, res) => {
	User.findOne({ email: req.body.email }).then((user) => {	
		if (user) {
			let newCollege = new College(req.body);
			newCollege.save().then((newCollege) => {
				if (newCollege) {
					return res.status(200).json({ message: "College created successfully" });
				}
				else {
					return res.status(500).json({ message: "Internal error" });
				}
			})
		}
		else {
			return res.status(400).json({ message: "User not found" });
		}
	})
}

exports.GetCollege = (req, res) => {
	College.find().then((colleges) => {
		if (colleges) {
			return res.status(200).json({ colleges });
		}
		else {
			return res.status(500).json({ message: "Internal error" });
		}
	})
}	