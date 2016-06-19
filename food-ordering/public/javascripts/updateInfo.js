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

    $("#save").on("click", function() {
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
                    console.log(data)
                    var newAddr=data.address[data.address.length-1];
                   $('<div class="desktop-addressblock"> \
                    <div class="desktop-addressblock-buttons"> \
                    <button class="desktop-addressblock-button update">修改</button> \
                    <button class="desktop-addressblock-button delete">删除</button> \
                    </div><div class="desktop-addressblock-name">'+newAddr.name+'</div> \
                    <div class="desktop-addressblock-address">'+newAddr.addr+'</div> \
                    <div class="desktop-addressblock-mobile">'+newAddr.phone+'</div> \
                    <div class="type">'+newAddr.type+'</div> \
                    <input type="hidden" value='+newAddr._id+'class="addr_id"></div>').insertBefore(".desktop-addressblock.desktop-addressblock-addblock");
                $(".addressdialog").hide();
        $(".mask").hide();
                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
    })


    $(".delete").live("click", function() {
        var parent = $(this).parents(".desktop-addressblock");
        console.log(parent)
        $.ajax({
            url: '/user/account/address',
            type: 'DELETE',
            data: {
                "name": parent.find(".desktop-addressblock-name").text(),
                "address": parent.find(".desktop-addressblock-address").text(),
               "type": parent.find(".type").text(),
                "phone": parent.find(".desktop-addressblock-mobile").text()
            },
            success: function(data, status) {
                if (data.success == true) {
                    parent.fadeOut();
                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("删除失败");
                }
            }
        });
    });


    $(".update").live("click", function() {
        var parent = $(this).parent();
        $("#usernamee").val(parent.find(".name").text());
        $("#phonee").val(parent.find(".phone").text());
        $("#typee").val(parent.find(".type").text());
        $("#addresse").val(parent.find(".addr").text());
        $("#addr_id").val(parent.find(".addr_id").val());
    });


    $("#updExistingAddr button").on("click", function() {
        $.ajax({
            url: '/user/account/address',
            type: 'POST',
            data: {
                "name": $("#usernamee").val(),
                "phone": $("#phonee").val(),
                "type": $("#typee").val(),
                "address": $("#addresse").val(),
                "addrId": $("#addr_id").val()
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

    $(".addressdialog-close").on("click", function() {
        $(this).parent().hide();
        $(".mask").hide();
    });
    $(".addressform-buttons").find("button").eq(1).on("click", function() {
        $(this).parents(".addressdialog").hide();
        $(".mask").hide();
    });
    $(".update").on("click", function() {
        $(".mask").show();
        $(".addressdialog").show();
    });
    $(".desktop-addressblock.desktop-addressblock-addblock").on("click", function() {
        $(".mask").show();
        $(".addressdialog").show();
    });

})
