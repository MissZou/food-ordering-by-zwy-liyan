$(function() {
    function moreOrder(index) {
        $.ajax({
            url: '/user/account/web/wholeOrderData',
            type: 'GET',
            headers: {
                'index': index,
                'count': 9999
            },
            success: function(data, status) {
                if (data.success) {
                    $("#ifelse").tmpl(data.order).appendTo('.order-div');
                }
                console.log(data)
                for (var i in data.dishObj) {
                    var commented = false;
                    var len = data.dishObj[i].length;
                    for (var j = 0; j < len; j++) {
                        $(".dishName").eq(Number(i)).append("<div class='dish-item'>" + data.dishObj[i][j].dishName + "</div>")
                        $(".dishId").eq(Number(i)).append("<input type='hidden' value='" + data.dishObj[i][j]._id + "'>")
                        $(".dishPrice").eq(Number(i)).append("<div class='dish-price'>" + data.dishObj[i][j].price + "</div>")
                        $(".dishNum").eq(Number(i)).append("<div class='dish-num'>" + data.amount[i][j] + "</div>")

                        for (var ind = 0; ind < data.dishObj[i][j].comment.length; ind++) {
                            if (data.dishObj[i][j].comment[ind].userId == localStorage.getItem('accountId')) {
                                commented = true;
                                //alert(data.dishObj[i][j].comment[ind].mark)
                                $(".dishMark").eq(Number(i)).append(data.dishObj[i][j].comment[ind].mark)
                            }
                        }
                        if (!commented) {
                            $(".dishMark").eq(Number(i)).append('<div class="box"><div class="score"><span class="result"></span></div><ul class ="star"><li>★</li><li>★</li><li>★</li><li>★</li><li>★</li></ul><div class="text">0</div></div>')
                            
                        }
                    }
                    if (!commented) {
                    $(".content").eq(Number(i)).append('<button class="markBtn">submit mark</button>');
                }
                }

                var start = document.getElementsByClassName("star");
                for (var k = 0; k < start.length; k++) {
                    start[k].onmouseover = function() {
                        var startLi = this.querySelectorAll("li");
                        for (var i = 0, len = startLi.length; i < len; i++) {
                            startLi[i].index = i; //给li添加一个索引值
                            startLi[i].onclick = function() {
                                for (var j = 0; j < startLi.length; j++) {
                                    startLi[j].className = "";
                                }
                                for (var j = 0; j <= this.index; j++) { //鼠标经过当前li,<=当前li的索引值的所有li都变亮
                                    startLi[j].className = "active";
                                }
                                $(this).parent().next().text(this.index + 1);
                            }
                        }
                    };
                }
            }
        })
    }

    moreOrder(1);

    $(document).on("click", ".comment", function() {
        var shopId = $(this).parent().siblings(".shopId").text();
        var orderId = $(this).parent().siblings(".orderId").text();
        var comment = {};
        comment.content = $(this).siblings("input").val();
        comment.mark = $(this).siblings(".box").find(".text").text();
        $.ajax({
            url: '/user/account/web/comment',
            type: 'POST',
            data: {
                "shopId": shopId,
                "orderId": orderId,
                "comment": comment
            },
            success: function(data, status) {
                if (data.success) {
                    alert("comment success")
                }
            }
        });
    })

    $(document).on("click", ".markBtn", function() {
        for (var i = 0; i < $(this).parent().find(".dishId").children().length; i++) {
            var dishId = $(this).parent().find(".dishId").children().eq(i).val();
            var mark = $(this).parent().find(".dishMark").find(".text").eq(i).text();
            var shopId = $(this).parent().next().next().text();
            $.ajax({
                url: '/user/account/web/markDish',
                type: 'POST',
                data: {
                    "dishId": dishId,
                    "mark": mark,
                    "shopId": shopId

                },
                success: function(data, status) {
                    if (data.success) {
                        alert("mark success")
                    }
                },
                error: function(err) {
                    console.log(err)
                }
            });
        }

    })
})
