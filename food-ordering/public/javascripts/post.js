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
        },
        addCoverPic: function(file) {
            $(".preview-coverPic").empty();
            var imageType = /^image\//;
            /*if (!imageType.test(file.type)) {
                continue;
            }*/
            var reader = new FileReader();
            reader.onload = function(e) {
                $('<img src=' + e.target.result + ' alt="" width="200" >')
                    .appendTo($(".preview-coverPic"));
            };
            reader.readAsDataURL(file);
        }
    };

    var uploadBtn = $(".uploadPic");
    uploadBtn.on("change", function() {
        uploadPic.add(this.files);
    });


    $(".coverPic").on("change", function() {
        uploadPic.addCoverPic(this.files[0]);
    })

    $(".uploadPicBtn").on("click", function() {
        uploadBtn[0].click();
    });


    $("#articlePostBtn").on("click", function() {
        $.ajax({
            url: '/shop/create/',
            type: 'POST',
            data: {
                "shopName": $("#shopName").val(),
                "location": $("#location").val(),
                "shopPicUrl": $("#shopPicUrl").val(),
                "open": $("#open").val() == "" ? false : true,
                "shopType": $(".typeResult").text().trim()
            },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                    console.log(data)
                    var data = new FormData();
                    data.append('file', $(".coverPic")[0].files[0]);
                    data.append('shopName', $("#shopName").val());
                    $.ajax({
                        url: '/shop/createCover/',
                        data: data,
                        type: 'POST',
                        contentType: false, //必须
                        processData: false, //必须
                        success: function(data, status) {
                            if (data.code == 200) {
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

                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
        var dish = []
        var num = $(".dishPreview li").length;
        for (var index = 0; index < num; index++) {
            var tags = []
            for (var i = 0; i < $(".dishPreview li").eq(index).find(".tag-wrp").length; i++) {
                tags.push($(".dishPreview li").eq(index).find(".tag").eq(i).text())
            }
            dish[index]={}
            dish[index].dishName = $(".dishName").eq(index).val();
            dish[index].tags =tags;
            dish[index].price=$(".price").eq(index).val();
            dish[index].intro=$(".intro").eq(index).val();
        }

        
        //data.append('shopDish', dish);
        //data.append('shopName', $("#shopName").val());
        $.ajax({
            url: '/shop/createDish/',
            data: {
                "dish":dish,
                "shopName":$("#shopName").val()
            },
            type: 'POST',
            //contentType: false,
            //processData: false, 
            success: function(data, status) {
                if (data.code == 200) {
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
        var data = new FormData();
        data.append('file', $(".uploadPic")[0].files);
        data.append('shopName', $("#shopName").val());
        $.ajax({
            url: '/shop/createDishPic/',
            data: data,
            type: 'POST',
            contentType: false,
            processData: false, 
            success: function(data, status) {
                if (data.code == 200) {
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

    $(".type li").on("click", function(e) {
        e.stopPropagation()
        if ($(this).find("ul").length == 0) {
            $(".typeResult").text($(this).text())
        }
    });

    $(".delete").live("click", tagAction.remove);
    $("input[type='text']").live("keydown", function(event) {
        if (event.keyCode == 13) {
            tagAction.add(this);
            return false;
        }
    })
})
