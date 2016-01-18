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
//var fs = require('fs');

// var httpsOptions = {
// 	key: fs.readFileSync('./key.pem'),
// 	cert: fs.readFileSync('./cert.pem')
// }

app.set('view engine', 'jade');
var mailConfig = {
		host : 'smtp.gmail.com',
		secureConnection : true,
  		port: 465,
	    auth: {
	        user: 'foodtongcom@gmail.com',
	        pass: 'comtongfood'
	    }	
}

var cookieSession = require('cookie-session');


var Account = require('./app/models/Account')(mailConfig, mongoose, nodemailer);
app.use(express.static(__dirname + '/public'));
//app.set('views', path.join(__dirname, 'views'));
app.use(morgan('dev')); // log requests to the console 
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//app.use(express.bodyParser());
//app.use(express.cookieParser());
//app.use(express.session({secret: "Food Ordering System", store: new MemoryStore()}));
mongoose.connect('mongodb://localhost:27017/Server'); // connect to our database

var port = process.env.PORT || 8080; // set our port
var router = express.Router();


// test route to make sure everything is working (accessed at GET http://localhost:8080/api)
// router.get('/', function(req, res) {
// 	//res.json({ message: 'hooray! welcome to our api!' });	
	
// });

router.route('/')

	.get(function(req, res){
		res.render('index.jade');
	})

	.post(function(req, res){
		res.render('index.jade');
	});

// on routes that end in /bears
// ----------------------------------------------------
router.route('/register')
	.get(function(req,res){
		res.render('reg', {
        title: '注册'
    });
	})
	.post(function(req, res) {
		console.log(req);	
		console.log(req.body.name);
		
		Account.register(req.body.email, req.body.password, req.body.phone, req.body.name, res);	
	});


router.route('/login')

	.post(function(req, res){
		console.log('login request');
  		var email = req.param('email', null);
  		var password = req.param('password', null);
  		console.log(req);
  		
  		if (null == email || email.length < 1 || null == password || password.length < 1) { 
  			res.send(400);
  			return;
  		};

  		Account.login(email, password, function(doc){
  			res.send(doc);
  		});

	});

router.route('/forgetpassword')
	
	.post(function(req, res){
		var hostname = req.headers.host;
  		var resetPasswordUrl = 'http://' + hostname + '/api/resetPassword';
  		var email = req.param('email', null);
  		if ( null == email || email.length < 1 ) {
    		res.send(400);
		    return;
		  }

		  Account.forgotPassword(email, resetPasswordUrl, function(success){
		    if (success) {
		      res.send(200);
		      console.log('email has sent.');
		    } else {
		      // Username or password not found
		      res.send(404,'404 not found');
		    }
		  });
	});

router.route('/resetPassword')
	
	.get(function(req, res){
		var accountId = req.param('account', null);
  		res.render('resetPassword.jade', {accountId:accountId});
	})

	.post(function(req, res){
		console.log('resetPassword post');
		var accountId = req.param('accountId', null);
		var password = req.param('password', null);
		if ( null != accountId && null != password ) {
		  Account.changePassword(accountId, password);
		}
		else {
			console.log('err');
		}
		res.render('resetPasswordSuccess.jade');
	});

// REGISTER OUR ROUTES -------------------------------
app.use('/api', router);

// START THE SERVER
// =============================================================================
//app.listen(port);
// var appHttps = https.createServer(httpsOptions, function (req, res) {
//   res.writeHead(200);
//   res.end("hello world\n");
// }).listen(port);
http.createServer(app).listen(port);
//https.createServer(httpsOptions,app).listen(port);

console.log('http listen ' + port);