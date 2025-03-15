const express = require('express')
const router = express.Router()
const notificationController = require('../controllers/notification-controller')
router.post('/addNotification', notificationController.addNotification)
module.exports = router;