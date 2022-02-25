const mongoose = require('mongoose');
 const citySchema = mongoose.Schema({
     Name : String
 });

 module.exports = mongoose.model("City",citySchema);