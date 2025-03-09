const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var stateSchema = new mongoose.Schema({
	state_name: {
		type: String,
		required: true,
	},
});
module.exports = mongoose.model('State', stateSchema);