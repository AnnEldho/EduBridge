var express = require('express')
routes = express.Router()
const complaintController=require("../controllers/complaint-controller")
routes.post("/addComplaint",complaintController.addComplaint)
routes.post("/getAllComplaint",complaintController.getAllComplaint)
routes.post("/getComplaintByUserid",complaintController.getComplaintByUserid)
routes.post("/getComplaintById",complaintController.getComplaintById)
routes.post("/addReplyToComplaint",complaintController.addReplyToComplaint)

module.exports=routes;