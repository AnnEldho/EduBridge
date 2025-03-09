const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var districtSchema = new mongoose.Schema({
	district_name: {
		type: String,
		required: true,
	},
	state_id: {
		type: Schema.Types.ObjectId,
		ref: 'State',
		required: true,
	},
});
module.exports = mongoose.model('District', districtSchema);