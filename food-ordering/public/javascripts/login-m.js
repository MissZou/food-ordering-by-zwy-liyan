$(function(){
	$("#login_button").on("click", login);
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

})