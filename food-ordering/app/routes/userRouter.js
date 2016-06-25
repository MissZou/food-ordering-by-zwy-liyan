var routeUser = function (app,io,mongoose,Account,Shop,Order,onlineUser) {
//var routeUser = function () {
var 
  express = require('express'),
  router = express.Router();
var multipart = require('connect-multiparty');
//var multipart = require('form-multiparty');
var multer  = require('multer');
var jwt = require('jsonwebtoken'); // used to create, sign, and verify tokens
var path = require('path');
var formidable = require('formidable');
var util = require('util');
var request = require('request');
var URL = require('URL');
var bodyParser = require('body-parser');
var fs = require('fs');
var nodemailer = require('nodemailer');
var session = require('express-session');
var gm = require('gm');
var imageMagick = gm.subClass({ imageMagick : true });

app.set('view engine', 'jade');
var tokenConfig = {
    'secret': 'wochengrenwokanbudongzhegetokenshiTMzmlaide',
    'database': 'mongodb://localhost:27017/Server'
}
app.set('tokenScrete', tokenConfig.secret);

//var upload = require('../models/upload')(mongoose);
var upload = multer({ dest: './public/upload' });

var ifMobile = function (req, res, next) {
  var deviceAgent = req.headers["user-agent"].toLowerCase();
var agentID = deviceAgent.match(/(iphone|ipod|ipad|android)/)&&(deviceAgent.indexOf("inoc")==-1);
if(agentID){
if(/\/m$/.test(req.url) ||req.method!="GET" ){
    next();
}else {
res.redirect(req.protocol + '://' + req.get('host') + req.originalUrl+"/m");
}
}else{
next();
}
};

app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json({
    uploadDir: './public/upload'
}));
// app.use(bodyParser.urlencoded({
//     uploadDir: './public/upload'
// }));
app.use(bodyParser.json({limit: "50mb"}));
app.use(bodyParser.urlencoded({limit: "50mb", extended: true, parameterLimit:50000},{extended:true}));

app.use(session({
    secret: 'secret',
    cookie: {
        path: '/',
        maxAge: 1000 * 60 * 30
    }
}));
app.use(function(req, res, next) {
    res.locals.user = req.session.user; // 从session 获取 user对象
    var err = req.session.error; //获取错误信息
    delete req.session.error;
    res.locals.message = ""; // 展示的信息 message
    if (err) {
        res.locals.message = '<div class="alert alert-danger" style="margin-bottom:20px;color:red;">' + err + '</div>';
    }
    next(); //中间件传递
});


var sessionUser="";
router.use(ifMobile);
router.route('/upload')
    .get(function(req, res) {
        if (req.session.user) {
            res.render('upload', {
                username: req.session.user.name
            });
        } else {
            res.render('upload', {
                username: "请先登录"
            });
        }
    });


router.route('/confirm')

.get(function(req, res) {
    res.sendfile(path.join(__dirname, '../../views', 'confirm.html'));
})

// ----------------------------------------------------
router.route('/register/m')
.get(function(req, res) {
         res.render('reg-m');
    });

router.route('/register')
    .get(function(req, res) {
        res.render('reg', {
            title: 'register'
        });
    })
    .put(function(req, res) {
        var email = req.param('email', null);
        var password = req.param('password', null);
        var name = req.param('name', null);
        var phone = req.param('phone', null);
        if (null == email || email.length < 1 || null == password || password.length < 1 ||
            null == name || name.length < 1 || null == phone || phone.length < 1) {
            res.send(400);
            return;
        } else {
            Account.findAccount(email, function(doc) {
                if (doc != null) {
                    res.json({
                        success: false,
                        msg: "Account has been used"
                    });
                    return
                } else {
                    Account.register(email, password, phone, name, function(err) {
                        if (err == null) {
                            Account.findAccount(email, function(doc) {
                                //console.log(doc)
                                var inToken = { "_id": doc._id }
                                var token = jwt.sign(inToken, app.get('tokenScrete'), {
                                    expiresIn: 1440 * 60 * 7 // expires in 24*7 hours
                                });
                                res.json({
                                    code: 200,
                                    accountId: doc._id,
                                    email: doc.email,
                                    name: doc.name,
                                    address: doc.address,
                                    success: true,
                                    token: token
                                })
                            })
                        }
                    });
                }
            })
        }
    });

