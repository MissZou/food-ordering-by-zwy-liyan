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
        alert("Please fill in all the blanks!")
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
                    localStorage.setItem('accountId', data.accountId);
                    window.location = "/user/account/web/index/m";
                } else if (data.code == 400) {
                    alert("Login failure");
                }
            }
        });
    }
}

})