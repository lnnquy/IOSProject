const mongoose = require('mongoose');

 const cateSchema = mongoose.Schema({
     Name : String,
     Image:String
 });

 module.exports = mongoose.model("Category",cateSchema);