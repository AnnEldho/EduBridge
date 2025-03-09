const express=require('express');
const router=express.Router();
const collegeController=require('../controllers/college-controller');
router.post('/register',collegeController.RegisterCollege);
router.get('/getcollege',collegeController.GetCollege);
router.post('/getstudentsbyinstituition',collegeController.GetStudentsByInstituition);
router.post('/approvestudent',collegeController.ApproveStudent);
module.exports=router;