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
                   // console.log(data.address)
                    $('<li class="address">  \
                    <div class="delete">delete</div> \
                    <div class="update">update</div> \
                    <p class="name">'+newAddr.name+'</p> \
                    <p class="type">'+newAddr.type+'</p> \
                    <p class="phone">'+newAddr.phone+'</p> \
                    <p class="addr">'+newAddr.addr+'</p> \
                    <input type="hidden" value='+newAddr._id+' class="addr_id"> \
                    </li>').appendTo("ul")
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
        var parent = $(this).parent();
        $.ajax({
            url: '/user/account/address',
            type: 'DELETE',
            data: {
                "name": parent.find(".name").text(),
                "phone": parent.find(".phone").text(),
                "type": parent.find(".type").text(),
                "address": parent.find(".addr").text()
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

})
