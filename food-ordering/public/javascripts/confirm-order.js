$(function() {
    var winHeight=$(window).height();
    var winWidth=$(window).width();

    $(".addressdialog").css({"left":(winWidth-790)/2+ 'px',"top":(winHeight-412)/2+ 'px'});
    if (localStorage.getItem('orderList')) {
        var orderList = localStorage.getItem('orderList');
        console.log(JSON.parse(orderList))
        var orderListArr = JSON.parse(orderList)
        var markup = '<li> \
                    <div class="checkoutcart-tablerow"> \
                        <div class="cell itemname" title=${dishName}> ${dishName}</div> \
                        <div class="cell itemquantity"> ${num} </div> \
                        <div class="cell itemtotal">${price}</div> \
                        <input type="hidden" value=${dishId}> \
                    </div> \
                </li>';

        $.template("orderTemplate", markup);

        // Render the template with the movies data and insert
        // the rendered HTML under the "movieList" element
        $.tmpl("orderTemplate", orderListArr)
            .appendTo(".checkoutcart-group");
        $(".checkoutcart-total .num").text(localStorage.getItem('totalPrice'));
        $(".checkoutcart-totalextra span").text(orderListArr.length);
    }
    var socket = io();
    var id = localStorage.getItem("shopId");
    var userId=localStorage.getItem('accountId')
   // console.log(id)

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

    $(".addressdialog-close").on("click", function() {
        $(this).parent().hide();
        $(".mask").hide();
    });
    $(".checkout-noaddress").on("click", function() {
        $(".mask").show();
        $(".addressdialog").show();
    });

    $(".btn-stress").on("click", confirmOrder);

    $(".desktop-addressblock").on("click",function(){
        $(this).addClass("active").siblings().removeClass("active");
    })

      $(".checkout-pay").on("click",function(){
        $(this).addClass("active").siblings().removeClass("active");
    })

    $(".addressform-buttons").find("button").eq(1).on("click", function() {
        $(this).parents(".addressdialog").hide();
        $(".mask").hide();
    });

    $(".addressform-buttons").find("button").eq(0).on("click", function() {  //save new address
        //check if empty
        var errorCount=0;
         $(".addressform input").each(function(index, val) {
        if ($(this).val().trim() === "") {
            errorCount++;
        }
    });
         if(errorCount!=0){
                    $(".addressform").find("input").each(function(){
        if($(this).val().trim()==""){
            $(this).parent().addClass("validate-error");
            $(this).siblings(".addressformfield-hint").show();
        }else{
             $(this).parent().removeClass("validate-error");
            $(this).siblings(".addressformfield-hint").hide();
        }
      })
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
                    location.reload();
                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
    });
 $(".desktop-addressblock").last().click();
    function confirmOrder() {
       /* console.log(id)
        console.log(localStorage.getItem('accountId'))*/
        var dishli=$(".checkoutcart-group li");
        var address={};
        var currentAddress=$(".desktop-addressblock.active");
        address.name=currentAddress.find(".desktop-addressblock-name").text();
        address.addr=currentAddress.find(".desktop-addressblock-address").text();
        address.phone=currentAddress.find(".desktop-addressblock-mobile").text();
        console.log("shopId",id)
        var dishs=[];
        for(var i=0;i<dishli.length;i++){
            var dishObj={};
            dishObj.itemId=dishli.eq(i).find("input[type='hidden']").val();
            dishObj.amount=+dishli.eq(i).find(".itemquantity").text();
            dishs.push(dishObj);
        }
        console.log("dishs",dishs);
        console.log("address",address)
        $.ajax({
            url: '/user/account/order',
            type: 'PUT',
            data: {"shopId":id,
                    "dishs":dishs,
                    "price":+$(".num").text(),
                    "address":address,
                    "message":"liuyan"},
            success: function(data, status) {
             if(data.success){
                console.log(data.order)
             }
            }
        });

        socket.emit('set nickname',userId)
        socket.emit('say to someone', id, "Someone orders!"); //to id
    }
})