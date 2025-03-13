var mongoose = require("mongoose");
const {ObjectId}=require("mongodb")
var complaintSchema=mongoose.Schema({
    userid:{
        type: ObjectId,
        required: true,
        ref:"User"
    },
    subject:{
        type:String,
    },
    complaint:{
        type:String,
    },
    reply:{
        type:String,
    },
    timestamp:{
        type:String,
        default:Date.now()
    },
    status:{
        type:String,
        default:"Pending"
    }
})
module.exports=mongoose.model("Complaint",complaintSchema);