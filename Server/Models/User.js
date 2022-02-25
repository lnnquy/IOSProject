const mongoose = require('mongoose');
 const userSchema = mongoose.Schema({
     Name : String,
     Email : String,
     Phone : String,
     Password : String,
     Image : String,
     RegisterDate : Date,
     RandomNo : String,
     Active : Boolean
 });

 module.exports = mongoose.model("User",userSchema);