const District=require('../models/district');
const state=require('../models/state');	

exports.AddDistrict = (req, res) => {
    District.findOne({ district_name: req.body.district_name }).then((district) => {
        if (district) {
            return res.status(400).json({ message: "District already exists" });
        } else {
            let newDistrict = new District(req.body);
            newDistrict.save().then((newDistrict) => {
                if (newDistrict) {
                    return res.status(200).json({ message: "District created successfully" });
                } else {
                    return res.status(500).json({ message: "Internal error" });
                }
            }).catch((err) => {
                return res.status(500).json({ message: "Internal error", error: err });
            });
        }
    }).catch((err) => {
        return res.status(500).json({ message: "Internal error", error: err });
    });
};