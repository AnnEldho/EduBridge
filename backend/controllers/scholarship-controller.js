const Scholarship = require('../models/scholarship');
exports.AddScholarship = (req, res) => {
	Scholarship.findOne({ email: req.body.email }).then((scholarship) => {
		if (scholarship) {
			let newScholarship = new Scholarship(req.body);
			newScholarship.save().then((newScholarship) => {
				if (newScholarship) {
					return res.status(200).json({ message: "Scholarship created successfully" });
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