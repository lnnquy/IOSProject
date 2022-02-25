const Status = require('../Models/Status');

module.exports = function(app) {
    app.get("/status",function(req,res){
        res.render("admin_master",{content:"./Status/Status.ejs",header:"Post Status"});
    });
    app.post("/status/list",function(req,res){
        Status.find(function(err,data){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,StatusList:data})
            }
        });
    });
    app.post("/status/findID",function(req,res){
        Status.findById(req.body.ID,function(err,data){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,status:data})
            }
        });
    });
    app.post("/status/add",function(req,res){
        var newStatus = Status({
            Name : req.body.name,
            Details : req.body.details
        });
        newStatus.save(function(err){
            if(err){
                res.json({kq:0,errMsg:err});
            }else {
                res.json({kq:1,errMsg:"Add status successfully"})
            }
        });
    });
    app.post("/status/update",function(req,res){
        Status.findByIdAndUpdate(
            req.body.id,
            { 
                Name : req.body.name,
                Details : req.body.details
            },
            function(err){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,errMsg:"Update successfully"})
                }
            }
        );
    });
    app.post("/status/delete",function(req,res){
        Status.findByIdAndDelete(
            req.body.id,
            function(err){
                if(err){
                    res.json({kq:0,errMsg:err});
                }else {
                    res.json({kq:1,errMsg:"Delete successfully"})
                }
            }
        );
    });
}