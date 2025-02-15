const Student=require('../models/student');
const User=require('../models/user');
exports.RegisterStudent=(req,res)=>{
	User.findOne({email:req.body.email}).then((user)=>{
		if(user){
			let newStudent=new Student(req.body);
			newStudent.save().then((newStudent)=>{
				if(newStudent){
					return res.status(200).json({message:"Student created successfully"});
				}
				else{
					return res.status(500).json({message:"Internal error"});
				}
			})
		}
		else{
			return res.status(400).json({message:"User not found"});
		}
	})
}
exports.GetStudent=(req,res)=>{
	Student.find().then((students)=>{
		if(students){
			return res.status(200).json({students});
		}
		else{
			return res.status(500).json({message:"Internal error"});
		}
	})
}