$(function() {
	var map = new BMap.Map("l-map");
	 map.centerAndZoom("香港", 12); // 初始化地图,
 var marker = null;
    geoFindMe();
    function geoFindMe() {
        if (!navigator.geolocation) {
            alert("can't")
            return;
        }
        function markerPos(lng, lat) {
            var loc = "[" + lat + "," + lng + "]";
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
                        console.log(data)
                        var shopData = data.shop;
                        alert( window.location.host)
                        var markup ='<li class="item" data-src="/user/account/web/cart/${_id}/m"> \
            <div class="item-wrap"> \
                <div class="left-wrap"> \
                    <img src="http://'+  window.location.host+'${shopPicUrl}" alt=${shopName} class="logo"> \
                </div> \
                <div class="right-wrap"> \
                    <section class="line"> \
                        <h3 class="shop-name">${shopName}</h3> \
                    </section> \
                   <section class="line"> \
                        <div class="rate-wrap"> \
                            <div class="star-rating" progress-meter="5"> \
                    <div class="star-meter" progress-fill="4.2" style="width: 84%;"> \
                </div> \
                        </div> \
                         <span class="rate">4.2</span> \
                    </section> \
                    <section class="line"></section> \
                </div> \
            </div> \
        </li>'
                       
                        $.template("shopTemplate", markup);
                        $("#search-result").html($.tmpl("shopTemplate", shopData));

                    } else {
                        alert("附近没有商家！");
                    }
                }
            });
        }


        function success(position) {
            var latitude = position.coords.latitude;
            var longitude = position.coords.longitude;
            markerPos(latitude, longitude);
        };

        function error(error) {
            alert('ERROR(' + error.code + '): ' + error.message);
        };

        navigator.geolocation.getCurrentPosition(success, error);
    }

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
        $("#searchResultPanel")[0].innerHTML = str;
    });

     var myValue;
    ac.addEventListener("onconfirm", function(e) { //鼠标点击下拉列表后的事件
        var _value = e.item.value;
        myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
setPlace();
setTimeout(function(){
$("#confirm").click();
},1500)
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
    function markerPosNew() {
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
                    console.log(data)
                    var shopData = data.shop;
                    var markup ='<li class="item" data-src="/user/account/web/cart/${_id}/m"> \
            <div class="item-wrap"> \
                <div class="left-wrap"> \
                    <img src="http://'+  window.location.host+'${shopPicUrl}" alt=${shopName} class="logo"> \
                </div> \
                <div class="right-wrap"> \
                    <section class="line"> \
                        <h3 class="shop-name">${shopName}</h3> \
                    </section> \
                    <section class="line"> \
                        <div class="rate-wrap"> \
                            <div class="star-rating" progress-meter="5"> \
                    <div class="star-meter" progress-fill="4.2" style="width: 84%;"> \
                </div> \
                        </div> \
                         <span class="rate">4.2</span> \
                    </section> \
                    <section class="line"> \
                     ${shopType} \
                    </section> \
                </div> \
            </div> \
        </li>'
                       
                        $.template("shopTemplate", markup);
                        $("#search-result").html($.tmpl("shopTemplate", shopData));
                } else {
                    alert("附近没有商家！");
                }
            }
        });
    }

    $("#confirm").on("click", markerPosNew);

    $(document).on("click",".item",function(){
    	window.location=$(this).attr("data-src");
    });
})