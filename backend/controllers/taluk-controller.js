const Taluk= require('../models/taluk');
const district=require('../models/district');
exports.AddTaluk = (req, res) => {
    Taluk.findOne({ taluk_name: req.body.taluk_name }).then((taluk) => {
        if (taluk) {
            return res.status(400).json({ message: "Taluk already exists" });
        } else {
            let newTaluk = new Taluk(req.body);
            newTaluk.save().then((newTaluk) => {
                if (newTaluk) {
                    return res.status(200).json({ message: "Taluk created successfully" });
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