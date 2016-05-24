var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var morgan = require('morgan');
var crypto = require('crypto');
var nodemailer = require('nodemailer');
//var MemoryStore = require('express').session.MemoryStore;
var mongoose = require('mongoose');
var https = require('https');
var http = require('http')
var fs = require('fs');
var session = require('express-session');
var multipart = require('connect-multiparty');
var jwt = require('jsonwebtoken'); // used to create, sign, and verify tokens
var path = require('path');
var formidable = require('formidable');
var util = require('util');
var request = require('request');
var URL = require('URL');

var server = http.createServer(app);
var io = require('socket.io').listen(server);

server.listen(8080);


var httpsOptions = {
    key: fs.readFileSync('./https/server-key.pem'),
    cert: fs.readFileSync('./https/server-cert.pem'),
    requestCert: true,
    rejectUnauthorized: false
}

app.set('view engine', 'jade');

var mailConfig = {
    host: 'smtp.gmail.com',
    secureConnection: true,
    port: 465,
    auth: {
        user: 'foodtongcom@gmail.com',
        pass: 'comtongfood'
    }
}

var tokenConfig = {
    'secret': 'wochengrenwokanbudongzhegetokenshiTMzmlaide',
    'database': 'mongodb://localhost:27017/Server'
}
app.set('tokenScrete', tokenConfig.secret);

var cookieSession = require('cookie-session');

var Account = require('./app/models/Account')(mailConfig, mongoose, nodemailer);
var Shop = require('./app/models/Shop')(mongoose);
var upload = require('./app/models/upload')(mongoose);
app.use(express.static(__dirname + '/public'));
//app.set('views', path.join(__dirname, 'views'));
app.use(morgan('dev')); // log requests to the console 

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

app.use(bodyParser({
    uploadDir: './public/upload'
}));

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

mongoose.connect('mongodb://localhost:27017/Server'); // connect to our database

//set server port
var portHttp = process.env.PORT || 8080;
var portHttps = process.env.PORT || 8000;

//define routers
var router = express.Router();
var routerRestuarant = express.Router();
var routerLocation = express.Router();

router.route('/')

.get(function(req, res) {
    res.render('index.jade');
})

.post(function(req, res) {
    res.render('index.jade');
});


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


router.route('/postupload').post(multipart(), function(req, res) {
    console.log(req.files)
    var date = new Date()
    var dateString = date.toISOString().slice(0, 19).replace(/-/g, "");
    if (req.files.files.originalFilename != undefined) {
        var filename = dateString.concat(req.files.files.originalFilename);
    } else {
        var filename = date;
    }
    //copy file to a public directory
    var targetPath = './public/upload/' + req.session.user._id + '.jpg';
    //copy file
    // fs.createReadStream(req.files.files.ws.path).pipe(fs.createWriteStream(targetPath));
    //return file url
    var tmp_path = req.files.files.path;
    fs.rename(tmp_path, targetPath, function(err) {
        if (err) throw err;
        // 删除临时文件夹文件, 
        fs.unlink(tmp_path, function() {
            if (err) throw err;
        });
    });

    res.json({
        code: 200,
        msg: {
            url: 'http://' + req.headers.host + '/upload/' + req.session.user._id + '.jpg'
        }
    });
    var url = 'http://' + req.headers.host + '/upload/' + req.session.user._id + '.jpg';
    upload.uploadUrl(url);
});

/*
    socket
    confirm order
*/


var onlineUser = {};
io.on('connection', function(socket) {
    socket.on('chat message', function(msg) {
        console.log('message: ' + msg);
    });

    socket.on('say to someone', function(id, to, msg) {
        //all[username] = socket.id;
        var online = Object.keys(io.sockets.adapter.rooms); //connected socket id array

        onlineUser[id] = socket.id;

        console.log(socket.id) //from socket id 
        console.log(id);
        console.log(to)
        console.log(online)
            //socket.emit('my message',msg,online[1],online[0]);
            //socket.broadcast.to(online[1]).emit('my message', msg);
        console.log("online1", online[0])
        console.log("online2", online[1])

        console.log(onlineUser)

        console.log(onlineUser[to])
        if (onlineUser[to]) {

            io.sockets.connected[onlineUser[to]].emit("my message", msg)
        }

    });


    socket.on('chat message', function(msg) {
        io.emit('chat message', msg);
    });


});


router.route('/confirm')

.get(function(req, res) {
    res.sendfile(path.join(__dirname, './views', 'confirm.html'));
})

// ----------------------------------------------------

