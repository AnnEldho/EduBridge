require("dotenv").config();
const mongoose = require("mongoose");
const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const cors = require("cors");
const UserRoutes = require("./routes/user-routes");
const StudentRoutes = require("./routes/student-routes");
const CollegeRoutes = require("./routes/college-routes");
const NgoRoutes = require("./routes/ngo-routes");
const SponsorRoutes = require("./routes/sponsor-routes");
const ScholarshipRoutes = require("./routes/scholarship-routes");
const StateRoutes = require("./routes/state-routes");
const DistrictRoutes = require("./routes/district-routes");
const TalukRoutes = require("./routes/taluk-routes");
const ComplaintRoutes = require("./routes/complaint-routes");
const NotificationRoutes = require("./routes/notification-routes");

//DB Connection
mongoose
 .connect(process.env.DATABASE, {
 useNewUrlParser: true, 
 useUnifiedTopology: true 
 })
 .then(() => {
 console.log("DB CONNECTED");
 });
//Middlewares
app.use(bodyParser.json());
app.use(cookieParser());
app.use(cors());

app.use("/api", UserRoutes);
app.use("/api", StudentRoutes);
app.use("/api", CollegeRoutes);
app.use("/api", NgoRoutes);
app.use("/api", SponsorRoutes);
app.use("/api", ScholarshipRoutes); 
app.use("/api", StateRoutes);
app.use("/api", DistrictRoutes);
app.use("/api", TalukRoutes);
app.use("/api", ComplaintRoutes);
app.use("/api", NotificationRoutes);


//PORT
const port = process.env.PORT || 8000;
//Starting a server
app.listen(port, () => {
 console.log(`app is running at ${port}`);
});
