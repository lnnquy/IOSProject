const mongoose = require('mongoose');
 const tokenSchema = mongoose.Schema({
     Token : String,
     User : mongoose.SchemaTypes.ObjectId,
     RegisterDate : Date,
     State : Boolean
 });

 module.exports = mongoose.model("Token",tokenSchema);