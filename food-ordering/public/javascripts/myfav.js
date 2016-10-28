$(function() {
    $(".myfav").addClass("focus");
    $.ajax({
        url: '/user/account/favoriteshop',
        headers: {
            'index': 1,
            'count': 9999
        },
        type: "GET",
        success: function(data) {
            if (data.success) {
                console.log(data.favoriteshop);
                var markup = '<a href="http://localhost:8080/user/account/web/cart/${shopId._id}" class="fav-item"><img src="${shopId.shopPicUrl}"><h1>${shopId.shopName}</h1> \
                <p>Address:${shopId.address}</p></a>';
                $.template("myLikeTemplate", markup);
                $.tmpl("myLikeTemplate", data.favoriteshop).appendTo(".fav-container");
            }
        }
    })
})
