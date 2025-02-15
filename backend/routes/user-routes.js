const express = require('express');
const router = express.Router();
const userController = require('../controllers/user-controller');
router.post('/register', userController.Register);
router.post('/login', userController.Login);
router.get('/get', userController.GetUsers);
module.exports = router;
