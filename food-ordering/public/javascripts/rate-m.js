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
    $(".userName").show();
    }

    
    $(".menuTab").on("click",function(){
        var shopId=location.href.split("/")[7];
        window.location="/user/account/web/cart/"+shopId+"/m";
    })

    $(".infoTab").on("click",function(){
        var shopId=location.href.split("/")[7];
        window.location="/user/account/web/info/"+shopId+"/m";
    })
})