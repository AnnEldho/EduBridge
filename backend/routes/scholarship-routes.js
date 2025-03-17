const express = require('express');
const router = express.Router();
const scholarshipController = require('../controllers/scholarship-controller');
router.post('/add-scholarship', scholarshipController.AddScholorship);
router.get('/view-scholarship', scholarshipController.ViewScholorship);
router.get('/view-all-scholarships', scholarshipController.ViewAllScholorship);
router.post('/change-scholarship-status', scholarshipController.ChangeScholorshipStatus);
router.post('/join-scholarship', scholarshipController.JoinScholorship);
router.get('/view-joined-scholarship', scholarshipController.ViewJoinedScholorship);
router.get('/view-joined-scholarship-by-ngo', scholarshipController.ViewJoinedScholorshipByNgo);
router.get('/viewScholarshipById', scholarshipController.ViewScholorShipById);
router.get('/view-joined-scholarship-by-sholoarshipid', scholarshipController.viewJoinedScholarshipBySholarShipId);

module.exports = router;
