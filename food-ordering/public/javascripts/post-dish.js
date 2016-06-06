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
                var list = $('<li><img alt=""> \
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
                var img = list.find("img");
                list.appendTo($(".dishPreview ul"));

                var reader = new FileReader();
                reader.onload = (function(aImg) {
                    return function(e) {
                        aImg.attr("src",e.target.result);
                    };
                })(img);
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
            url: '/shop/account/dish',
            data: {
                "dish": dish
            },
            type: 'PUT',
            //contentType: false,
            //processData: false, 
            success: function(data, status) {
                if (data.code == 200) {
                    alert("上传成功");
                    console.log(data.dishes);
                    var originalDishes = data.dishes;
                    var newDishes = [];
                    for (var i = 0; i < originalDishes.length; i++) {
                        if (!originalDishes[i].dishPic) {
                            newDishes.push(originalDishes[i]._id);
                        }
                    }
                    console.log(newDishes)
                    var data = new FormData();
                    $.each($(".uploadPic")[0].files, function(i, file) {
                        data.append(i, file);
                        //console.log('photo['+i+']', file)
                    })
                    data.append('shopName', $("#shopName").val());
                    for (var i = 0; i < dish.length; i++) {
                        data.append('dishNames' + i, dish[i].dishName);
                        data.append('dishId' + i, newDishes[i]);
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
                            } else {
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
    $(document).on("keydown", "input[type='text']", function(event) {
        if (event.keyCode == 13) {
            tagAction.add(this);
            return false;
        }
    });
    var socket = io();


    socket.on('my message', function(msg) {
        // 首先，让我们检查我们是否有权限发出通知
        // 如果没有，我们就请求获得权限
        if (window.Notification && Notification.permission !== "granted") {
            Notification.requestPermission(function(status) {
                if (Notification.permission !== status) {
                    Notification.permission = status;
                }
            });
        }

        // 如果用户同意就创建一个通知
        if (window.Notification && Notification.permission === "granted") {
            var n = new Notification(msg);
        }

        // 如果用户没有选择是否显示通知
        // 注：因为在 Chrome 中我们无法确定 permission 属性是否有值，因此
        // 检查该属性的值是否是 "default" 是不安全的。
        else if (window.Notification && Notification.permission !== "denied") {
            Notification.requestPermission(function(status) {
                if (Notification.permission !== status) {
                    Notification.permission = status;
                }

                // 如果用户同意了
                if (status === "granted") {
                    var n = new Notification(msg);
                }

                // 否则，我们可以让步的使用常规模态的 alert
                else {
                    alert(msg);
                }
            });
        }

        // 如果用户拒绝接受通知
        else {
            // 我们可以让步的使用常规模态的 alert
            alert(msg);
        }

        $('body').append($('<li>').text(msg));
    });

})
