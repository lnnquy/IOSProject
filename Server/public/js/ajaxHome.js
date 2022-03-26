$(document).ready(function(){
    var url = "http://localhost:3000";
    $.post(url+"/totalPosts",function(data){
        if(data.kq==1){
            console.log(data);
            $("#totalPost").html(data.countPost);
        }else {
            console.log("Count Total Post fail");
        }
    });
    $.post(url+"/countPostsByDateNow",function(data){
        if(data.kq==1){
            console.log(data);
            $("#numberPostDate").html(data.countPost);
        }else {
            console.log("Count New Post fail");
        }
    });
    $.post(url+"/totalUsers",function(data){
        if(data.kq==1){
            console.log(data);
            $("#totalUser").html(data.countUser);
        }else {
            console.log("Count Total User fail");
        }
    });
    $.post(url+"/countUsersByDateNow",function(data){
        if(data.kq==1){
            console.log(data);
            $("#numberUserDate").html(data.countUser);
        }else {
            console.log("Count New User fail");
        }
    });

});