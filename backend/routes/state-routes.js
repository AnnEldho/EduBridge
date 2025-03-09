const express=	require('express');
const router=	express.Router();
const stateController=	require('../controllers/state-controller');
router.post('/addstate',stateController.AddState);
module.exports=	router;