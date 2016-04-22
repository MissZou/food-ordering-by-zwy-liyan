$(function() {
    var tagAction = {
        remove: function() {
            $(this).parent(".tag-wrp").remove();
        },
        add: function() {
            var content = $("#label").val().trim();
            if (content !== "") {
                var newTag = "<div class='tag-wrp'><span class='tag'>" + content + 
                "</span><span class='delete'>×</span></div>";
                $(".labels").append(newTag);
            }
            $("#label").val("");
        }
    };

    var uploadPic = {
        add: function(files) {
        	var preview=$(".preview");
            preview.empty();
            var len=files.length>9? 9 :files.length;
            for (var i = 0; i < len; i++) {
                var file = files[i];
                var imageType = /^image\//;

                if (!imageType.test(file.type)) {
                    continue;
                }

                var img = document.createElement("img");
                img.classList.add("previewPic");
                img.file = file;
                // 假设 "preview" 是将要展示图片的 div
                
                preview[0].appendChild(img);
                var reader = new FileReader();
                reader.onload = (function(aImg) {
                    return function(e) {
                        aImg.src = e.target.result;
                    };
                })(img);
                reader.readAsDataURL(file);
            }
        }
    };



    var uploadBtn = $(".uploadPic");
    uploadBtn.on("change", function(){
    	uploadPic.add(this.files)
    });

    $(".uploadPicBtn").on("click",function(){
    	uploadBtn[0].click();
    });


$("#articlePostBtn").on("click",function(){
    $.ajax({
            url: '/shop/create/',
            type: 'POST',
            data: {
                "shopName": $("#shopName").val(),
                "location": $("#location").val(),
                "shopPicUrl": $("#shopPicUrl").val(),
                "open": $("#open").val()==""?false:true
            },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                    console.log(data)
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