router.route('/avatar')
    .get(function(req, res) {
        if (req.session.user) {
            res.render('upload', {
                username: req.session.user.name
            });
        } else {
            res.render('upload', {
                username: "请先登录"
            });
        }
    })

.post(multipart(), function(req, res) { //create avatar
    console.log("avatar");
    //console.log(req.file);
    var targetPath = './public/resources/avatar/' + req.session.user._id + '.jpg';
    var tmp_path = req.files.files.path;
    imageMagick(tmp_path)
                .gravity('Center')
                .resize('640', '480','^>')
                .crop('640', '480')
                .autoOrient()
                .quality(90)
                .write(targetPath, function(err){
                    if (err) {
                        console.log(err);
                    }
                    fs.unlink(tmp_path, function() {
                    });
                });
    var url = 'http://' + req.headers.host + '/resources/avatar/' + req.session.user._id + '.jpg';


    
    var accountId = req.session.user._id;
    console.log(accountId);
    Account.uploadAvatar(accountId, url, function(err) {
        if (null == err)
            res.json({
                code: 200,
                msg: {
                    url: url
                }
            });
    })

});

router.route('/forgetpassword')

.post(function(req, res) {
    var hostname = req.headers.host;
    var resetPasswordUrl = 'http://' + hostname + '/user/resetPassword';
    var email = req.param('email', null);
    if (null == email || email.length < 1) {
        res.send(400);
        return;
    }

    Account.forgotPassword(email, resetPasswordUrl, function(success) {
        if (success) {
            res.send(200);
            console.log('email has sent.');
        } else {
            // Username or password not found
            res.send(404, '404 not found');
        }
    });
});

router.route('/resetPassword')

.get(function(req, res) {
    var accountId = req.param('account', null);
    res.render('resetPassword.jade', {
        accountId: accountId
    }); // delete local.
})

.post(function(req, res) {
    console.log('resetPassword post');
    var accountId = req.param('accountId', null);
    var password = req.param('password', null);
    if (null != accountId && null != password) {
        Account.changePassword(accountId, password);
    } else {
        console.log('err');
    }
    res.render('resetPasswordSuccess.jade');
});

router.route('/login')

.post(function(req, res) {
    //console.log('login request');
    var email = req.param('email', null);
    var password = req.param('password', null);
    //console.log(req);
    //console.log(email, password)

    if (null == email || email.length < 1 || null == password || password.length < 1) {
        res.send(400);
        return;
    };

    Account.login(email, password, req, function(doc) {
        if (doc != null) {
            var inToken = { "_id": doc._id }

            var token = jwt.sign(inToken, app.get('tokenScrete'), {
                expiresIn: 1440 * 60 * 7 // expires in 24*7 hours
            });
            req.session.userToken = token;

            res.json({
                code: 200,
                accountId: doc._id,
                email: doc.email,
                address: doc.address,
                name: doc.name,
                phone: doc.phone,
                location: doc.location,
                photoUrl: doc.photoUrl,
                favoriteShop: doc.favoriteShop,
                favoriteItem: doc.favoriteItem,
                cart: doc.cart,
                token: token,
                success: true
            });
            sessionUser=doc._id;
        } else {
            res.json({
                code: 400,
                success: false
            });
            // res.send(400);
        }
    });
});

router.use("/account", function(req, res, next) {
    //console.log(req);
    // check header or url parameters or post parameters for token
    var token = req.body.token || req.param('token') || req.headers['token'] || req.session.userToken;
    // decode token
    if (token) {
        // verifies secret and checks exp
        jwt.verify(token, app.get('tokenScrete'), function(err, decoded) {
            if (err) {
                return res.json({ success: false, message: 'Failed to authenticate token.' });
            } else {
                // if everything is good, save to request for use in other routes
                req.decoded = decoded;
                //console.log("decoded");
                //console.log(decoded);
                next();
            }
        });
    } else {

        // if there is no token
        // return an error
        return res.status(403).send({
            success: false,
            message: 'No token provided.'
        });
    }
});

