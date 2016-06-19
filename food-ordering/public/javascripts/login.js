$(document).ready(function() {
    var winWidth = $(window).width(),
        winHeight = $(window).height(),
        loginFormLeft = (winWidth - 570) / 2,
        loginFormHeight = (winHeight - $(".loginForm").height()) / 2;
    $("#signup_button").on("click", addUser);
    $("#login_button").on("click", login);
    $("#loginForm").on("click", loginForm);
    $(".loginForm .close").on("click", function() {
        $(".mask").hide();
        $(".loginForm").hide();
    });
    $(".forgetPassBtn").on("click",function(){
        var email=$("#forgetPass").val();
        $.ajax({
            url: '/user/forgetpassword',
            type: 'post',
            data: {"email":email},
            success: function(data, status) {
                if (data== 400) {
                    alert("填写错误");
                    
                } else if (data == 404) {
                    alert("无该地址");
                }else{
                    alert("发送成功")
                }
            }
        });
    });

    function loginForm() {
        $(".mask").show();
        $(".loginForm").css({ "left": loginFormLeft, "top": loginFormHeight, "position": "fixed" }).show();
    }
});


function login(e) {
    e.preventDefault();
    var errorCount = 0;

    $("#loginUser input").each(function(index, val) {
        if ($(this).val() === "") {
            errorCount++;
        }
    });

    if (errorCount !== 0) {
        alert("把空格填完")
        return false;
    } else {

        var loginEmail = $("#user_loginemail").val();
        var loginpassword = $("#user_loginpassword").val();
        var data = {
            "email": loginEmail,
            "password": loginpassword
        };
        $.ajax({
            url: '/user/login',
            type: 'post',
            data: data,
            success: function(data, status) {
                if (data.code == 200) {
                    alert("登录成功");
                    localStorage.setItem('accountId', data.accountId);
                    window.location = "/user/account/index";
                } else if (data.code == 400) {
                    alert("登录失败");
                }
            }
        });
    }
}

function addUser(e) {
    e.preventDefault();

    //如果有空格就+1
    var errorCount = 0;
    $("#new-user input").each(function(index, val) {
        if ($(this).val() === "") {
            errorCount++;
        }
    });


    if (errorCount === 0) {
        var newUser = {
            'name': $('#user_name').val(),
            'email': $('#user_email').val(),
            'password': $('#user_password').val(),
            'phone': $('#user_phone').val(),
            'address': $('#user_address').val()
        };

        $.ajax({
            type: "PUT",
            data: newUser,
            url: "/user/register",
            success: function(data, status) {
                if (data.success == true) {
                    alert("注册成功、。。。")
                }else{
                    alert("您已使用过此邮箱！")
                }
            },
            error: function(data, err) {
                alert("注册失败")
            }
        })


    } else {
        alert("填完空格啊");
        return false;
    }
}
