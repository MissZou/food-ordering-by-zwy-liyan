$(document).ready(function() {
    $("#updateInfo button").on("click", function() {
        $.ajax({
            url: '/user/account/location',
            type: 'PUT',
            data: { "location": $("#location").val() },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                    console.log(data.location)
                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
    });

	$("#updateAddress button").on("click", function() {
		$.ajax({
            url: '/user/account/address',
            type: 'PUT',
            data: { "name": $("#username").val(),
            "phone":$("#phone").val(),
            "type":$("#type").val(),
             "address":$("#address").val()
         },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                    console.log(data.doc)
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