router.route('/account')
    .post(function(req, res) {
        //console.log(req.decoded);
        Account.findAccountById(req.decoded._id, function(doc) {
            if (null != doc)
                res.json({
                    accountId: doc._id,
                    email: doc.email,
                    address: doc.address,
                    name: doc.name,
                    phone: doc.phone,
                    location: doc.location,
                    photoUrl: doc.photoUrl,
                    favoriteShop: doc.favoriteShop,
                    favoriteItem: doc.favoriteItem,
                    cart: doc.cart,
                    success: true
                })
            else {
                res.json({
                    success: false
                })
            }
        })
    });

 router.route('/account/index')
    .get(function(req, res) {
        res.sendfile(path.join(__dirname, '../../views', 'baidu-map.html'));
    });

router.route('/account/web/address')
    .get(function(req, res) {
        // var accountId = req.param('account', null);
        var accountId = req.decoded._id;
        Account.findAccountById(accountId, function(doc) {
            res.render('updateInfo.jade', {
                items: doc.address
            });
        })

    });


router.route('/account/address')
.get(function(req, res){

    var accountId = req.decoded._id;
    Account.findAccountById(accountId,function(doc){
            if (doc) {
                res.json({
                    success:true,
                    address:doc.address
                });    
            } else{
                res.json({
                    success:false
                    
                });    
            }
            
        })
})


.put(function(req, res) {
    var accountId = req.decoded._id;
    
    //var accountId = req.session.user._id;
    var address = req.param("address", null),
        name = req.param("name", null),
        phone = req.param("phone", null),
        type = req.param("type", null);

    var totalAddress = {
        "address": address,
        "name": name,
        "phone": phone,
        "type": type
    };

    // console.log(totalAddress);
    if (address != null && address != "") {
        Account.addAddress(accountId, totalAddress, function(doc) {
            if (doc == null) {
                Account.findAccountById(accountId, function(doc) {
                    res.json({
                        accountId: doc._id,
                        address: doc.address,
                        success: true
                    });
                })
            }
        });
    }
})

.post(function(req, res) {
    var accountId = req.decoded._id;
    //var accountId = req.session.user._id;
    var address = req.param("address", null),
        name = req.param("name", null),
        phone = req.param("phone", null),
        type = req.param("type", null),
        addrId = req.param("addrId", null);
    var totalAddress = {
        "address": address,
        "name": name,
        "phone": phone,
        "type": type
    };
    //console.log(totalAddress);
    // console.log(addrId);
    if (addrId != null && addrId != "") {
        Account.updateAddress(accountId, totalAddress, addrId, function(doc) {
            if (doc == null) {
                Account.findAccountById(accountId, function(doc) {
                    res.json({
                        accountId: doc._id,
                        address: doc.address,
                        success: true
                    });
                })
            } else {
                res.json({
                    code: 400,
                    success: false
                })
            }
        });
    } else {
        res.json({
            code: 400,
            success: false
        })
    }
})


.delete(function(req, res) {
    var accountId = req.decoded._id;
    //var accountId = req.session.user._id;

    var address = req.param("address", null),
        name = req.param("name", null),
        phone = req.param("phone", null),
        type = req.param("type", null);

    var totalAddress = {
        "address": address,
        "name": name,
        "phone": phone,
        "type": type
    };
    if (address != null && address != null) {
        Account.deleteAddress(accountId, totalAddress, function(doc) {
            if (doc == null) {
                Account.findAccountById(accountId, function(doc) {
                    res.json({
                        accountId: doc._id,
                        address: doc.address,
                        success: true
                    });
                })
            }
        });
    }

});

router.route('/account/web/location')
.get(function(req, res) {

        res.render('updateInfo.jade');

    });
