$(function(){
for(var i=0;i<$(".userName").length;i++){

        (function(i){
        	$.ajax({
            type: "GET",
            data: {"userId":$(".userName").eq(i).text()},
            url: "/user/account/web/username",
            success: function(data, status) {
                if (data.success == true) {
                    if(data.username){

                    $(".userName").eq(i).text(data.username)
                }else{
                	$(".userName").eq(i).text("XXX")
                }
                }else{
                    
                }
            },
            error: function(data, err) {
                
            }
        })
    })(i)

    }
})