router.route('/register')
    .get(function(req, res) {
        res.render('reg', {
            title: 'register'
        });
    })
    .post(function(req, res) {
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
                    Account.register(email, password, phone, name, res, function(doc) {
                        if (doc == null) {
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
    //copy file to a public directory
    console.log("avatar");
    console.log(req.files);
    var targetPath = './public/resources/avatar/' + req.session.user._id + '.jpg';
    //copy file
    // fs.createReadStream(req.files.files.ws.path).pipe(fs.createWriteStream(targetPath));
    //return file url
    var tmp_path = req.files.files.path;
    fs.rename(tmp_path, targetPath, function(err) {
        if (err) throw err;
        // 删除临时文件夹文件, 
        fs.unlink(tmp_path, function() {
            if (err) throw err;
        });
    });
    var url = 'http://' + req.headers.host + '/resources/avatar/' + req.session.user._id + '.jpg';


    var accountId = req.session.user._id;
    console.log(accountId);
    Account.uploadAvatar(accountId, url, function(err) {
        //console.log("save image");
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
                token: token,
                success: true
            });
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
    var token = req.body.token || req.param('token') || req.headers['x-access-token'] || req.session.userToken;
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
                    success: true
                })
            else {
                res.json({
                    success: false
                })
            }
        })
    });


router.route('/account/address')
    .get(function(req, res) {
        // var accountId = req.param('account', null);
        var accountId = req.decoded._id;
        Account.findAccountById(accountId, function(doc) {
            res.render('updateInfo.jade', {
                items: doc.address
            });
        })

    })

