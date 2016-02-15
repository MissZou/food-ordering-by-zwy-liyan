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


var multipart = require('connect-multiparty');



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

var cookieSession = require('cookie-session');


var Account = require('./app/models/Account')(mailConfig, mongoose, nodemailer);
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

//app.use(express.cookieParser());
//app.use(express.session({secret: "Food Ordering System", store: new MemoryStore()}));
mongoose.connect('mongodb://localhost:27017/Server'); // connect to our database

//set server port
var portHttp = process.env.PORT || 8080;
var portHttps = process.env.PORT || 8000;

var router = express.Router();
var routerRestuarant = express.Router();

// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
// router.get('/', function(req, res) {
// 	//res.json({ message: 'hooray! welcome to our api!' });	

// });

router.route('/')

.get(function(req, res) {
    res.render('index.jade');
})

.post(function(req, res) {
    res.render('index.jade');
});


router.route('/upload')
    .get(function(req, res) {
        res.render('upload.jade');
    });

router.route('/postupload').post(multipart(), function(req, res) {
    console.log(req.files)
    var date = new Date()
    var dateString = date.toISOString().slice(0,19).replace(/-/g,"");
    if (req.files.files.originalFilename != undefined) {
         var filename = dateString.concat(req.files.files.originalFilename);
     }
   else {
        var filename = date;
   }
    //copy file to a public directory
    var targetPath = './public/upload/' + filename;
    //copy file
    // fs.createReadStream(req.files.files.ws.path).pipe(fs.createWriteStream(targetPath));
    //return file url
    var tmp_path = req.files.files.path;
    fs.rename(tmp_path, targetPath, function(err) {
        if (err) throw err;
        // 删除临时文件夹文件, 
        fs.unlink(tmp_path, function() {
            if (err) throw err;
            //res.send('File uploaded to: ' + targetPath + ' - ' + req.files.files.size + ' bytes');
        });
    });

    res.json({
        code: 200,
        msg: {
            url: 'http://' + req.headers.host + '/upload/' + filename
        }
    });
    var url='http://' + req.headers.host + '/upload/' + filename;
    upload.uploadUrl(url);
});


//console.log(req.body.image)
//upload.upload(req.body.image, res);
//upload.uploadUrl(req,res);
/*		var tmp_path = req.files.thumbnail.path;
    // 指定文件上传后的目录 - 示例为"images"目录。 
    var target_path = './public/upload/' + req.files.thumbnail.name;
    // 移动文件*/





/*router.route('/out')
	.get(function(req,res){
		upload.getImage(req.body.image, res);
		res.render('out',{
			dbimage:"address"
		});
    })*/


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
            null == name || name.length < 1 || null==phone || phone.length < 1) { 
            res.send(400);
            return;
        }
        else {
                Account.foundAccount(email, function(doc){
                if (doc == true) {
                    res.send("Account has been used");
                }
                else{
                    Account.register(email, password, phone, name, res);
                }
            })
        }
    });


router.route('/login')

.post(function(req, res) {
    console.log('login request');
    var email = req.param('email', null);
    var password = req.param('password', null);
    //console.log(req);

    if (null == email || email.length < 1 || null == password || password.length < 1) {
        res.send(400);
        return;
    };

    Account.login(email, password, function(doc) {
        if (doc != null)
        {
            res.json({
                code:200,
                accountId: doc._id

            });   
        }
        else {
            res.json({
                code:400
            })
        }
    });

});

router.route('/forgetpassword')

.post(function(req, res) {
    var hostname = req.headers.host;
    var resetPasswordUrl = 'http://' + hostname + '/api/resetPassword';
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
// Restuarant --------------------------

routerRestuarant.route('/')
.get(function(req, res) {
    res.send('routerRestuarant');
})

.post(function(req, res) {
    res.send('routerRestuarant');
});

// REGISTER OUR ROUTES -------------------------------
app.use('/user', router);
app.use('/shop', routerRestuarant);
// START THE SERVER
// =============================================================================
http.createServer(app).listen(portHttp);
https.createServer(httpsOptions, app).listen(portHttps);

console.log('http listen ' + portHttp);
console.log('TSL listen ' + portHttps);
