const express = require('express');
const router = express.Router();
const ngoController = require('../controllers/ngo-controller');
router.post('/register', ngoController.RegisterNgo);
router.get('/get', ngoController.GetNgo);
module.exports = router;