router.route('/account/location')
    
    .put(function(req, res) {
        var accountId = req.decoded._id;
        //var accountId = req.session.user._id;
        var locationName = req.param("name", null);
        var coordinateString = req.param("location", null);
        //console.log(coordinateString);
    var coordinate = JSON.stringify(coordinateString);
    //console.log(typeof coordinate);
    //console.log(typeof coordinateString);
    coordinate = coordinate.split(',');
    coordinate[0] = coordinate[0].replace(/[^0-9.]/g,'');
    coordinate[1] = coordinate[1].replace(/[^0-9.]/g,'');
    var location = [Number(coordinate[0]),Number(coordinate[1])];
        //var coordinate = [Number(coordinateString.split(',')[0]),Number(coordinateString.split(',')[1])];
        //console.log('account/location'+coordinate.split(',')[0]);
        console.log(accountId);
        if (locationName != null && locationName != "") {
            Account.addLocation(accountId, locationName,location, function(err) {
                if (err == null) {
                    Account.findAccountById(accountId, function(doc) {
                        res.json({
                            accountId: doc._id,
                            location: doc.location,
                            success: true
                        });

                    })
                    
                }else{
                    res.json({
                            err: err,
                            success: false
                        });
                }
            });
        }

    })

.delete(function(req, res) {
    //console.log(req);
    var accountId = req.decoded._id;
    var locationName = req.param("name", null);
    if (locationName != null && locationName != "") {
        Account.deleteLocation(accountId, locationName, function(err) {
                if (err == null) {
                    Account.findAccountById(accountId, function(doc) {
                        res.json({
                            accountId: doc._id,
                            location: doc.location,
                            success: true
                        });
                    })
                }else{
                    res.json({
                            err: err,
                            success: false
                        });
                }
        });
    }
});
router.route('/account/web/cart/:shopId')
    .get(function(req, res) {
        console.log(req.params.shopId)
        Shop.findShopById(req.params.shopId,function(doc){
            console.log(doc.dish);
             res.render('shop-detail', {
                doc: doc.dish,
                shopName:doc.shopName
            });
        })
         //res.render('shop-detail.jade');
        
    });

router.route('/account/cart')

    
    .get(function(req, res) {
        var accountId = req.decoded._id;
        var index = req.headers["index"];
        var count = req.headers["count"];
        var cart = {};
        //console.log(index);
        if (index == null || index == 0) {
            index = 1;
        }
        if (count == null || count == 0) {
            count = 1;
        }

        Account.findCartItem(accountId,index,count,function(doc){
            if (doc != false) {
            Account.findAccountById(accountId, function(account) {
                    cart = account.cart;
                    if (doc != null) {
                        res.json({
                            success:true,
                            cartDetail:doc,
                            cart:cart
                        })
                    }else{
                        res.json({
                            success:false
                        })
                    }
                });

            }
            else{
                var arrayNull = [];
                 res.json({
                    cartDetail:arrayNull,
                    cart:arrayNull,
                    success:true
                })
            }
        })

     })

     .put(function(req, res) {
        var accountId = req.decoded._id;
        var itemId = req.param("itemId", null);
        var shopId = req.param("shopId", null);
        var amount = req.param("amount", null);
        if (amount != null && itemId !=null && shopId != null) {

            Account.findCartItemById(accountId,shopId,itemId,function(doc){
                if (doc == false) {
                    Account.addItemToCart(accountId,shopId,itemId,amount,function(err){
                        if (err == null) {
                            Account.findAccountById(accountId,function(doc){
                                res.json({
                                    accountId: doc._id,
                                    cart: doc.cart,
                                    success: true
                                })
                            })
                        }
                    })
                }
                else{
                     res.json({
                success: false,
                msg:"duplicate item"
            })
                }
        });
      }else{
             res.json({
                success: false,
                msg:"null parameter"
            })
        }
    })


     .post(function(req, res) {
        var accountId = req.decoded._id;
        var cartId = req.param("cartId", null);
        var amount = req.param("amount", null);
        if (amount >0 && cartId != null) {
            Account.modifyItemToCart(accountId,cartId,amount,function(err){
                if (err == null) {
                    Account.findAccountById(accountId,function(doc){
                        res.json({
                            accountId: doc._id,
                            cart: doc.cart,
                            success: true
                        })
                    })
                }
            })
        }
    })

     .delete(function(req, res){
        var accountId = req.decoded._id;
        var _id = req.param("_id", null);
                Account.deleteItemOfCart(accountId,_id,function(err){
            if (err == null) {
                Account.findAccountById(accountId,function(doc){
                    res.json({
                        accountId: doc._id,
                        cart: doc.cart,
                        success: true
                    })
                })
            }
        })
     });

