
var routeShop = function (app,io,mongoose) {
//var routeShop = function () {
//var session = require('express-session');
var 
  express = require('express'),
  router = express.Router();
var request = require('request');
var URL = require('URL');
var bodyParser = require('body-parser');
var Shop = require('../models/Shop')(mongoose);
var path = require('path');

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

app.use(bodyParser({
    uploadDir: './public/upload'
}));

// app.use(session({
//     secret: 'secret',
//     cookie: {
//         path: '/',
//         maxAge: 1000 * 60 * 30
//     }
// }));

//routers
router.route('/')
.get(function(req, res) {
        res.send('routerRestuarant');
    })

.post(function(req, res) {
    res.send('routerRestuarant');
})

.put(function(req,res){
    res.json({
        msg:"new shop.js router"
    })
});

router.route('/create')
    .get(function(req, res) {
        //res.sendfile(path.join(__dirname, './views', 'restaurant-post.html'));
        res.sendfile(path.join(__dirname, '../../views', 'restaurant-post.html'));
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


        for (var i = 0; i <100000 ; i++) {
            var rand2 = (Math.random()*(117.4-115.7+1)+115.7);
            var rand1 = (Math.random()*(41.6-39.4+1)+39.4);
            //var location = [116.331398,39.897445];
            // var rand1 = (Math.random()*(41-38+1)+39);
            // var rand2 = (Math.random()*(120-110+1)+110);

            location = [rand1,rand2];

                    Shop.createShop(Math.random().toString(36).substring(7), address,location, shopPicUrl, open, shopType, res, function(err) {
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


router.route('/createCover')
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

router.route('/createDish')
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

router.route('/createDishPic')
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
    });
router.route('/findshops')
.post(function(req,res){
    
    var distance = req.param('distance', null);
    var coordinateTemp = req.param('coordinate', null);
    //console.log(typeof coordinateTemp);
    //console.log(coordinateTemp);
    
    var coordinate = JSON.stringify(coordinateTemp);
    coordinate = coordinate.split(',');
    coordinate[0] = coordinate[0].replace(/[^0-9.]/g,'');
    coordinate[1] = coordinate[1].replace(/[^0-9.]/g,'');
    
     // console.log(coordinate[0]);
     // console.log(coordinate[1]);
    
    if (coordinate !=null && distance !=null) {
        var location = [Number(coordinate[0]),Number(coordinate[1])];
        Shop.queryNearShops(location,distance,function(doc){
           res.json({
               shop:doc
            })
          })  
      }  
      else{
            res.json({
               code:400
            })
      }
      
});

  return router;
};

module.exports = routeShop;
//module.exports = router; 