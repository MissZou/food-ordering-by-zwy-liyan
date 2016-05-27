var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var morgan = require('morgan');
//var crypto = require('crypto');
//var nodemailer = require('nodemailer');

var mongoose = require('mongoose');
var https = require('https');
var http = require('http')
var fs = require('fs');
var session = require('express-session');
//var multipart = require('connect-multiparty');
//var jwt = require('jsonwebtoken'); // used to create, sign, and verify tokens
var path = require('path');
var formidable = require('formidable');
var util = require('util');
//var request = require('request');
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

//var Account = require('./app/models/Account')(mailConfig, mongoose, nodemailer);
//var Shop = require('./app/models/Shop')(mongoose);
//var upload = require('./app/models/upload')(mongoose);
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
// var router = express.Router();
// var routerRestuarant = express.Router();
// var routerLocation = express.Router();
//var routerSearch = express.Router();
//var routerSearch = require('./app/routes/searchRouter')(app);
//var routerSearch = require('./app/routes/index')(app);


//app.use('/', require('./app/routes/index')(app,io,mongoose));
// app.use(function(req, res, next) {
//   req.components = {
//     io: io, 
//     mongo: mongoose,
//     app: app
//   };
//   next();
// });
app.use(require('./app/routes/index')(app,io,mongoose));



// location routers-----------------------------------

// REGISTER OUR ROUTES -------------------------------
// app.use('/userold', router);
// app.use('/shopold', routerRestuarant);
// app.use('/locationold',routerLocation);
//app.use('/search',routerSearch);
// START THE SERVER
// =============================================================================
//http.createServer(app).listen(portHttp);
https.createServer(httpsOptions, app).listen(portHttps);

console.log('http listen ' + portHttp);
console.log('TSL listen ' + portHttps);
