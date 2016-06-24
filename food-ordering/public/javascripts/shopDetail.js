$(function() {

    var accountId=localStorage.getItem('accountId');
    var shopId=window.location.pathname.split("/")[5]; //非常不健壮
    $.ajax({
                url:'/user/account/favoriteshop',
                headers: {
                'index': 1,
                'count': 9999
                },
                type:"GET",
                success:function(data){
                    if(data.success){
                        console.log(data.favoriteshop);
                        for(var i=0;i<data.favoriteshop.length;i++){
                            if(data.favoriteshop[i].shopId._id==shopId){
                                $(".heart").click();
                            }
                        }
                    }
                }
            })
    localStorage.setItem('shopId',shopId);
    console.log("accountId",accountId)
    console.log("shopId",shopId)
    var shopmenuNav = $(".shopmenu-nav");
    var navTop = shopmenuNav.offset().top;
    var items = $(".shopmenu");
    var currentId = "";
    $(window).on("scroll", function() {
        var docScrollTop = $(document).scrollTop();
        if (docScrollTop - navTop >= 0 && !shopmenuNav.hasClass("sticky")) {
            shopmenuNav.addClass("sticky");
        } else if (shopmenuNav.hasClass("sticky")) {
            if (-docScrollTop + navTop > 0) {
                shopmenuNav.removeClass("sticky");
            }
        }

        items.each(function() {
            var self = $(this);
            var itemTop = self.offset().top;
            if (docScrollTop - itemTop + shopmenuNav.outerHeight() > 0) {
                currentId = "#" + self.attr("id");
            } else {
                return false;
            }
        });

        var currentLink = shopmenuNav.find(".active");
        if (currentId && currentLink.attr("href") != currentId) {
            currentLink.removeClass("active");
            shopmenuNav.find("[href=" + currentId + "]").addClass("active");
        }
    });

    $(".shopmenu-nav a").on("click", function() {
        $(this).addClass("active").siblings().removeClass("active");
    })


    $('.shop-cartbutton').on('click', addProduct);
    $('.plus').on('click', addProduct);

    function addProduct(e) {
        if ($(this).text() == "加入购物车") {
            var title = $(this).parent().find(".rstblock-title").text(),
                price = $(this).parent().find(".shopmenu-food-price").text(),
                dishId=$(this).parent().find("input").val(),
                flyer = $('<div id="circle"></div>'),
                id = $(this).parent().attr("id"),

                self = $(this);
            flyer.fly({
                start: {
                    left: e.clientX,
                    top: e.clientY
                },
                end: {
                    left: $(".shop-cartbasket")[0].getBoundingClientRect().left + 15,
                    top: $(".shop-cartbasket")[0].getBoundingClientRect().top + 15
                },
                onEnd: function() {
                    $(".shop-cartbasket").append('<div class="shop-cartbasket-tablerow" data-id=' + id + '> \
                <div class="cell itemname">' + title + '</div> \
                <div class="cell itemquantity"> \
                    <button class="minus">-</button> \
                    <input value="1"> \
                    <button class="add">+</button> \
                </div> \
                <div class="cell itemtotal" data-single=' + price + '>' + price + '</div> \
                <input type="hidden" value=' +dishId+'> \
            </div>');
                    $(".shop-cartbasket").animate({
                        "top": "-=44px"
                    });
                    totalPrice();
                    self.text("已加入购物车");
                    self.css("background", "#f00");
                    flyer.remove();
                }
            });
        }
    }

    $(document).on("click", ".itemquantity .add", function() {
        var value = +$(this).siblings("input").attr("value");
        $(this).siblings("input").attr("value", value + 1),
            singlePrice = +$(this).parent().siblings(".itemtotal").attr("data-single");
        $(this).siblings("input").val(+$(this).siblings("input").attr("value"));
        $(this).parent().siblings(".itemtotal").text(singlePrice * (+$(this).siblings("input").attr("value")))
        totalPrice();
    });

    $(document).on("click", ".itemquantity .minus", function() {
        var value = +$(this).siblings("input").attr("value");
        var self = $(this);
        if (value == 1) {
            $(".shop-cartbasket").animate({
                "top": "+=44px"
            }, function() {
                self.parent().parent().remove();
            });
            var currentId = self.parent().parent().attr("data-id");
            $("#" + currentId).find(".shop-cartbutton").text("加入购物车").css("background", "#0089dc")
        }
        $(this).siblings("input").attr("value", value - 1),
            singlePrice = +$(this).parent().siblings(".itemtotal").attr("data-single");
        $(this).siblings("input").val(+$(this).siblings("input").attr("value"));
        $(this).parent().siblings(".itemtotal").text(singlePrice * (+$(this).siblings("input").attr("value")))
        totalPrice();
    });

    $(document).on("input", ".itemquantity input", function() {
        $(this).attr("value", $(this).val());
        var singlePrice = +$(this).parent().siblings(".itemtotal").attr("data-single");
        $(this).parent().siblings(".itemtotal").text(singlePrice * (+$(this).attr("value")))
        totalPrice();
    });

    $(".shop-grouphead-row a").on("click", clearCart);
    $(".shop-cartfooter-checkout").on("click", dishOrder);
    $(".heart").on("click",function(){
        if($(this).hasClass("coreSpriteHeartOpen")){
            console.log(shopId)
            $.ajax({
                url:'/user/account/favoriteshop',
                data:{'shopId':shopId},
                type:"PUT",
                success:function(data){
                    if(data.success){
                        console.log(data.doc);
                    }
                }
            })
            $(this).removeClass("coreSpriteHeartOpen").addClass("coreSpriteHeartFull");
        }else{
            $.ajax({
                url:'/user/account/favoriteshop',
                data:{'shopId':shopId},
                type:"DELETE",
                success:function(data){
                    if(data.success){
                        console.log(data.doc);
                    }
                }
            })
            $(this).removeClass("coreSpriteHeartFull").addClass("coreSpriteHeartOpen");
        }
    });

    function totalPrice() {
        var sum = 0;
        $(".shop-cartbasket-tablerow").each(function() {
            var value = +$(this).find("input").attr("value"),
                singlePrice = +$(this).find(".itemtotal").attr("data-single");
            sum += value * singlePrice
        });
        $(".shop-cartfooter-text").text(sum);
        if ($(".shop-cartfooter-text").text() != ("" || "0")) {
            $(".shop-cartfooter-checkout").text("Pay").removeClass("disabled");
        } else {
            $(".shop-cartfooter-checkout").text("购物车是空的").addClass("disabled");
        }
    }

    function clearCart() {
        $("#shopbasket").css("top", "-44px").find(".shop-cartbasket-tablerow").remove();
        $(".shop-cartfooter-text").text("");
        $(".shop-cartbutton").text("加入购物车").css("background", "#0089dc");
        totalPrice();
    }
    function dishOrder(){
        var orderList=[];
        $(".shop-cartbasket-tablerow").each(function() {
            var dishName=$(this).find(".itemname").text(),
                num= +$(this).find("input").attr("value"),
                singlePrice = +$(this).find(".itemtotal").attr("data-single"),
                dishId=$(this).find("input[type='hidden']").val(),
                order={};
                order.dishName=dishName;
                order.num=num;
                order.price=singlePrice*num;
                order.dishId=dishId;
                orderList.push(order);
        });

        localStorage.setItem('orderList',JSON.stringify(orderList));
        localStorage.setItem('totalPrice',$(".shop-cartfooter-text").text());
        window.location="/user/account/web/order";

    }
})