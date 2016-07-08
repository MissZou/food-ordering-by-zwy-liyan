$(function() {
	var windowHeight=$(window).height();
	$(".restaurant-content").height(windowHeight-44-39-42);
	var num = null;
	var menuOrder=[];
	var shopId=window.location.pathname.split("/")[5]; //非常不健壮
	localStorage.setItem("shopId",shopId);
	var trueData=null;
	var classifyObj={};
    $(".header-title").text($("#shopName").val());
	$.ajax({
		url: '/shop/account/web/menu-m',
            type: 'POST',
            data: {"shopId":shopId},
            success: function(data, status) {
                if (data.success) {
                    trueData=data.dish;
                    for(var i=0;i<trueData.length;i++){
                    	if(!classifyObj[trueData[i].category]){
                    		classifyObj[trueData[i].category]=[];
							classifyObj[trueData[i].category].push(trueData[i]);
                    	}else{
                    		classifyObj[trueData[i].category].push(trueData[i]);
                    	}
                    }
                }
            }
	});

    $(".restaurant-menu-item").on("click", loadContent);

	$(document).on("click",".mdish-cartcontrol",changeCart);
	$(document).on("click",".minus-cartcontrol",minusCart);
	$(".mcart-checkout").on("click",order);
	var loadBefore={};
    function loadContent() {
        num = $(this).find(".category").text();
        var index=$(this).index();
        $(".restaurant-menu-item").eq(index).addClass("active").siblings().removeClass("active");
        if(!loadBefore[num]){
        	console.log("no")
        	var currentData = classifyObj[num];
        var markup = '<div class="restaurant-food-container"> \
        <img width="70" height="70" style="opacity: 1; transition: opacity 0.5s;" src=${dishPic}> \
        <div class="restaurant-food-body"> \
            <p class="restaurant-food-name">${dishName}</p> \
            <p class="restaurant-food-description">${intro}</p> \
            <div class="restaurant-food-content"> \
                <div class="restaurant-food-info"> \
                    <p class="restaurant-food-about"> \
                        <rating></rating> \
                        <span class="restaurant-food-comment">0评价</span> \
                        <span class="restaurant-food-sales">月售57份</span> \
                    </p> \
                    <div class="restaurant-food-footer"> \
                        <span class="restaurant-food-price">${price}</span> \
                        <div class="mdish-cartcontrol">+</div> \
                    </div> \
                </div> \
            </div> \
        </div> \
    </div>';
        $.template("menuClassTemplate", markup);
        loadBefore[num]=$.tmpl("menuClassTemplate", currentData);
        $(".restaurant-food section").html(loadBefore[num]);
    }else{
    	$(".restaurant-food section").html(loadBefore[num]);
    }
    }

    function changeCart(){
    	var num=+$(".ui-quantity").text();
    	var price=+$(this).siblings(".restaurant-food-price").text();
    	var originalPrice=+$(".mcart-price").text();
    	if($(".restaurant-menu-item.active span").length==1){
    		$("<span class='restaurant-menu-tip'>1</span>").insertBefore(".restaurant-menu-item.active span");
    	}else{
    		var tip=$(".restaurant-menu-item.active .restaurant-menu-tip");
    		var orderNum=Number(tip.text());
    		tip.text(++orderNum)
    	}
    	if(!$(this).siblings(".food-num")[0]){
    		$('<div class="minus-cartcontrol">-</div> \
            <span class="food-num">1</span>').insertBefore($(this));
    	}else{
    		var currentNum=$(this).siblings(".food-num").text();
    		$(this).siblings(".food-num").text(++currentNum);
    	}
		$(".ui-quantity").text(++num);
		$(".mcart-price").text(originalPrice+price);
		var dishName=$(this).parents(".restaurant-food-content").siblings(".restaurant-food-name").text();
		var dishPrice=+$(this).siblings(".restaurant-food-price").text();
		var find=false;
		for(var i=0;i<menuOrder.length;i++){
			if(menuOrder[i].dishName==dishName){
				menuOrder[i].num++;
				menuOrder[i].price+=dishPrice;
				find=true;
				break;
			}
		}
	if(!find){
		var obj={};
				obj.dishName=dishName;
				obj.price=dishPrice;
				obj.num=1;
				menuOrder.push(obj)
	}
    }
    function minusCart(){
    	var tip=$(".restaurant-menu-item.active .restaurant-menu-tip");
    	var currentNum=$(this).siblings(".food-num").text();
    	var num=+$(".ui-quantity").text();
    	var price=+$(this).siblings(".restaurant-food-price").text();
    	var originalPrice=+$(".mcart-price").text();
    	var dishName=$(this).parents(".restaurant-food-content").siblings(".restaurant-food-name").text();
		var dishPrice=+$(this).siblings(".restaurant-food-price").text();

    	if(tip.text()=="1"){
    		tip.remove();
    		if($(this).siblings(".food-num").text()!="1"){
    			$(this).siblings(".food-num").text(--currentNum);
    		}else{
    			$(this).siblings(".food-num").remove();
    			$(this).remove();
    		}
    	}else{
    		if($(this).siblings(".food-num").text()!="1"){
    			$(this).siblings(".food-num").text(--currentNum);
    		}else{
    			$(this).siblings(".food-num").remove();
    			$(this).remove();
    		}
    		tip.text(tip.text()-1);
    	}
    	$(".ui-quantity").text(--num);
		$(".mcart-price").text(originalPrice-price);

		for(var i=0;i<menuOrder.length;i++){
			if(menuOrder[i].dishName==dishName &&menuOrder[i].num>1){
				console.log(">1")
				menuOrder[i].num--;
				menuOrder[i].price-=dishPrice;
				break;
			}else if(menuOrder[i].dishName==dishName ){
				menuOrder.splice(i, 1);
			}
		}
		console.log(menuOrder)

    }
    function dishOrder(){
        var orderList=[];
        $(".shop-cartbasket-tablerow").each(function() {
            var dishName=$(this).find(".itemname").text(),
                num= +$(this).find("input").attr("value"),
                singlePrice = +$(this).find(".itemtotal").attr("data-single"),
                order={};
                order.dishName=dishName;
                order.num=num;
                order.price=singlePrice*num;
                orderList.push(order);
        });

        localStorage.setItem('orderList',JSON.stringify(orderList));
        localStorage.setItem('totalPrice',$(".shop-cartfooter-text").text());
        window.location="/user/account/web/order";

    }

    function order(){
        if($(".mcart-price").text()=="0"){
            return false;
        }
    	localStorage.setItem('menuOrder',JSON.stringify(menuOrder));
        localStorage.setItem('totalPrice',$(".mcart-price").text());
        window.location="/user/account/web/order/m";
    }
})