router.route('/account/web/order')
.get(function(req, res) {
var accountId = req.decoded._id;
        Account.findAccountById(accountId, function(doc) {
            res.render('confirm-order.jade', {
                items: doc.address
            });
        })
    });

router.route('/account/web/myorder')
.get(function(req, res) {
 res.sendfile(path.join(__dirname, '../../views', 'myorder.html'));
    });


router.route('/account/order')
    .get(function(req, res){
        var accountId = req.decoded._id;
        var index = req.headers["index"];
        var count = req.headers["count"];
        //console.log(index);
        if (index == null || index == 0) {
            index = 1;
        }
        if (count == null || count == 0) {
            count = 1;
        }
        Account.findOrderByUserId(accountId,index,count,function(doc){
            if (doc != null) {
                    res.json({
                    order:doc,
                    success: true
                })
            }else{
                res.json({    
                    success: false
                })
            }
            
        })
       
    })

    .put(function(req, res){
        var accountId = req.decoded._id;
        var shopId = req.param("shopId", null);
        var dishs = req.param("dishs", null);
        var price = req.param("price", null);
        var address = req.param("address", null);
        var message = req.param("message", null);
        
        Order.addOrder(accountId,shopId,dishs,address,price,message,function(order){
           
            if (order._id != null) {
                Shop.addOrder(shopId,order._id,function(doc){
                    // request(to shop/router)
                    // shop.notification{
                    //     res.send()
                    // }
                });
                Account.addOrder(accountId,order._id,function(doc){
                    // console.log(doc.orders);
                    for(var i = 0;i<doc.orders.length;i++){
                        if (doc.orders[i].order == null) {
                            doc.orders.splice(i,1);
                            i=-1;continue;
                        }
                    }
                    //console.log(doc.orders);
                    res.json({
                        accountId: doc._id,
                        order:doc.orders,
                        success: true
                    })
                });    
            }
            
        });

    })

    .delete(function(req, res){
        var accountId = req.decoded._id;
        var orderId = req.param("orderId", null);

        Account.deleteOrder(accountId,orderId,function(err){
            if (err == null) {
                res.json({
                    //accountId: doc._id,
                    //order:doc.orders,
                    success: true
                })    
            }
            
        });
    })

router.route('/account/web/mylike')

.get(function(req, res) {

 res.sendfile(path.join(__dirname, '../../views', 'mylike.html'));

    });

router.route('/account/favoriteshop')

    .get(function(req, res){
        var accountId = req.decoded._id;
        var index = req.headers["index"];
        var count = req.headers["count"];
        //console.log(index);
        if (index == null || index == 0) {
            index = 1;
        }
        if (count == null || count == 0) {
            count = 1;
        }
        Account.findFavoriteShop(accountId,index,count,function(doc){            
            res.json({
                success:true,
                favoriteshop:doc
            });
        })
    })
    
    .put(function(req, res){
        var accountId = req.decoded._id;
        var shopId = req.param("shopId", null);

        Account.addFavoriteShop(accountId,shopId,function(doc){
            //res.send(doc);
            if (doc == "err") {
                res.json({
                    success:false,
                    doc:"the shop already favored"
                });
            }else{
                res.json({
                    success:true,
                    doc:doc
                })
            }
        });
    })

    .delete(function(req,res){
        var accountId = req.decoded._id;
        var shopId = req.param("shopId", null);

        Account.deleteFavoriteShop(accountId,shopId,function(doc){
            //res.send(doc);
            res.json({
                success:true,
                doc:doc
            })
        })
    });

