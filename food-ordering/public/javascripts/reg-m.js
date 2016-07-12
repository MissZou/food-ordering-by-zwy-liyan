$(function() {
    var emailVerify = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
    $("input").on("input", function() {
        var notEmpty = true;
        $("input").each(function() {
            if ($(this).val() == "") {
                notEmpty = false
            }
        })

        if (notEmpty) {
            $("button").removeAttr("disabled");
        } else {
            $("button").attr("disabled", "disabled");
        }
    })

    $("button").on("click", function() {
        if (emailVerify.test($(".email").val())) {
            $(".input-group").eq(1).removeClass("ui_error");
            var inputGroup=$(".ui-input");
            var newUser = {
            'name': inputGroup.eq(0).val(),
            'email': inputGroup.eq(1).val(),
            'password':inputGroup.eq(2).val(),
            'phone':inputGroup.eq(3).val(),
            'address':inputGroup.eq(4).val()
        };

        $.ajax({
            type: "PUT",
            data: newUser,
            url: "/user/register",
            success: function(data, status) {
                if (data.success == true) {
                    alert("注册成功、。。。")
                    window.location="/user/login/web/m";
                }else{
                    alert("您已使用过此邮箱！")
                }
            },
            error: function(data, err) {
                alert("注册失败")
            }
        })

        } else {
            console.log("noo")
            $(".input-group").eq(1).addClass("ui_error");
        }
    });
})