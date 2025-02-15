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
exports.GetUsers = (req, res) => {
    const status = req.query.status;
    let query = {};

    if (status) {
        query.status = status;
    }

    User.find(query).then((users) => {
        if (users) {
            return res.status(200).json({ users });
        } else {
            return res.status(500).json({ message: "Internal error" });
        }
    });
};