router.route('/account/favoriteitem')
    .get(function(req,res){
        var accountId = req.decoded._id;
        var index = req.headers["index"];
        var count = req.headers["count"];
        console.log(count);
        console.log(typeof count);
        if (index == null || index == 0) {
            index = 1;
        }
        if (count == null || count == 0) {
            count = 1;
        }
        
        Account.findFavoriteItem(accountId,index,count,function(doc){
            res.send(doc);
        })
    })

    .put(function(req,res){
        var accountId = req.decoded._id;
        var shopId = req.param("shopId", null);
        var itemId = req.param("itemId", null);

        Account.addFavoriteItem(accountId,shopId,itemId,function(doc){
            console.log(doc);
            //var dishs = doc.favoriteShop.dish;
            //console.log(dishs);
            if (typeof doc === "string") {
                res.json({
                    success:false,
                    doc:doc
                })
            }else{

                res.json({
                    success:true,
                    shopId:shopId,
                    doc:doc
                })
            }
        })        
    })


    .delete(function(req,res){
        var accountId = req.decoded._id;
        var shopId = req.param("shopId", null);
        var itemId = req.param("itemId", null);

        Account.deleteFavoriteItem(accountId,shopId,itemId,function(doc){
            if (doc.ok == 1) {
                res.json({
                    success:true
                })    
            }else{
                res.json({
                    success:false
                })
            }
            //res.send(doc)
        })

    });





//router.route('/account/avatar',bodyParser.json({limit: '5mb'}))
//router.route('/account/avatar')
// .post(multipart(), function(req, res) { //create avatar
//     //var incomingForm = req.form;
    

//     var accountId = req.decoded._id;
//     console.log("avatar");
//     console.log(req.file);
//     //console.log(req);
//     var targetPath = './public/resources/avatar/' + accountId + '.jpg';
//     var tmp_path = req.files.files.path;
//     imageMagick(tmp_path)
//                 .gravity('Center')
//                 .resize('640', '480','^>')
//                 .crop('640', '480')
//                 .autoOrient()
//                 .quality(90)
//                 .write(targetPath, function(err){
//                     if (err) {
//                         console.log(err);
//                     }
//                     fs.unlink(tmp_path, function() {
//                     });
//                 });
//     var url = 'http://' + req.headers.host + '/resources/avatar/' + accountId + '.jpg';
    
//     Account.uploadAvatar(accountId, url, function(err) {
//         if (null == err)
//             res.json({
//                 code: 200,
//                 msg: {
//                     url: url
//                 }
//             });
//     })

// });
// .post(upload.single('file'), function(req, res) { //create avatar

//     var accountId = req.decoded._id;
//     console.log("avatar");
//     console.log(req.file);
//     //console.log(req);
//     var targetPath = './public/resources/avatar/' + accountId + '.jpg';
//     var tmp_path = req.files.files.path;
//     imageMagick(tmp_path)
//                 .gravity('Center')
//                 .resize('640', '480','^>')
//                 .crop('640', '480')
//                 .autoOrient()
//                 .quality(90)
//                 .write(targetPath, function(err){
//                     if (err) {
//                         console.log(err);
//                     }
//                     fs.unlink(tmp_path, function() {
//                     });
//                 });
//     var url = 'http://' + req.headers.host + '/resources/avatar/' + accountId + '.jpg';
    
//     Account.uploadAvatar(accountId, url, function(err) {
//         if (null == err)
//             res.json({
//                 code: 200,
//                 msg: {
//                     url: url
//                 }
//             });
//     })

// });

app.post('/user/account/avatar', upload.single('avatar.png'), function (req, res, next) {
  // req.file is the `avatar` file
  // req.body will hold the text fields, if there were any
       console.log(req.file);
       console.log(req.files);
       console.log('body:', req.body);
})
  return router;
};

module.exports = routeUser;
//module.exports = router; 