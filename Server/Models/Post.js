const mongoose = require('mongoose');

const postSchema = mongoose.Schema({
     Title : String,
     Price:String,
     Image:[String],
     Description:String,
     User : mongoose.SchemaTypes.ObjectId,
     Category: mongoose.SchemaTypes.ObjectId,
     City : mongoose.SchemaTypes.ObjectId,
     Status : mongoose.SchemaTypes.ObjectId,
     Active : Boolean,
     PostDate : Date,
     View : Number
});
module.exports = mongoose.model("Post",postSchema);