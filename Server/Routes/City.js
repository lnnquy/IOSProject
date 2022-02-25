//Model
var City = require("../Models/City");

module.exports = function(app) {
    app.get("/city",function(req,res) {
        res.render("admin_master",{content:"./City/City.ejs",header:"City"});
    });
    app.post("/city/add",function(req,res) {
        var newCity = City({
            Name:req.body.Name
        });
        newCity.save(function(err){
            if(err) {
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,errMsg:"Insert New City Successfully"});
            }
        });
    });
    app.post("/city",function(req,res){
        City.find(function(err,data){
            if(err) {
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,CityList:data});
            }
        });
    });
    app.post("/city/findID",function(req,res){
        
        City.findById(
            req.body.id,
            function(err,data){
                if(err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,city:data});
                }
            }
        );
    });
    app.post("/city/update",function(req,res){
        
        City.findByIdAndUpdate(
            req.body.id,
            {Name:req.body.Name},
            function(err){
                if(err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1});
                }
            }
        );
    });
    app.post("/city/delete",function(req,res){
        
        City.findByIdAndDelete(
            req.body.id,
            function(err){
                if(err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1});
                }
            }
        );
    });
}