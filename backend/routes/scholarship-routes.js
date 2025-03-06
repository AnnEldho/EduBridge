const express = require('express');
const router = express.Router();
const scholarshipController = require('../controllers/scholarship-controller');
router.post('/add', scholarshipController.AddScholarship);
module.exports = router;
