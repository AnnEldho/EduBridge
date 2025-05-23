const express = require('express');
const router = express.Router();
const userController = require('../controllers/user-controller');
router.post('/register', userController.Register);
router.post('/login', userController.Login);
router.get('/getpendingsponsor', userController.getPendingSponsor);
router.get('/getpendingcollege', userController.getPendingCollege);
router.get('/getcollegelist', userController.getCollegeList);
router.get('/getsponsorlist', userController.getSponsorList);
router.get('/getngolist', userController.getNgoList);
router.post('/updatestatus', userController.updateStatus);
router.post('/forgotpassword', userController.forgotPassword);
router.post('/checkemail', userController.checkEmail);
router.post('/resetpassword', userController.resetPassword);
router.post('/verifypassword', userController.verifyPassword);

router.post('/finduser', userController.findUser);
module.exports = router;
