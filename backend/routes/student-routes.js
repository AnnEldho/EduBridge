const express=require('express');
const router=express.Router();
const studentController=require('../controllers/student-controller');
router.post('/register',studentController.RegisterStudent);
router.get('/get',studentController.GetStudent);
module.exports=router;
