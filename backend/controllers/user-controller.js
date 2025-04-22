const User=require('../models/user');
const Student=require('../models/student');
const College=require('../models/college');
const Ngo=require('../models/ngo');
const Sponsor=require('../models/sponsor');

exports.Register=(req,res)=>{
    console.log(req.body);
     User.findOne({email:req.body.email}).then((user)=>{
        if(user){
            return res.status(400).json({message: "User already exists"});
        }
        if(req.body.usertype=="Student"){
            let newUser=new User(req.body);
            newUser.save().then((newUser)=>{
            if(newUser){
                req.body.user_id=newUser._id;
                let newStudent=new Student(req.body);
                newStudent.save().then((newStudent)=>{
                    if(newStudent){
                        return res.status(200).json({message:"Student added successfully"});
                    }
                    else{
                        return res.status(500).json({message:"Internal error"});
                    }
                })
            }
            else{
                return res.status(500).json({message:"Internal error"});
            }
         })

        }
        else if(req.body.usertype=="College"){
            let newUser=new User(req.body);
            newUser.save().then((newUser)=>{
                if(newUser){
                    req.body.user_id=newUser._id;
                    let newCollege=new College(req.body);
                    newCollege.save().then((newCollege)=>{
                        if(newCollege){
                            return res.status(200).json({message:"College added successfully"});
                        }
                        else{
                            return res.status(500).json({message:"Internal error"});
                        }
                    })
                    
                }
                else{
                    return res.status(500).json({message:"Internal error"});
                }
            })
        }
        else if(req.body.usertype=="Ngo"){
            let newUser=new User(req.body);
            newUser.save().then((newUser)=>{
                if(newUser){
                    req.body.user_id=newUser._id;
                    let newNgo=new Ngo(req.body);
                    newNgo.save().then((newNgo)=>{
                        if(newNgo){
                            return res.status(200).json({message:"Ngo added successfully"});
                        }
                        else{
                            return res.status(500).json({message:"Internal error"});
                        }
                    })
                    
                }
                else{
                    return res.status(500).json({message:"Internal error"});
                }
            })
        }
        else if(req.body.usertype=="Sponsor"){
            let newUser=new User(req.body);
            newUser.save().then((newUser)=>{
                if(newUser){
                    req.body.user_id=newUser._id;
                    let newSponsor=new Sponsor(req.body);
                    newSponsor.save().then((newSponsor)=>{
                        if(newSponsor){
                            return res.status(200).json({message:"Sponsor added successfully"});
                        }
                        else{
                            return res.status(500).json({message:"Internal error"});
                        }
                    })
                    
                }
                else{
                    return res.status(500).json({message:"Internal error"});
                }
            })
        }
        else{
            return res.status(400).json({message:"Invalid usertype"});
        }
} )
}

exports.Login=(req,res)=>{
    User.findOne({email:req.body.email}).then((user)=>{
       if(user){
        User.findOne({email:req.body.email,password:req.body.password}).then((exist)=>{
            if(exist){
                return res.status(200).json({ exist});
            }
            else{
                return res.status(400).json({message: "Invalid password"});
            }
        })
          
       }
       
           else{
               return res.status(400).json({message:"user not found"});
           }
       })
    
}

