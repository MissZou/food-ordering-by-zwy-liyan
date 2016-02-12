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

var httpsOptions = {
    key: fs.readFileSync('./https/server-key.pem'),
    cert: fs.readFileSync('./https/server-cert.pem'),
    requestCert: true,
    rejectUnauthorized: false
}

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

var portHttp = process.env.PORT || 8080; 
var portHttps = process.env.PORT || 8000; 

app.set('view engine', 'jade');



app.use(express.static(__dirname + '/public'));
//app.set('views', path.join(__dirname, 'views'));
app.use(morgan('dev')); // log requests to the console 
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//app.use(express.cookieParser());
//app.use(express.session({secret: "Food Ordering System", store: new MemoryStore()}));
mongoose.connect('mongodb://localhost:27017/Server'); // connect to our database


//set server port


var router = express.Router();


router.route('/')

	.get(function(req, res){
		res.render('index.jade');
	})

	.post(function(req, res){
		res.render('index.jade');
	});

// ----------------------------------------------------
router.route('/register')
	
	.get(function(req,res){
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
  		res.render('resetPassword.jade', {accountId:accountId});// delete local.
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
http.createServer(app).listen(portHttp);
https.createServer(httpsOptions,app).listen(portHttps);

console.log('http listen ' + portHttp);
console.log('TSL listen ' + portHttps);