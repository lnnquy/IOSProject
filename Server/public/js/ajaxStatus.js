$(document).ready(function(){
    var url = "http://localhost:3000";
    
    $.post(url + "/status/list",function(data){
        $("#status_List").html("");
        data.StatusList.forEach(function(status){
            $("#status_List").append(`
                <li class="status" details="`+status.Details+`" statusID="`+status._id+`">` +status.Name+ `</li>
            `);
        });
    });
    //Add new
    $("#btn_AddNewStatus").click(function(){
        $.post(url+"/status/add",{name:$("#statusName").val(),details:$("#statusDetails").val()},function(data){
            console.log(data);
            if(data.kq == 1) {
                alert("Thêm status mới thành công. ");
                $("#statusName").val("");
                $("#statusDetails").val("");
                $.post(url + "/status/list",function(data){
                    $("#status_List").html("");
                    data.StatusList.forEach(function(status){
                        $("#status_List").append(`
                            <li class="status" details="`+status.Details+`" statusID="`+status._id+`">` +status.Name+ `</li>
                        `);
                    });
                });
            }else {
                console.log(data);
            }
        });
        
    });
    $(document).on("click",".status",function(){
        var Name = $(this).html();
        var Details = $(this).attr("details");
        var idStatus = $(this).attr("statusID");
        $("#currentName").val(Name);
        $("#newDetails").val(Details);
        $("#hid_statusID").val(idStatus)
    });
    $("#btn_UpdateStatus").click(function(){
        if($("#hid_statusID").val().length == 0) {
            alert("Vui lòng chọn status. ");
        }else {
            var newName = $("#newStatusName").val()
            if ( newName.length == 0 ) {
                newName = $("#currentName").val();
            }
            $.post(url+"/status/update",{
                id:$("#hid_statusID").val(),
                name: newName,
                details: $("#newDetails").val()
            },function(data){
                if(data.kq == "1") {
                    alert("Update thành công");
                    $("#hid_statusID").val("");
                    $("#currentName").val("");
                    $("#newStatusName").val("");
                    $("#newDetails").val("")
                    $.post(url + "/status/list",function(data){
                        $("#status_List").html("");
                        data.StatusList.forEach(function(status){
                            $("#status_List").append(`
                                <li class="status" details="`+status.Details+`" statusID="`+status._id+`">` +status.Name+ `</li>
                            `);
                        });
                    });
                }else {
                    alert("Update thất bại");
                }
                
            });
        }
    });
    $("#btn_DeleteStatus").click(function(){
        var chon = confirm("Bạn có chắc chắn muốn xóa Status "+$("#currentName").val());
        if(chon) {
            $.post(url+"/status/delete",{
                id:$("#hid_statusID").val()
            },function(data){
                if(data.kq == "1") {
                    alert("Delete thành công");
                    $("#currentName").val("");
                    $("#newStatusName").val("");
                    $.post(url + "/status/list",function(data){
                        $("#status_List").html("");
                        data.StatusList.forEach(function(status){
                            $("#status_List").append(`
                                <li class="status" details="`+status.Details+`" statusID="`+status._id+`">` +status.Name+ `</li>
                            `);
                        });
                    });
                }else {
                    alert("Delete thất bại");
                }
                
            });
        }
        
    });
})
