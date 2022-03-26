$(document).ready(function(){
    const url = "http://localhost:3000/";
    $.post("/listUsers",function(data){
        data.list.forEach(function(user) {
            $("#date").append(`<li>`+user.RegisterDate+`</li>`);
            $("#email").append(`<li>`+user.Email+`</li>`);
            $("#phone").append(`<li>`+user.Phone+`</li>`);
            $("#active").append(`<li>`+user.Active+`</li>`);
            $("#action").append(`<li><a href="#">Block</a> | <a href="#">Delete</a></li>`);
        });
    });
});