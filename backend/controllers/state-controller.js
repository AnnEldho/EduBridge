const State=require('../models/state');
exports.AddState = (req, res) => {
    State.findOne({ state_name: req.body.state_name }).then((state) => {
        if (state) {
            return res.status(400).json({ message: "State already exists" });
        } else {
            let newState = new State(req.body);
            newState.save().then((newState) => {
                if (newState) {
                    return res.status(200).json({ message: "State created successfully" });
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