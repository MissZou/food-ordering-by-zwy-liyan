$(function() {
    //baidu map
var map = new BMap.Map("l-map");
    var point = new BMap.Point(114.18,22.5); //hong kong
    map.centerAndZoom(point, 10);
    var marker = new BMap.Marker(point);// 创建标注
    map.addOverlay(marker);             // 将标注添加到地图中
    marker.enableDragging();
    map.enableScrollWheelZoom();   //启用滚轮放大缩小，默认禁用
    map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
    marker.addEventListener("dragend",attribute);
        function G(id) {
        return document.getElementById(id);
    }
    function isEmail(str){ 
var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/; 
return reg.test(str); 
} 
    function attribute(){
        var p = marker.getPosition(); //获取marker的位置
        var loc = "[" + p.lng + "," + p.lat + "]";
        $("#location").val(loc);
        alert(loc)
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
       // G("searchResultPanel").innerHTML = str;
    });

    var myValue;
    ac.addEventListener("onconfirm", function(e) { //鼠标点击下拉列表后的事件
        var _value = e.item.value;
        myValue = _value.province + _value.city + _value.district + _value.street + _value.business;
      //  G("searchResultPanel").innerHTML = "onconfirm<br />index = " + e.item.index + "<br />myValue = " + myValue;

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
            attribute();
             marker.addEventListener("dragend",attribute);
        }
        var local = new BMap.LocalSearch(map, { //智能搜索
            onSearchComplete: myFun
        });
        local.search(myValue);
    }

    var uploadPic = {
        addCoverPic: function(file) {
            $(".preview-coverPic").empty();
            var imageType = /^image\//;
            var reader = new FileReader();
            reader.onload = function(e) {
                $('<img src=' + e.target.result + ' alt="" width="200" >')
                    .appendTo($(".preview-coverPic"));
            };
            reader.readAsDataURL(file);
        }
    };

    $(".coverPic").on("change", function() {
        uploadPic.addCoverPic(this.files[0]);
    });

    $("#articlePostBtn").on("click", function() {
        if(!isEmail($("#email").val().trim())){
            alert("请填写正确的email地址")
            return false;
            
        }

        var noEmpty=false;
        $("input").each(function(index, val) {
        if ($(this).val() == "") {
            noEmpty=true;
        }
    });

        if(noEmpty){
            alert("填完空")
            return false;
        }
        $.ajax({
            url: '/shop/register/',
            type: 'POST',
            data: {
                "email":$("#email").val(),
                "password":$("#password").val(),
                "shopName": $("#shopName").val(),
                "location": $("#location").val(),
                "address": $("#address").val(),
                "open": true, //先这样写
                "shopType": $(".typeResult").text().trim()
            },
            success: function(data, status) {
                if (data.success == true) {
                    alert("上传成功");
                    var formData = new FormData();
                    formData.append('file', $(".coverPic")[0].files[0]);
                    formData.append('shopName', $("#shopName").val());
                    formData.append('shopId', data.shop._id);
                    $.ajax({
                        url: '/shop/createCover/',
                        data: formData,
                        type: 'POST',
                        contentType: false, //must
                        processData: false, //must
                        success: function(data, status) {
                            if (data.code == 200) {
                                window.location="/shop/login";
                            }
                        },
                        error: function(data, status) {
                            if (data.code != 200) {
                                alert("error");
                            }
                        }
                    });

                }
            },
            error: function(data, status) {
                if (data.code != 200) {
                    alert("上传shibai");
                }
            }
        });
 

    })

    $(".type li").on("click", function(e) {
        e.stopPropagation()
        if ($(this).find("ul").length == 0) {
            $(".typeResult").text($(this).text())
        }
    });

})
