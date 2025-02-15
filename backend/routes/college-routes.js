const express=require('express');
const router=express.Router();
const collegeController=require('../controllers/college-controller');
router.post('/register',collegeController.RegisterCollege);
router.get('/get',collegeController.GetCollege);
module.exports=router;