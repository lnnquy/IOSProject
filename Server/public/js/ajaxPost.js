$(document).ready(function(){
    const url = "http://localhost:3000/";
    $.post("/listPosts",function(data){
        console.log(data);
        data.list.forEach(function(post) {
            $("#date").append(`<li>`+post.PostDate+`</li>`);
            $("#title").append(`<li>`+post.Title+`</li>`);
            
            if(post.Active == true) {
                $("#status").append(`<li>Đang bán</li>`);
            }else {
                $("#status").append(`<li>Đã bán</li>`);
            }
            $("#user").append(`<li>`+post.User+`</li>`);
            $("#action").append(`<li><a href="#">Block</a> | <a href="#">Delete</a></li>`);
        });
    });
});