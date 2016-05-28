$(function() {

    var uploadPic = {
       
        addCoverPic: function(file) {
            $(".preview-coverPic").empty();
            var imageType = /^image\//;
            
            var reader = new FileReader();
            reader.onload = function(e) {
                $('<img src=' + e.target.result + ' alt="" width="200" >')
                    .appendTo($(".preview-coverPic"));
            };
            reader.readAsDataURL(file);
        }
    };

    $(".coverPic").on("change", function() {
        uploadPic.addCoverPic(this.files[0]);
    })


    $("#articlePostBtn").on("click", function() {
        $.ajax({
            url: '/shop/register/',
            type: 'POST',
            data: {
                "email":$("#email").val(),
                "password":$("#password").val(),
                "shopName": $("#shopName").val(),
                "location": $("#location").val(),
                "address": $("#address").val(),
                "open": $("#open").val() == "" ? false : true,
                "shopType": $(".typeResult").text().trim()
            },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                    var formData = new FormData();
                    formData.append('file', $(".coverPic")[0].files[0]);
                    formData.append('shopName', $("#shopName").val());
                    formData.append('shopId', data.shop._id);
                    $.ajax({
                        url: '/shop/createCover/',
                        data: formData,
                        type: 'POST',
                        contentType: false, //必须
                        processData: false, //必须
                        success: function(data, status) {
                            if (data.code == 200) {
                                alert("上传成功");
                                console.log(data)
                                window.location="/shop/login";
                            }
                        },
                        error: function(data, status) {
                            if (data.code != 200) {
                                alert("上传shibai");
                            }
                        }
                    });

                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
 

    })

    $(".type li").on("click", function(e) {
        e.stopPropagation()
        if ($(this).find("ul").length == 0) {
            $(".typeResult").text($(this).text())
        }
    });

})
