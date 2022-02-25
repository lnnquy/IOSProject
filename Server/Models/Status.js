const mongoose = require('mongoose');
 const statusSchema = mongoose.Schema({
     Name : String,
     Details:String
 });

 module.exports = mongoose.model("Status",statusSchema);