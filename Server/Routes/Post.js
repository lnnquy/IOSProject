const Post = require("../Models/Post");

module.exports = function(app) {
    app.get("/post",function(req,res){
        res.render("admin_master",{content:"./Post/Posts.ejs",header:"Post"});
    });
    app.post("/listPosts",function(req,res){
        Post.find(function(err,data){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,list:data});
            }
        });
    });
    app.post("/post/add",function(req,res){
        var newPost = Post({
            Title : req.body.Title,
            Price:req.body.Price,
            Image:req.body.Image,
            Description:req.body.Description,
            User : req.body.UserID,
            Category: req.body.CateID,
            City : req.body.CityID,
            Status : req.body.StatusID,
            Active : true,
            PostDate : Date.now(),
            View : 0
        });
        newPost.save(function(err){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,errMsg:"Post successfully"});
            }
            
        });
    });
    app.post("/post/list",function(req,res) {
        Post.find({Active:1}).sort({PostDate:'descending'}).exec(function(err,data){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,PostList:data});
            }
        })
        
    });
    app.post("/post/findIdCate",function(req,res) {
        Post.find(
            {Category:req.body.idCate,Active:true},
            function(err,data){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,PostList:data});
                }
            }
        );
    });
    app.post("/post/findID",function(req,res) {
        Post.find(
            {_id:req.body.ID},
            function(err,data){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,PostList:data});
                }
            }
        );
    });
    app.post("/post/updateView",function(req,res) {
        Post.findByIdAndUpdate(
            req.body.ID,
            {View: req.body.VIEW},
            function(err){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1});
                }
            }
        );
    });
    app.post("/post/findWUser",function(req,res) {
        Post.find(
            {User:req.body.User,Active:req.body.Active},
            function(err,data){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,PostList:data});
                }
            }
        );
    });
    app.post("/post/updateActive",function(req,res) {
        Post.findByIdAndUpdate(
            req.body.ID,
            {Active: req.body.Active},
            function(err){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1});
                }
            }
        );
    });
    

}