.put(function(req, res) {
    var accountId = req.decoded._id;
    //console.log(accountId)
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

router.route('/account/location')
    .get(function(req, res) {
        res.render('updateInfo.jade');
    })
    .put(function(req, res) {
        var accountId = req.decoded._id;
        //var accountId = req.session.user._id;
        var locationName = req.param("name", null);
        var coordinateString = req.param("coordinate", null);
        var coordinate = [Number(coordinateString.split(',')[0]),Number(coordinateString.split(',')[1])];
        //console.log('account/location'+coordinate.split(',')[0]);

        if (locationName != null && locationName != "") {
            Account.addLocation(accountId, locationName,coordinate, function(err) {
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
// Restuarant api =================================================================

routerRestuarant.route('/')
    .get(function(req, res) {
        res.send('routerRestuarant');
    })

.post(function(req, res) {
    res.send('routerRestuarant');
});

routerRestuarant.route('/create')
    .get(function(req, res) {
        res.sendfile(path.join(__dirname, './views', 'restaurant-post.html'));
    })
    .post(function(req, res) {
        var shopName = req.param('shopName', null);
        var location = req.param('location', null);
        var address = req.param('address', null);
        var shopPicUrl = req.param('shopPicUrl', null);
        var open = req.param('open', null);
        var shopType = req.param('shopType', null);



        /*        //copy file to a public directory
            console.log(req.files);
            var targetPath = './public/resources/avatar/' + 'test' + '.jpg';
            //copy file
            // fs.createReadStream(req.files.files.ws.path).pipe(fs.createWriteStream(targetPath));
            //return file url
            var tmp_path = req.files.files.path;
            console.log(tmp_path)
            fs.rename(tmp_path, targetPath, function(err) {
                if (err) throw err;
                // 删除临时文件夹文件, 
                fs.unlink(tmp_path, function() {
                    if (err) throw err;
                });
            });
            var url = 'http://' + req.headers.host + '/resources/avatar/' + 'test' + '.jpg';
            var accountId = req.session.user._id;
            console.log(accountId);
            Account.uploadAvatar(accountId, url, function(err) {
                //console.log("save image");
                if (null == err)
                    res.json({
                        code: 200,
                        msg: {
                            url: url
                        }
                    });
            })*/
        // Shop.createShop(shopName, address,location, shopPicUrl, open, shopType, res, function(err) {
        //     if (err == null) {
        //         Shop.findShop(shopName, function(doc) {
        //             res.json({
        //                 code: 200,
        //                 shop: doc,
        //                 success: true
        //             })
        //         })
        //     } else{
        //             res.json({
        //                 code: 400,
        //                 shop: err,
        //                 success: false
        //             })
        //     }

        // });


        for (var i = 0; i <15000 ; i++) {
            // var rand1 = Math.floor(Math.random()*100000000).toString();
            // var rand2 = Math.floor(Math.random()*100000000).toString();
            // var rand1 = (Math.random()*360 -180);
            // var rand2 = (Math.random()*360 -180);
            //var location = [116.331398,39.897445];
            var rand1 = (Math.random()*(41-38+1)+39);
            var rand2 = (Math.random()*(120-110+1)+110);

            location = [rand1,rand2];
                    Shop.createShop(rand1, address,location, shopPicUrl, open, shopType, res, function(err) {
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
         // res.json({
         //                code: 200,
         //                err: err,
         //                shop:doc,
         //                success: true
         //            })
    })


routerRestuarant.route('/createCover')
    .post(function(req, res) {
        var form = new formidable.IncomingForm();
        form.parse(req, function(err, fields, files) {
            if (err || !files.file) {
                res.json({
                    succeed: false,
                    status: 400,
                    errMsg: "上传失败"
                })
                return
            }
            var goalUrl = './public/resources/' + fields.shopName + '/';
            if (!fs.existsSync(goalUrl)) {
                fs.mkdirSync(goalUrl);
            }
            var targetPath = goalUrl + fields.shopName + '.jpg';
            var tmp_path = files.file.path;
            fs.rename(tmp_path, targetPath, function(err) {
                if (err) throw err;
                // 删除临时文件夹文件, 
                fs.unlink(tmp_path, function() {
                    if (err) throw err;
                });
            });
            var url = 'http://' + req.headers.host + '/resources/' + fields.shopName + '.jpg';
            Shop.uploadShopCover(fields.shopName, url, function(err) {
                if (null == err)
                    res.json({
                        code: 200,
                        msg: {
                            url: url
                        }
                    });
            })

        })
    })

routerRestuarant.route('/createDish')
    .post(function(req, res) {
        var dish = req.param('dish', null);
        var shopName = req.param('shopName', null);
        for (var i = 0; i < dish.length; i++) {
            Shop.addDish(shopName, dish[i], function(err) {
                if (null == err)
                    res.json({
                        code: 200
                    });
            })
        }
    })

routerRestuarant.route('/createDishPic')
    .post(function(req, res) {
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
            var goalUrl = './public/resources/' + fields.shopName + '/';
            if (!fs.existsSync(goalUrl)) {
                fs.mkdirSync(goalUrl);
            }
            if (!fs.existsSync(goalUrl + '/dishes/')) {
                fs.mkdirSync(goalUrl + '/dishes/');
            }
            for (var key in files) {
                var targetPath = goalUrl + '/dishes/' + files[key].name;
                var tmp_path = files[key].path;
                fs.renameSync(tmp_path, targetPath);
                var url = 'http://' + req.headers.host + '/resources/' + fields.shopName + '/dishes/' + files[key].name;
                console.log(url)
                console.log(key)
                Shop.addDishPic(fields.shopName, key, url, function(err) {
                    if (null == err){
                        res.json({
                            code: 200
                        });
                    }   
                });
            }
        })

        /* Shop.uploadShopCover(fields.shopName, url, function(err) {
             if (null == err)
                 res.json({
                     code: 200,
                     msg: {
                         url: url
                     }
                 });
         })*/
    })
// location routers-----------------------------------
routerLocation.route('/findlocation')

    .post(function(req,res){

     var searchLocation = req.param('locaiton');  
     console.log(searchLocation);
      request(
        { method: 'GET',
          header : {'Content-Type' : 'application/json; charset=UTF-8'},
          uri: URL.format({
              protocol: 'http',
              host: 'api.map.baidu.com',
              pathname: '/place/v2/suggestion',
              query: {
                  query: searchLocation,
                  region: '全国',
                  output: 'json',
                  ak: 't7vL8QtOIrdigs8b4l0rKwTreBGWFFhN',
              }
          }),
          json:true,
        }
      , function (error, response, body) {
          res.charset = 'UTF-8';
          res.json({
            res:response.body.result
          })

        }
      )

    });
routerLocation.route('/findshops')
.post(function(req,res){

      var distance = req.param('distance', null);
      var coordinate = req.param('coordinate', null);
      var location = [Number(coordinate.split(',')[0]),Number(coordinate.split(',')[1])];
      Shop.queryNearShops(location,distance,function(doc){
        res.json({
            shop:doc
        })
      })
});
// REGISTER OUR ROUTES -------------------------------
app.use('/user', router);
app.use('/shop', routerRestuarant);
app.use('/location',routerLocation);
// START THE SERVER
// =============================================================================
//http.createServer(app).listen(portHttp);
https.createServer(httpsOptions, app).listen(portHttps);

console.log('http listen ' + portHttp);
console.log('TSL listen ' + portHttps);