exports.getPendingSponsor = (req, res) => {
    User.find({ usertype: 'Sponsor', status: 'Pending' }).then((users) => {
        if (users.length > 0) {
            const sponsorIds = users.map(user => user._id);
            Sponsor.find({ user_id: { $in: sponsorIds } }).then((sponsors) => {
                const pendingSponsors = sponsors.map(sponsor => {
                    const user = users.find(user => user._id.equals(sponsor.user_id));
                    return {
                        sponsor,
                        user
                    };
                });

                return res.status(200).json(pendingSponsors);
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        } else {
            return res.status(404).json({ message: "No pending sponsors found" });
        }
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    });
};

exports.getPendingCollege = (req, res) => {
    User.find({ usertype: 'College', status: 'Pending' }).then((users) => {
        if (users.length > 0) {
            const collegeids = users.map(user => user._id);
            College.find({ user_id: { $in: collegeids } }).then((advisors) => {
                const pendingCollege = advisors.map(college => {
                    const user = users.find(user => user._id.equals(college.user_id));
                    return {
                        college,
                        user
                    };
                });
                
                return res.status(200).json(pendingCollege);
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        } else {
            return res.status(404).json({ message: "No pending advisors found" });
        }
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    })
};

exports.updateStatus = (req, res) => {  

    User.findOneAndUpdate({ _id: req.body.id    }, { status: req.body.status }, { new: true }).then((ngo) => {          
        if (ngo) {
            return res.status(200).json({ message: "Status updated successfully" });
        } else {
            return res.status(404).json({ message: "Ngo not found" });
        }
    }).catch((err) => {           
        return res.status(500).json({ message: "Internal error", error: err });
    }); 
};

exports.getCollegeList = (req,res) => {
    User.find({ usertype: 'College'}).then((users) => {
        if (users.length > 0) {
            const collegeids = users.map(user => user._id);
            College.find({ user_id: { $in: collegeids } }).then((advisors) => {
                const College = advisors.map(college => {
                    const user = users.find(user => user._id.equals(college.user_id));
                    return {
                        college,
                        user
                    };
                });
                
                return res.status(200).json(College);
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        } else {
            return res.status(404).json({ message: "No colleges found" });
        }
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    })
};

exports.getSponsorList = (req,res) => {
    User.find({ usertype: 'Sponsor'}).then((users) => {
        if (users.length > 0) {
            const sponsorIds = users.map(user => user._id);
            Sponsor.find({ user_id: { $in: sponsorIds } }).then((sponsors) => {
                const Sponsor = sponsors.map(sponsor => {
                    const user = users.find(user => user._id.equals(sponsor.user_id));
                    return {
                        sponsor,
                        user
                    };
                });

                return res.status(200).json(Sponsor);
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        } else {
            return res.status(404).json({ message: "No sponsors found" });
        }
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    });
};

exports.getNgoList = (req,res) => {
    User.find({ usertype: 'Ngo'}).then((users) => {
        if (users.length > 0) {
            const ngoIds = users.map(user => user._id);
            Ngo.find({ user_id: { $in: ngoIds } }).then((ngos) => {
                const ngolist = ngos.map(ngo => {
                    const user = users.find(user => user._id.equals(ngo.user_id));
                    return {
                        ngo,
                        user
                    };
                }
                );
                return res.status(200).json(ngolist);
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        } else {
            return res.status(404).json({ message: "No ngos found" });
        }
    }
    ).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    });
};


// Add the changePassword function here

exports.forgotPassword = (req, res) => {
    const { email, newPassword } = req.body;

    User.findOne({ email: email }).then((user) => {
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        user.password = newPassword;
        user.save().then((updatedUser) => {
            return res.status(200).json({ message: "Password reset successfully" });
        }).catch((err) => {
            return res.status(500).json({ message: "Internal error", error: err });
        });
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    });
};


    exports.getUserData = (req, res) => {
        const { userId } = req.params;
    
        User.findById(userId).then((user) => {
            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }
    
            let model;
            switch (user.usertype) {
                case 'Student':
                    model = Student;
                    break;
                case 'College':
                    model = College;
                    break;
                case 'Ngo':
                    model = Ngo;
                    break;
                case 'Sponsor':
                    model = Sponsor;
                    break;
                default:
                    return res.status(400).json({ message: "Invalid usertype" });
            }
    
            model.findOne({ user_id: user._id }).then((details) => {
                if (details) {
                    return res.status(200).json({ user, details });
                } else {
                    return res.status(404).json({ message: `${user.usertype} details not found` });
                }
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        }).catch((err) => {
            return res.status(500).json({ message: "Internal error", error: err });
        });
    };

    exports.checkEmail = (req, res) => {
        const { email } = req.body;
        User.findOne({ email: email }).then((user) => {
            if (user) {
                return res.status(200).json({ message: "Email exists" });
            } else {
                return res.status(404).json({ message: "Email not found" });
            }
        }
        ).catch((err) => {
            return res.status(500).json({ message: "Internal error", error: err });
        });
    };

    exports.resetPassword = (req, res) => {
        const { email, newPassword } = req.body;
        User.findOne({ email: email }).then((user) => {
            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }
            user.password = newPassword;
            user.save().then((updatedUser) => {
                return res.status(200).json({ message: "Password reset successfully" });
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        }).catch((err) => {
            return res.status(500).json({ message: "Internal error", error: err });
        });
    };

    exports.verifyPassword = (req, res) => {
        const { email, password } = req.body;
    
        User.findOne({ email: email }).then((user) => {
            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }
    
            if (user.password !== password) {
                return res.status(400).json({ message: "Invalid password" });
            }
    
            return res.status(200).json({ message: "Password verified successfully" });
        }).catch((err) => {
            return res.status(500).json({ message: "Internal error", error: err });
        });
    };

    exports.findUser = (req, res) => {
        const { email } = req.body
        User.findOne({_id:new ObjectId(req.body.userid)}).then((user) => {
            if (!user) {
                return res.status(404).json({ message: "User not found" });
            }
            return res.status(200).json({ user });
        }
        ).catch((err) => {
            return res.status(500).json({ message: "Internal error", error: err });
        });
    }