const express = require('express');
const router = express.Router();
const sponsorController = require('../controllers/sponsor-controller');
router.post('/register', sponsorController.RegisterSponsor);
router.get('/get', sponsorController.GetSponsor);
module.exports = router;
