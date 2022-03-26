//Bcryptjs
const bcrypt = require("bcryptjs");
//Models
const User = require('../Models/User');
const Token = require('../Models/Token');
//jwt
const jwt = require('jsonwebtoken');
const privateKey = "ngocquy123"

module.exports = function(app) {
    app.get("/user",function(req,res){
        res.render("admin_master",{content:"./User/Users.ejs",header:"Users"});
    });
    app.post("/listUsers",function(req,res){
        User.find(function(err,data){
            if (err) {
                res.json({kq : 0, errMsg : "List User Error"});
            }else {
                res.json({kq:1,list:data})
            }
        });
    });
    app.post("/verifyToken",function(req,res) {
        Token.findOne({Token:req.body.token,State:true}).select("_id").lean().then(result=>{
            if(!result) {
                res.json({kq:0,errMsg:"Error Token"});
            }else {
                jwt.verify(req.body.token,privateKey,function(err,decoded){
                    if(!err && decoded !== undefined) {
                        res.json({kq:1,User:decoded});
                    }else {
                        res.json({kq:0,errMsg:"Token Loi"});
                    }
                });
            }
        });
    })
    app.post("/logout",function(req,res) {
        Token.updateOne({Token:req.body.token},{State:false},function(err){
            if (err) {
                res.json({kq : 0, errMsg : "Logout Error"});
            }else {
                res.json({kq:1,errMsg : "Log out successfully"})
            }
        });
    });
    app.post("/Login",function(req,res){
        User.findOne(
            {
                "Email" : req.body.email
            },function(err,user) {
                if (err) {
                    res.json({kq : 0, errMsg : err});
                }else {
                    if (user == null) {
                        res.json({kq : 0, errMsg : "Email is incorrect "});
                    }else {
                        bcrypt.compare(req.body.password,user.Password,function(err,resBcr) {
                            if(resBcr === true) {
                                jwt.sign({
                                    IdUser : user._id,
                                    Email : user.Email,
                                    Name : user.Name,
                                    Phone : user.Phone,
                                    Image : user.Image,
                                    RegisterDate : user.RegisterDate,
                                    Active : user.Active,
                                    CreateJWTDate : Date.now()
                                },privateKey,
                                {
                                    expiresIn: Math.floor(Date.now()/1000)+60*60*24*30
                                }
                                ,function(err,token) {
                                    if (err) {
                                        res.json({kq : 0, errMsg : err});
                                    }else {
                                        //Save tokens
                                        var newToken = new Token({
                                            Token : token,
                                            User : user._id,
                                            RegisterDate : Date.now(),
                                            State : true
                                        });
                                        newToken.save(function(err){
                                            if (err) {
                                                res.json({kq : 0, errMsg : err});
                                            }else {
                                                res.json({kq : 1, token : token});
                                            }
                                        });
                                    }
                                });
                                
                            }else {
                                res.json({kq : 0, errMsg : "Password is incorrect "});
                            }
                        });
                    }
                }
            }
        );
    });
    app.post("/account/findID",function(req,res) {
        User.findOne(
            {"_id" : req.body.ID}
            ,function(err,data) {
                if (err) {
                    res.json({kq : 0, errMsg : err});
                }else {
                    res.json({kq : 1, user : data});
                    
                }
            }
        );
    });
    app.post("/FindUser",function(req,res) {
        User.findOne(
            {"Email" : req.body.email}
            ,function(err,data) {
                if (err) {
                    res.json({kq : 0, errMsg : err});
                }else {
                    if (data == undefined) {
                        res.json({kq : 1, errMsg : "User is empty. "});
                    }else {
                        res.json({kq:2,user : data});
                    }
                }
            }
        );
    });
    app.post("/register",function(req,res) {
        
        bcrypt.genSalt(10,function(err,salt) {
            if(err) {
                res.json({kq:0,errMsg:err});
            }else {
                bcrypt.hash(req.body.password,salt,function(err,hash) {
                    if(err) {
                        res.json({kq:0,errMsg:err});
                    }else {
                        //3. Insert database
                        
                        var newUser =  User({
                            Name : req.body.name,
                            Email : req.body.email,
                            Phone : req.body.phone,
                            Password : hash,
                            Image : req.body.image,
                            RegisterDate : Date.now(),
                            RandomNo : randomNumber(10),
                            Active : false
                        });
                        newUser.save(function(err) {
                            if(err) {
                                res.json({kq:0,errMsg:err});
                            }else {
                                res.json({kq:1,errMsg:"Register successfully!!!"});
                            }
                        });
                        //4. Gá»­i mail
                    }
                });
            }
        });
    });
    app.post("/updateUser",function(req,res) {
        User.findOneAndUpdate(
            {"_id" : req.body.id},
            {
                Name : req.body.name,
                Email : req.body.email,
                Phone : req.body.phone,
                Image : req.body.image
            }
            ,function(err) {
                if (err) {
                    res.json({kq : 0, errMsg : err});
                }else {
                     res.json({kq : 1, errMsg : "Update successfully. "}); 
                }
            }
        );
    });
    app.post("/changePassword",function(req,res){
        User.findById(
            req.body.id
            ,function(err,user) {
                if (err) {
                    res.json({kq : 0, errMsg : err});
                }else {
                    if (user == null) {
                        res.json({kq : 0, errMsg : "ID is incorrect "});
                    }else {
                        bcrypt.compare(req.body.currentPass,user.Password,function(err,resBcr) {
                            if(resBcr === true) {
                                bcrypt.genSalt(10,function(err,salt) {
                                    if(err) {
                                        res.json({kq:0,errMsg:err});
                                    }else {
                                        bcrypt.hash(req.body.newPassword,salt,function(err,hash) {
                                            if(err) {
                                                res.json({kq:0,errMsg:err});
                                            }else {
                                                //3. Insert database
                                                User.findByIdAndUpdate(
                                                    req.body.id,
                                                    {Password:hash},
                                                    function(err){
                                                        if (err) {
                                                            res.json({kq : 0, errMsg : err});
                                                        }else {
                                                             res.json({kq : 1, errMsg : "Update successfully. "}); 
                                                        }
                                                    }
                                                );
                                            }
                                        });
                                    }
                                });
                                
                            }else {
                                res.json({kq : 0, errMsg : "Password is incorrect "});
                            }
                        });
                    }
                }
            }
        );
    });
    
}
function randomNumber(index){
    const arrString = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "0","1","2", "3","4","5","6","7","8","9"];
    var kq = "";
    for (let i = 0; i <= index; i++) {
        kq = kq + arrString[ Math.floor(Math.random()*arrString.length) ]
    }
    return kq; 
}
