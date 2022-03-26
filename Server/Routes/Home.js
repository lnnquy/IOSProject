const Posts = require("../Models/Post");
const Users = require("../Models/User");

module.exports = function (app) {
    app.get("/home",function(req,res){
        res.render("admin_master",{content:"./Home/home.ejs",header:"Home"});
    });
    const date = new Date();
    app.post("/totalPosts",function(req,res){
        Posts.find(
            function(err,data){
                if (err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,countPost:data.length});
                }
            }
        )
        
    });
    app.post("/countPostsByDateNow",function(req,res){
        var i = 0;
        Posts.find(
            function(err,data){
                if (err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    data.forEach(function(post) {
                        const day = post.PostDate;
                        if(date.getFullYear() === day.getFullYear() && date.getMonth() === day.getMonth() && date.getDate() === day.getDate()) {
                            i++;
                        }
                    });
                    res.json({kq:1,countPost:i});
                }
            }
        );    
    });
    app.post("/totalUsers",function(req,res){
        Users.find(
            function(err,data){
                if (err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,countUser:data.length});
                }
            }
            );
    });
    app.post("/countUsersByDateNow",function(req,res){
        var i = 0;
        Users.find(
            function(err,data){
                if (err) {
                    res.json({kq:0,errMsg:err});
                }else {
                    data.forEach(function(user) {
                        const day = user.RegisterDate;
                        if(date.getFullYear() === day.getFullYear() && date.getMonth() === day.getMonth() && date.getDate() === day.getDate()) {
                            i++;
                        }
                    });
                    res.json({kq:1,countUser:i});
                }
            }
            );
    });
}