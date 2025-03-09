const mongoose = require('mongoose');
const Schema = mongoose.Schema;
var talukSchema = new mongoose.Schema({
	taluk_name: {
		type: String,
		required: true,
	},
	district_id: {
		type: Schema.Types.ObjectId,
		ref: 'District',
		required: true,
	},
});
module.exports = mongoose.model('Taluk', talukSchema);