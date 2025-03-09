const express = require('express');
const router = express.Router();
const districtController = require('../controllers/district-controller');
router.post('/adddistrict', districtController.AddDistrict);
module.exports = router;