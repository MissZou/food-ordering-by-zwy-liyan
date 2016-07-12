$(function() {
    $("#save").on("click", function() { //save new address
    	var notEmpty=false;
    	$(".addressformfield").find("input").each(function() {
            if ($(this).val() == "") {
               $(this).parent().addClass("validate-error");
               $(this).siblings(".addressformfield-hint").show();
               notEmpty=true;
            }else{
            	$(this).parent().removeClass("validate-error");
               $(this).siblings(".addressformfield-hint").hide();
            }
        })

        if(notEmpty){
        	return false;
        }

        $.ajax({
            url: '/user/account/address',
            type: 'PUT',
            data: {
                "name": $("#username").val(),
                "phone": $("#phone").val(),
                "type": $("#type").val(),
                "address": $("#address").val()
            },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
    })
})
