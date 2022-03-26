$(document).ready(function(){
    const url = "http://localhost:3000";

    $.post(url+"/category/list",function(data){
        if(data.kq==1){
            $("#cate_List").html("");
            data.CateList.forEach(function(cate){
                $("#cate_List").append(`
                <li class="cate" srcImage="`+cate.Image+`" idCate="`+cate._id+`">`+cate.Name+`</li>
                `);
            });
        }else {
            console.log("List fail");
        }
    });
    $(document).on("click",".cate",function(){
        $("#currentImage").attr("src",url+"/upload/"+$(this).attr("srcImage"));
        $("#hid_currentImage").val($(this).attr("srcImage"));
        $("#currentName").val($(this).html());
        $("#hid_IdCate").val($(this).attr("idCate"));
    });
    $("#fileImage").change(function(){
        var data = new FormData();
            jQuery.each(jQuery('#fileImage')[0].files, function(i, file) {
                console.log('avatar'+i);
                data.append('avatar', file);
            });

            jQuery.ajax({
                url: url+'/uploadFile',
                data: data,
                cache: false,
                contentType: false,
                processData: false,
                method: 'POST',
                type: 'POST', // For jQuery < 1.9
                success: function(data){
                    if(data.kq==1){
                        $("#cateImage").attr("src",url+`/upload/`+data.urlFile.filename);
                        $("#hid_nameImage").val(data.urlFile.filename);
                    }else{
                        console.log("Upload fail!");
                    }
                }
            });
    });
    $("#btn_AddCate").click(function(){
        if($("#hid_nameImage").val().length == 0 || $("#cateName").val().length == 0) {
            alert("Vui lòng nhập Tên và chọn Hình Ảnh");
        }else {
            $.post(url+"/category/add",{
                name:$("#cateName").val(),
                image:$("#hid_nameImage").val()
            },function(data){
                if(data.kq==1){
                    alert("Thêm Category thành công. ");
                    $.post(url+"/category/list",function(data){
                        if(data.kq==1){
                            $("#cate_List").html("");
                            data.CateList.forEach(function(cate){
                                $("#cate_List").append(`
                                <li class="cate" srcImage="`+cate.Image+`" idCate="`+cate._id+`">`+cate.Name+`</li>
                                `);
                            });
                        }else {
                            console.log("List fail");
                        }
                    });
                    $("#cateImage").attr("src","");
                    $("#cateName").val("")
                    $("#hid_nameImage").val("")
                    $("#fileImage").val("");
                }else {
                    alert("Thêm Category thất bại. ");
                }
            });
        }   
    });
    $("#newFileImage").change(function(){
        var data = new FormData();
            jQuery.each(jQuery('#newFileImage')[0].files, function(i, file) {
                console.log('avatar'+i);
                data.append('avatar', file);
            });

            jQuery.ajax({
                url: url+'/uploadFile',
                data: data,
                cache: false,
                contentType: false,
                processData: false,
                method: 'POST',
                type: 'POST', // For jQuery < 1.9
                success: function(data){
                    if(data.kq==1){
                        $("#currentImage").attr("src",url+`/upload/`+data.urlFile.filename);
                        $("#hid_newImage").val(data.urlFile.filename);
                    }else{
                        console.log("Upload fail!");
                    }
                }
            });
    });
    $("#btn_UpdateCate").click(function(){
        if($("#hid_IdCate").val().length == 0) {
            alert("Vui lòng chọn 1 Category ở list trên.");
        }else {
            var image = $("#hid_newImage").val();
            var name = $("#newName").val();
            if(image.length == 0) {
                image = $("#hid_currentImage").val()
            }
            if(name.length == 0) {
                name = $("#currentName").val()
            }
            $.post(url+"/category/update",{
                id:$("#hid_IdCate").val(),
                name:name,
                image:image
            },function(data){
                if(data.kq==1){
                    alert("Update Category thành công. ");
                    $.post(url+"/category/list",function(data){
                        if(data.kq==1){
                            $("#cate_List").html("");
                            data.CateList.forEach(function(cate){
                                $("#cate_List").append(`
                                <li class="cate" srcImage="`+cate.Image+`" idCate="`+cate._id+`">`+cate.Name+`</li>
                                `);
                            });
                        }else {
                            console.log("List fail");
                        }
                    });
                    $("#currentImage").attr("src","");
                    $("#currentName").val("");
                    $("#newFileImage").val("");
                    $("#newName").val("");
                    $("#hid_newImage").val("");
                    $("#hid_IdCate").val("");
                }else {
                    alert("Update Category thất bại. ");
                }
            });
        }   
    });
    $("#btn_DeleteCate").click(function(){
        if($("#hid_IdCate").val().length == 0) {
            alert("Vui lòng chọn 1 Category ở list trên.");
        }else {
            var chon = confirm("Bạn có chắc chắn muốn xóa Category : " + $("#currentName").val());
            if(chon) {
                $.post(url+"/category/delete",{
                    id:$("#hid_IdCate").val()
                },function(data){
                    if(data.kq==1){
                        alert("Delete Category thành công. ");
                        $.post(url+"/category/list",function(data){
                            if(data.kq==1){
                                $("#cate_List").html("");
                                data.CateList.forEach(function(cate){
                                    $("#cate_List").append(`
                                    <li class="cate" srcImage="`+cate.Image+`" idCate="`+cate._id+`">`+cate.Name+`</li>
                                    `);
                                });
                            }else {
                                console.log("List fail");
                            }
                        });
                        $("#currentImage").attr("src","");
                        $("#currentName").val("");
                        $("#newFileImage").val("");
                        $("#newName").val("");
                        $("#hid_newImage").val("");
                        $("#hid_IdCate").val("");
                    }else {
                        alert("Delete Category thất bại. ");
                    }
                });
            }
            
        }   
    });
});