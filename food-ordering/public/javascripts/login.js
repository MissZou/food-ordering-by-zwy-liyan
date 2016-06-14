$(document).ready(function() {
    var winWidth=$(window).width();
    var loginFormLeft=(winWidth-570)/2;
    $("#signup_button").on("click", addUser);
    $("#login_button").on("click", login);
    $("#loginForm").on("click",loginForm);

function loginForm(){
    alert("login")
    //var loginFormLeft=(winWidth-570)/2;
    $(".mask").show();
$(".loginForm").css({"left":loginFormLeft}).show();
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

    if(errorCount!==0){
    	alert("把空格填完")
    	return false;
    }else{

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
            if (data.code==200) {
                alert("登录成功");
                localStorage.setItem('accountId',data.accountId);
               window.location="/user/upload";
            }else if (data.code==400){
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
            'password':$('#user_password').val(),
            'phone':$('#user_phone').val(),
            'address':$('#user_address').val()
        };

        $.ajax({
            type: "PUT",
            data: newUser,
            url: "/user/register",
            success: function(data, status) {
                if (status == "success") {
                    alert("注册成功、。。。")
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
