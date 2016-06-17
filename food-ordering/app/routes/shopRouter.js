
var routeShop = function (app,io,mongoose,Account,Shop,Order,onlineUser) {
//var routeShop = function () {
//var session = require('express-session');
var 
  express = require('express'),
  router = express.Router();
var request = require('request');
var URL = require('URL');
var bodyParser = require('body-parser');

var path = require('path');
var multipart = require('connect-multiparty');
var jwt = require('jsonwebtoken'); // used to create, sign, and verify tokens
var formidable = require('formidable');
var util = require('util');
var session = require('express-session');
var fs = require('fs');
var gm = require('gm');

var imageMagick = gm.subClass({ imageMagick : true });


var tokenConfig = {
    'secret': 'zhegeshishopdetakensecretwochongxinxieleyige',
    'database': 'mongodb://localhost:27017/Server'
}
app.set('tokenScrete', tokenConfig.secret);

app.use(session({
    secret: 'secret',
    cookie: {
        path: '/',
        maxAge: 1000 * 60 * 30
    }
}));

app.set('view engine', 'jade');
app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

// app.use(bodyParser({
//     uploadDir: './public/upload'
// }));

// app.use(session({
//     secret: 'secret',
//     cookie: {
//         path: '/',
//         maxAge: 1000 * 60 * 30
//     }
// }));
// app.use(function(req, res, next) {
//     res.locals.user = req.session.user; // 从session 获取 user对象
//     var err = req.session.error; //获取错误信息
//     delete req.session.error;
//     res.locals.message = ""; // 展示的信息 message
//     if (err) {
//         res.locals.message = '<div class="alert alert-danger" style="margin-bottom:20px;color:red;">' + err + '</div>';
//     }
//     next(); //中间件传递
// });
//routers
var sessionShop="";

router.route('/findshops')
    .get(function(req,res){
        var index = req.headers["index"];
        var count = req.headers["count"];
        
        var distance = req.headers["distance"];
        var coordinateTemp = req.headers["location"];

        console.log(distance);
        console.log(coordinateTemp);
        if (index == null) {
            index = 1;
        }
        if (count == null) {
            count = 10;
        }
        var coordinate = JSON.stringify(coordinateTemp);
        coordinate = coordinate.split(',');
        coordinate[0] = coordinate[0].replace(/[^0-9.]/g,'');
        coordinate[1] = coordinate[1].replace(/[^0-9.]/g,'');
        if (coordinate !=null && distance !=null) {
            var location = [Number(coordinate[0]),Number(coordinate[1])];
            Shop.findNearShops(location,distance,index,count,function(doc){
              

               res.json({
                   shop:doc,
                   code:200,
                   success:true
                })
              })  
          }  
          else{
                res.json({
                   code:400
                })
          }
    });



router.route('/findItemById')
    .post(function(req, res){
        var shopId = req.param('shopId', null);
        var itemId = req.param('itemId', null); 
        console.log(shopId);
        console.log(itemId);

        if (itemId != null && shopId !=null) {
            Shop.findItemById(shopId,itemId,function(doc){
                res.json({
                    doc:doc,
                    success:true
                })
            });
        }else{
            res.json({
                error:"err",
                success:false
            })
        }
    });

router.route('/register')
    .get(function(req, res) {
        //res.sendfile(path.join(__dirname, './views', 'restaurant-post.html'));
        res.sendfile(path.join(__dirname, '../../views', 'restaurant-post.html'));
    })
    .post(function(req, res) {
        var email = req.param('email', null);
        var password = req.param('password', null);
        var shopName = req.param('shopName', null);
        var loc = req.param('location', null);
        var address = req.param('address', null);
       
        var open = req.param('open', null);
        var shopType = req.param('shopType', null);
    
    var coordinate = JSON.stringify(loc);
    coordinate = coordinate.split(',');
    coordinate[0] = coordinate[0].replace(/[^0-9.]/g,'');
    coordinate[1] = coordinate[1].replace(/[^0-9.]/g,'');
    var location = [Number(coordinate[0]),Number(coordinate[1])];


    Shop.findShop(email,function(doc){
        if (doc != null) {
                                res.json({
                    success: false,
                    msg: "email has been used"
                });
            return
        }else{

        }
            Shop.createShop(email,password,shopName, address,location, open, shopType, function(err) {
            if (err == null) {
                Shop.findShop(email, function(doc) {
                    var inToken = { "_id": doc._id }
                                var token = jwt.sign(inToken, app.get('tokenScrete'), {
                                    expiresIn: 1440 * 60 * 7 // expires in 24*7 hours
                                });
                    res.json({
                        code: 200,
                        shop: doc,
                        token: token,
                        success: true
                    })
                })
            } else{
                    res.json({
                        code: 400,
                        shop: err,
                        success: false
                    })
            }

        });
    });


    });
router.route('/forgetpassword')

.post(function(req, res) {
    var hostname = req.headers.host;
    var resetPasswordUrl = 'http://' + hostname + '/shop/resetPassword';
    var email = req.param('email', null);
    if (null == email || email.length < 1) {
        res.send(400);
        return;
    }

    Shop.forgotPassword(email, resetPasswordUrl, function(success) {
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
    var shopId = req.param('shopId', null);
    res.render('resetPassword.jade', {
        shopId: shopId
    }); // delete local.
})

.post(function(req, res) {
    console.log('resetPassword post');
    var shopId = req.param('shopId', null);
    var password = req.param('password', null);
    if (null != shopId && null != password) {
        Shop.changePassword(shopId, password);
    } else {
        console.log('err');
    }
    res.render('resetPasswordSuccess.jade');
});

router.route('/login')
.get(function(req, res) {
        //res.sendfile(path.join(__dirname, './views', 'restaurant-post.html'));
        res.sendfile(path.join(__dirname, '../../views', 'shop-login.html'));
    })
.post(function(req, res) {
    var email = req.param('email', null);
    var password = req.param('password', null);
    
    if (null == email || email.length < 1 || null == password || password.length < 1) {
        res.send(400);
        return;
    };

    Shop.login(email, password, req, function(doc) {
        if (doc != null) {
            var inToken = { "_id": doc._id }

            var token = jwt.sign(inToken, app.get('tokenScrete'), {
                expiresIn: 1440 * 60 * 7 // expires in 24*7 hours
            });
            req.session.userToken = token;

            res.json({
                code: 200,
                shopId: doc._id,
                email: doc.email,
                address: doc.address,
                shopName: doc.shopName,
                location: doc.location,
                dish:doc.dish,
                order:doc.order,
                token: token,
                success: true
            });
            sessionShop=doc._id;
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
        Shop.findShopById(req.decoded._id, function(doc) {
            if (null != doc)
                res.json({
                    shopId: doc._id,
                    email: doc.email,
                    address: doc.address,
                    shopName: doc.name,
                    location: doc.location,
                    dish:doc.dish,
                    order:doc.order,
                    success: true
                })
            else {
                res.json({
                    success: false
                })
            }
        })
    });


router.route('/account/edit')
    .post(function(req, res){
        var shopId = req.decoded._id;
        var shop = req.param('shop', null);
        Shop.changeShopInfo(shopId,shop,function(doc){
            if (doc != null) {
                res.json({
                    success:true,
                    doc:doc
                })
            }
        })
    })

router.route('/createCover')
    .post(function(req, res) {

        //var shopId = req.decoded._id;
        var form = new formidable.IncomingForm();
        form.parse(req, function(err, fields, files) {
            var shopId = fields.shopId;
            if (err || !files.file) {
                res.json({
                    succeed: false,
                    status: 400,
                    errMsg: "上传失败"
                })
                return;
            }
            var goalUrl = './public/resources/' + fields.shopId + '/';
            if (!fs.existsSync(goalUrl)) {
                fs.mkdirSync(goalUrl);
            }
            var targetPath = goalUrl + fields.shopId + '.jpg';
            var tmp_path = files.file.path;
            
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

            // fs.rename(tmp_path, targetPath, function(err) {
            //     if (err) throw err;
            //     // 删除临时文件夹文件, 
            //     fs.unlink(tmp_path, function() {
            //         if (err) throw err;
            //     });
            // });
            var url = 'http://' + req.headers.host + '/resources/' + fields.shopId + '.jpg';
            Shop.uploadShopCover(shopId, url, function(err) {
                if (null == err)
                    res.json({
                        code: 200,
                        msg: {
                            shopName:fields.shopName
                        }
                    });
            })

        })
    });

router.route('/account/web/dish')
    .get(function(req, res) {
            //res.sendfile(path.join(__dirname, './views', 'restaurant-post.html'));
            res.sendfile(path.join(__dirname, '../../views', 'post-dish.html'));
        })

router.route('/account/dish')
    
    .put(function(req, res) {
        var shopId = req.decoded._id;
        var dish = req.param('dish', null);
        var dishes=null;
        for (var i = 0; i < dish.length; i++) {
            (function(i){
                Shop.addDish(shopId, dish[i], function(doc) {
                if(i==dish.length-1){
                    Shop.findShopById(shopId,function(doc){
                        dishes=doc.dish;
                            res.json({
                            code: 200,
                            success: true,
                            dishes:dishes
                
                    });
                });
                }
            })
            })(i)
        }  
    })
    .post(function(req, res){
        var shopId = req.decoded._id;
        var dish = req.param('dish', null);

        Shop.changeDishInfo(shopId,dish,function(err,doc){

            res.json({
                code: 200,
            });
        })
    })

router.route('/account/createDishPic')
    .post(function(req, res) {
        var shopId = req.decoded._id;
       Shop.findShopById(shopId, function(doc) {
            if (null != doc){
        var form = new formidable.IncomingForm();
        form.encoding = 'utf-8';
        form.multiples = true;
        form.parse(req, function(err, fields, files) {
            if (err || !files) {
                res.json({
                    succeed: false,
                    code: 400,
                    errMsg: "上传失败"
                })
                return
            }
            var goalUrl = './public/resources/' +shopId + '/';
            if (!fs.existsSync(goalUrl)) {
                fs.mkdirSync(goalUrl);
            }
            if (!fs.existsSync(goalUrl + 'dishes/')) {
                fs.mkdirSync(goalUrl + 'dishes/');
            }
            //console.log(files)

            for (var key in files) {
                var targetPath = goalUrl + 'dishes/' + fields["dishId"+key]+".jpg";
                var tmp_path = files[key].path;
                var sz = files[key].size;
                //fs.renameSync(tmp_path, targetPath);
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
                var url = 'http://' + req.headers.host + '/resources/' +shopId+ '/dishes/' +fields["dishId"+key]+".jpg";
                Shop.addDishPic(shopId, fields["dishNames"+key], url, function(err) {
                });
            }
        })
            res.json({
                code: 200
            });
            }
        })
    });



router.route('/account/order')
    .get(function(req, res){
        var shopId = req.decoded._id;
        var index = req.headers["index"];
        var count = req.headers["count"];
        if (index == null) {
            index = 1;
        }
        if (count == null) {
            count = 1;
        }
        Shop.findOrderByShopId(shopId,index,count,function(doc){
            if (doc != null) {
                res.json({
                    success:true,
                    order:doc,
                    shopId:shopId
                })
            }

        })
    })

    .post(function(req, res){
        var shopId = req.decoded._id;
        var orderId = req.param('orderId', null);
        var status = req.param('status',null);

        Order.changeOrderStatus(shopId,orderId,status,function(doc){
            if (doc) {
                res.json({
                    success:true,
                    doc:doc
                })
            }else{
                res.json({
                    success:false
                })
            }
        })
    })


router.route('/account/testAddDish')
.post(function(req,res){
    var shopId = req.decoded._id;
    //var dish = req.param('dish', null);
    // var dishName = req.param('dishName');
    // var tags = req.param('tags');
    // var price = req.param('price');
    // var intro = req.param('intro');
    // var index = req.param('index');
    
    //var array = req.param('array');
    //res.send(array);
    //console.log(array);

    // var dish = {};
    // dish['dishName'] = dishName;
    // dish['tags'] = tags;
    // dish['price'] = price;
    // dish['intro'] = intro;
    // dish['index'] = index;
    // console.log(dish);
    // console.log(dish.dishName);
    //res.send(dish);
    //console.log(dish.dishName);
    
    Shop.deleteShop(shopId,function(doc){
        res.send(doc);
    });
    //  Shop.addDish(shopId, dish, function(err) {
    //             if (null == err){
    //                 res.json({
    //                     code: 200
    //                 });
    //             }else{
    //                 res.json({
    //                     msg: err
    //                 });
    //             }
                    
    // })
                
});





router.route('/account/testAddShop')
.post(function(req,res){
    console.log("testAddshop");
        var email = req.param('email', null);
        var password = req.param('password', null);
        var shopName = req.param('shopName', null);
        var location = req.param('location', null);
        var address = req.param('address', null);
        var shopPicUrl = req.param('shopPicUrl', null);
        var open = req.param('open', null);
        var shopType = req.param('shopType', null);

    for (var i = 0; i <10 ; i++) {
        var rand2 = (Math.random()*(117.4-115.7+1)+115.7);
        var rand1 = (Math.random()*(41.6-39.4+1)+39.4);
        //var location = [116.331398,39.897445];
        // var rand1 = (Math.random()*(41-38+1)+39);
        // var rand2 = (Math.random()*(120-110+1)+110);

        location = [rand1,rand2];

        //Shop.createShop(Math.random().toString(36).substring(7),password,Math.random().toString(36).substring(7), address,location, shopPicUrl, open, shopType, res, function(err) {
        Shop.createShop(Math.random().toString(36).substring(7),password,Math.random().toString(36).substring(7), address,location, shopPicUrl, open, shopType, function(err) {
            if (err == null) {
                Shop.findShop(shopName, function(doc) {
                    res.json({
                        code: 200,
                        shop: doc,
                        success: true
                    })
                })
            } else{
                    res.json({
                        code: 200,
                        shop: err,
                        success: true
                    })
            }

        });
    }
});

io.on('connection', function(socket) {
var nickname=sessionShop;
onlineUser[nickname]=socket.id;
  /*  socket.on('say to someone', function(id, msg) {
    io.sockets.connected[onlineUser[id]].emit("my message", msg)
    });*/
       console.log("shop",onlineUser)
});

  return router;
};

module.exports = routeShop;