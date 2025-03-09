const College = require('../models/college');
const User = require('../models/user');
const Student = require('../models/student');
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
	User.find({usertype:'College'}).then((colleges) => {
		if (colleges) {
			return res.status(200).json(colleges);
		}
		else {
			return res.status(500).json({ message: "Internal error" });
		}
	})
}	

//get students by instituition
exports.GetStudentsByInstituition = (req, res) => {
	Student.find({instituition:req.body.collegeid}).populate({path: 'user_id',match: { status: 'Pending' }}).then((students) => {
		console.log(students);
		if (students) {
			
			return res.status(200).json(students);
		}
		else {
			return res.status(500).json({ message: "Internal error" });
		}
	})
}

//approve student
exports.ApproveStudent = (req, res) => {
	User.findOneAndUpdate({_id:req.body.studentid},{status:req.body.status}).then((student) => {
		
		if (student) {
			return res.status(200).json({ message: "Student approved successfully" });
		}
		else {
			return res.status(500).json({ message: "Internal error" });
		}
	})
}