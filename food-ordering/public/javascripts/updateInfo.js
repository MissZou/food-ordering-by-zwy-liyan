$(document).ready(function() {

    $(".myaddress").addClass("focus");
    var winHeight=$(window).height();
    var winWidth=$(window).width();

    $(".addressdialog").css({"left":(winWidth-790)/2+ 'px',"top":(winHeight-412)/2+ 'px'});

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

    $("#save").on("click", function() {  //save new address
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
        console.log(notEmpty)
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
                    //parent.fadeOut();
                     location.reload();
                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("删除失败");
                }
            }
        });
    });


    $("#updateBtn").on("click", function() {
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
        console.log(notEmpty)
        if(notEmpty){
            return false;
        }
        $.ajax({
            url: '/user/account/address',
            type: 'POST',
            data: {
                "name": $("#username").val(),
                "phone": $("#phone").val(),
                "type": $("#type").val(),
                "address": $("#address").val(),
                "addrId": $("#addr_id").val()
            },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功hahaha");
                    var currentUpdate=$(".desktop-addressblock").eq(+$("#index").val());
                    currentUpdate.find(".desktop-addressblock-name").text($("#username").val());
                    currentUpdate.find(".desktop-addressblock-mobile").text($("#phone").val());
                    currentUpdate.find(".type").text($("#type").val());
                    currentUpdate.find(".desktop-addressblock-address").text($("#address").val());
                    currentUpdate.find(".addr_id").text($("#addr_id").val());

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
    $(".addressdialog-close").on("click", function() {
        $(this).parent().hide();
        $(".mask").hide();
    });
    $(".addressform-buttons").find("button").last().on("click", function() {
        $(this).parents(".addressdialog").hide();
        $(".mask").hide();
    });
    $(".update").live("click", function() {
        $(".mask").show();
        $("#updateBtn").show();
        $("#save").hide();
        $(".addressdialog").show();
        var parent = $(this).parents(".desktop-addressblock");
        console.log(parent.index())
        $("#username").val(parent.find(".desktop-addressblock-name").text());
        $("#phone").val(parent.find(".desktop-addressblock-mobile").text());
        $("#type").val(parent.find(".type").text());
        $("#address").val(parent.find(".desktop-addressblock-address").text());
        $("#addr_id").val(parent.find(".addr_id").val());
        $("#index").val(parent.index())

    });
    $(".desktop-addressblock.desktop-addressblock-addblock").on("click", function() {
        $(".mask").show();
        $("#username").val("");
        $("#phone").val("");
        $("#type").val("");
        $("#address").val("");
        $("#addr_id").val("");
        $("#index").val("")
        $("#updateBtn").hide();
        $("#save").show();
        $(".addressdialog").show();
    });
    function ifAllEmpty(){
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
        console.log(notEmpty)
        if(notEmpty){
            return false;
        }
    }
})
