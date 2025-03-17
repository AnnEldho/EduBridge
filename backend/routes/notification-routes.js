const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notification-controller');

router.post('/addNotification', notificationController.addNotification);
router.get('/getAllNotifications', notificationController.getAllNotifications);
router.get('/getNotificationById',notificationController.getNotificationById);
module.exports = router;