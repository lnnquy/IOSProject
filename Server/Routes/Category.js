//Models
const Category = require('../Models/Category');

module.exports = function(app) {
    app.get("/category",function(req,res){
        res.render("admin_master",{content:"./Category/Category.ejs",header:"Category"});
    });
    app.post("/category/list",function(req,res){
        Category.find(function(err,data){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,CateList:data});
            }
        });
    });
    app.post("/category/findID",function(req,res){
        Category.findById(
            req.body.ID
            ,function(err,data){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,cate:data});
            }
        });
    });
    app.post("/category/add",function(req,res){
        var newCate = Category({
            Name:req.body.name,
            Image:req.body.image
        });
        newCate.save(function(err){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1});
            }
        });
    });
    app.post("/category/update",function(req,res){
        Category.findByIdAndUpdate(
            req.body.id,
            {
                Name:req.body.name,
                Image:req.body.image
            },
            function(err){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,errMsg:"Update successfully"});
                }
            }
        );
    });
    app.post("/category/delete",function(req,res){
        Category.findByIdAndDelete(
            req.body.id,
            function(err){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,errMsg:"Update successfully"});
                }
            }
        );
    });
    
    
}