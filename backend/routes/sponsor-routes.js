const express = require('express');
const router = express.Router();
const sponsorController = require('../controllers/sponsor-controller');
router.post('/register', sponsorController.RegisterSponsor);
router.get('/get', sponsorController.GetSponsor);
router.post('/add-request', sponsorController.AddSponsorRequest);
router.get('/view-request-by-sponsorid', sponsorController.ViewSponsorRequestBySponsorId);
router.get('/view-request-by-ngoid', sponsorController.ViewSponsorRequestByNgoId);
router.put('/update-request-status', sponsorController.UpdateSponsorRequestStatus);
router.get('/get-all-sponsors', sponsorController.GetAllSponsors);

router.post('/join-sponsorship', sponsorController.JoinSponsorship);
router.get('/view-joined-sponsorship', sponsorController.ViewJoinedSponsorship);
router.get('/view-joined-sponsorship-by-sponsorid', sponsorController.ViewJoinedSponsorshipBySponsorId);
router.get('/view-joined-sponsorship-by-ngoid', sponsorController.ViewJoinedSponsorshipByNgoId);
router.get('/view-joined-sponsorship-by-sponsorshipid', sponsorController.ViewJoinedSponsorshipBySponsorshipId);
router.get('/view-accepted-sponsor-request', sponsorController.ViewAcceptedSponsorRequest);
module.exports = router;
