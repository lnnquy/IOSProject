$(document).ready(function(){
    
    var url = "http://localhost:3000";
    
    $.post(url + "/city",function(data2){
        $("#city_List").html("");
        data2.CityList.forEach(function(city){
            $("#city_List").append(`
                <li class="city" cityID="`+city._id+`">` +city.Name+ `</li>
            `);
        });
    });
    $(document).on("click",".city",function(){
        var Name = $(this).html();
        var idCity = $(this).attr("cityID");
        $("#currentName").val(Name);
        $("#hid_cityID").val(idCity)
    });
    $("#btn_UpdateCity").click(function(){
        $.post(url+"/city/update",{
            id:$("#hid_cityID").val(),
            Name:$("#newCityName").val()
        },function(data){
            if(data.kq == "1") {
                alert("Update thành công");
                $("#currentName").val("");
                $("#newCityName").val("");
                $.post(url + "/city",function(data2){
                    $("#city_List").html("");
                    data2.CityList.forEach(function(city){
                        $("#city_List").append(`
                            <li class="city" cityID="`+city._id+`">` +city.Name+ `</li>
                        `);
                    });
                });
            }else {
                alert("Update thất bại");
            }
            
        });
    });
    $("#btn_DeleteCity").click(function(){
        var chon = confirm("Bạn có chắc chắn muốn xóa Thành Phố "+$("#currentName").val());
        if(chon) {
            $.post(url+"/city/delete",{
                id:$("#hid_cityID").val()
            },function(data){
                if(data.kq == "1") {
                    alert("Delete thành công");
                    $("#currentName").val("");
                    $("#newCityName").val("");
                    $.post(url + "/city",function(data2){
                        $("#city_List").html("");
                        data2.CityList.forEach(function(city){
                            $("#city_List").append(`
                                <li class="city" cityID="`+city._id+`">` +city.Name+ `</li>
                            `);
                        });
                    });
                }else {
                    alert("Delete thất bại");
                }
                
            });
        }
        
    });
});