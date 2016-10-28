$(function() {
    $(".search").addClass("focus");
    var winHeight=$(window).height();
    $("#r-result").height(winHeight-60 +"px")
    var marker = null;

    function G(id) {
        return document.getElementById(id);
    }

    var map = new BMap.Map("l-map");
    map.centerAndZoom("北京", 12); // 初始化地图,设置城市和地图级别。

    var ac = new BMap.Autocomplete( //建立一个自动完成的对象
        {
            "input": "suggestId",
            "location": map
        });

    ac.addEventListener("onhighlight", function(e) { //鼠标放在下拉列表上的事件
        var str = "";
        var _value = e.fromitem.value;
        var value = "";
        if (e.fromitem.index > -1) {
            value = _value.province + _value.city + _value.district + _value.street + _value.business;
        }
        str = "FromItem<br />index = " + e.fromitem.index + "<br />value = " + value;

        value = "";
        if (e.toitem.index > -1) {
            _value = e.toitem.value;
            value = _value.province + _value.city + _value.district + _value.street + _value.business;
        }
        str += "<br />ToItem<br />index = " + e.toitem.index + "<br />value = " + value;
        G("searchResultPanel").innerHTML = str;
    });

    var myValue;
    ac.addEventListener("onconfirm", function(e) { //鼠标点击下拉列表后的事件
        var _value = e.item.value;
        myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
        G("searchResultPanel").innerHTML = "onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;

        setPlace();
    });

    function setPlace() {
        map.clearOverlays(); //清除地图上所有覆盖物
        function myFun() {
            var pp = local.getResults().getPoi(0).point; //获取第一个智能搜索的结果
            map.centerAndZoom(pp, 18);
            marker = new BMap.Marker(pp)
            map.addOverlay(marker); //添加标注
            marker.enableDragging();
        }
        var local = new BMap.LocalSearch(map, { //智能搜索
            onSearchComplete: myFun
        });
        local.search(myValue);
    }

    function markerPos() {
        var p = marker.getPosition(); //获取marker的位置
        var loc = "[" + p.lng + "," + p.lat + "]";
        console.log(loc)
        var data = {
            "distance": 5,
            "location": loc
        };
        $.ajax({
            url: '/shop/findshops',
            type: 'post',
            data: data,
            success: function(data, status) {
                if (data.code == 200) {
                    $("#r-result").animate({"height":"50px"},1000,function(){
                        $("#r-result").css("background","#fff");
                    });
                    console.log(data)
                    var shopData = data.shop;
                    if(shopData.length===0){

                        $("#search-result").html('<div class="empty-section"><div class="list-wrap"> \
<img src="/images/no-shop.png" alt=""> \
<p class="msg">Sorry, there are no restaurants nearby T-T.</p> \
</div></div>');
                    }else{
                         var markup = '<a href="/user/account/web/cart/${_id}" target="_blank" class="rstblock"> \
            <div class="rstblock-logo"> \
            <img src=${shopPicUrl} alt=${shopName} class="rstblock-logo-icon"></div> \
            <div class="rstblock-content"> \
                <div class="rstblock-title">${shopName}</div> \
                <div class="rstblock-cost">Address:${address}</div> \
              </div> \
            </div> \
        </a>';
                    $.template("shopTemplate", markup);
                    $("#search-result").html($.tmpl("shopTemplate", shopData));
                    }
                   
                } else {
                    alert("chucuo");
                }
            }
        });
    }

    G("confirm").addEventListener("click", markerPos, false);
})