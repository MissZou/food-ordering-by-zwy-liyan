$(function() {
    var tagAction = {
        remove: function() {
            $(this).parent(".tag-wrp").remove();
        },
        add: function(self) {
            var content = $(self).val().trim();
            if (content !== "") {
                var newTag = "<div class='tag-wrp'><span class='tag'>" + content +
                    "</span><span class='delete'>×</span></div>";
                $(self).parent().find($(".labels")).append(newTag);
            }
            $(self).val("");
        }
    };

    var uploadPic = {
        add: function(files) {
            var len = files.length > 9 ? 9 : files.length;
            for (var i = 0; i < len; i++) {
                var file = files[i];
                var imageType = /^image\//;
                if (!imageType.test(file.type)) {
                    continue;
                }
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('<li><img src=' + e.target.result + ' alt=""> \
                        <label>Dish name</label> \
                        <input type="text" class="dishName"> \
                        <label>Tags</label> \
                        <input type="text" class="tagInput"> \
                        <div class="labels"> \
                            <div class="tag-wrp"> \
                                <span class="tag">shmhsm</span> \
                                <span class="delete">×</span> \
                            </div> \
                        </div> \
                        <label>Price</label> \
                        <input type="number" class="price"> \
                        <label>Introduction</label> \
                        <textarea class="intro" cols="30" rows="10"></textarea></li>')
                        .appendTo($(".dishPreview ul"));
                };
                reader.readAsDataURL(file);
            }
        }
    };

    var uploadBtn = $(".uploadPic");
    uploadBtn.on("change", function() {
        uploadPic.add(this.files);
    });


    $(".uploadPicBtn").on("click", function() {
        uploadBtn[0].click();
    });

$(document).on("click", "#post button", function() {
        var dish = []
        var num = $(".dishPreview li").length;
        for (var index = 0; index < num; index++) {
            var tags = []
            for (var i = 0; i < $(".dishPreview li").eq(index).find(".tag-wrp").length; i++) {
                tags.push($(".dishPreview li").eq(index).find(".tag").eq(i).text())
            }
            dish[index] = {}
            dish[index].dishName = $(".dishName").eq(index).val();
            dish[index].tags = tags;
            dish[index].price = $(".price").eq(index).val();
            dish[index].intro = $(".intro").eq(index).val();
            dish[index].index = index;
        }

        //data.append('shopDish', dish);
        //data.append('shopName', $("#shopName").val());
        $.ajax({
            url: '/shop/account/createDish',
            data: {
                "dish": dish
            },
            type: 'POST',
            //contentType: false,
            //processData: false, 
            success: function(data, status) {
                if (data.code == 200) {
                    alert("上传成功");
                    var data = new FormData();
                    $.each($(".uploadPic")[0].files, function(i, file) {
                        data.append(i, file);
                        //console.log('photo['+i+']', file)
                    })
                    data.append('shopName', $("#shopName").val());
                    for(var i=0;i<dish.length;i++){
                    	data.append('dishNames'+i,dish[i].dishName);
                    }
                 /*   data.append('dishNames',dish);*/
                    console.log(dish)
                    $.ajax({
                        url: '/shop/account/createDishPic/',
                        data: data,
                        type: 'POST',
                        contentType: false,
                        processData: false,
                        success: function(data, status) {
                            if (data.code == 200) {
                                alert("上传成功");
                            }else{
                            	console.log(data)
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

$(document).on("click", ".delete", tagAction.remove);
$(document).on("keydown", "input[type='text']",function(event) {
        if (event.keyCode == 13) {
            tagAction.add(this);
            return false;
        }
    });
})
