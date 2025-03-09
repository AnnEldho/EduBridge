const express = require('express');
const router = express.Router();
const complaintController = require('../controllers/complaint-controller');
router.post('/register', complaintController.RegisterComplaint);
router.get('/getcomplaint', complaintController.GetComplaint);
module.exports = router;
