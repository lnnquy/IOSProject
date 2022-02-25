$(document).ready(function(){
    
    var url = "http://localhost:3000";
    
    $("#btn_AddNewCity").click(function(){
        $.post(url+"/city/add",{Name:$("#cityName").val()},function(data){
            console.log(data);
            if(data.kq == 1) {
                alert("Thêm thành phố mới thành công. ");
                $("#cityName").val("");
                $.post(url + "/city",function(data2){
                    $("#city_List").html("");
                    data2.CityList.forEach(function(city){
                        $("#city_List").append(`
                            <li class="city" cityID="`+city._id+`">` +city.Name+ `</li>
                        `);
                    });
                });
            }
        });
    });

});