$(function() {
    //$(".myfav").addClass("focus");

    $.ajax({
        url: '/user/account/favoriteshop',
        headers: {
            'index': 1,
            'count': 9999
        },
        type: "GET",
        success: function(data) {
            if (data.success) {
                //console.log(data.favoriteshop);
                var markup ='<li class="item" data-src="/user/account/web/cart/${shopId._id}/m"> \
            <div class="item-wrap"> \
                <div class="left-wrap"> \
                    <img src="http://'+  window.location.host+'${shopId.shopPicUrl}" alt=${shopId.shopName} class="logo"> \
                </div> \
                <div class="right-wrap"> \
                    <section class="line"> \
                        <h3 class="shop-name">${shopId.shopName}</h3> \
                    </section> \
                   <section class="line"> \
                   <div class="shop-address">Address:${shopId.address}</div> \
                    </section> \
                </div> \
            </div> \
        </li>'
                $.template("myLikeTemplate", markup);
                $.tmpl("myLikeTemplate", data.favoriteshop).appendTo("#search-result");
            }
        }
    })

$(document).on("click",".item",function(){
        window.location=$(this).attr("data-src");
    });
})