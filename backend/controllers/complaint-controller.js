const Complaint = require('../models/complaint');
const User = require('../models/user');
exports.RegisterComplaint = (req, res) => {
	User.findOne({ email: req.body.email }).then((user) => {
		if (user) {
			let newComplaint = new Complaint(req.body);
			newComplaint.save().then((newComplaint) => {
				if (newComplaint) {
					return res.status(200).json({ message: "Complaint created successfully" });
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
exports.GetComplaint = (req, res) => {
	Complaint.find().then((complaints) => {
		if (complaints) {
			return res.status(200).json({ complaints });
		}
		else {
			return res.status(500).json({ message: "Internal error" });
		}
	})
}