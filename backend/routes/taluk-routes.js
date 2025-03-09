const express = require('express');
const router = express.Router();
const talukController = require('../controllers/taluk-controller');
router.post('/addtaluk', talukController.AddTaluk);
module.exports = router;