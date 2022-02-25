//Express
const express = require('express');
var app = express();
app.listen(3000);
app.set("view engine", "ejs");
app.set("views","./views");
app.use(express.static("public"));
//Body-Parser
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended : false }));
//MongoDB
const mongoose = require("mongoose");
const strCon = 'mongodb+srv://lnnquy:ngocquy123@clusterios.ugtdc.mongodb.net/RaoVatAppretryWrites=true&w=majority';
mongoose.connect(strCon, {useNewUrlParser: true, useUnifiedTopology: true,useFindAndModify: false}, function (err) {
    if (err) {
        console.log("MongoDB connect failure");
    }else {
        console.log("MongoDB connect successfully");
    }
});

//Routes
require("./Routes/FileUpload")(app);
require("./Routes/Account")(app);
require("./Routes/City")(app);
require("./Routes/Category")(app);
require("./Routes/Status")(app);
require("./Routes/Post")(app);
