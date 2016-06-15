
var routeInit = function (app,io,mongoose) {
  var express = require('express');
//var router = express.Router({ mergeParams: true });
var nodemailer = require('nodemailer');
var mailConfig = {
    host: 'smtp.gmail.com',
    secureConnection: true,
    port: 465,
    requiresAuth: true,
    //domains: ["gmail.com", "googlemail.com"],
    auth: {
        user: 'foodtongcom@gmail.com',
        pass: 'comtongfood'
    }
}

var smtpConfig = nodemailer.createTransport({
host: "smtp.gmail.com",
secureConnection: false,
port: 587,
requiresAuth: true,
domains: ["gmail.com", "googlemail.com"],
auth: {
user: "foodtongcom@gmail.com",
pass: "comtongfood"
}
});

var smtpTransport = nodemailer.createTransport({
    host: 'smtp.1blu.de',
    secureConnection: true,
    port: 465,
    auth: {
       user: 'foodtongcom@gmail.com',
       pass: 'comtongfood'
    },
    tls:{
        secureProtocol: "TLSv1_method"
    }
});
console.log('SMTP Configured');

var Shop = require('../models/Shop')(mailConfig, mongoose, nodemailer);
var Account = require('../models/Account')(mailConfig, mongoose, nodemailer);
var Order = require('../models/Order')(mongoose);
var onlineUser = {};

var router = express.Router();

  router.use('/search', require('./searchRouter')(app,io,mongoose,Shop));
  router.use('/user', require('./userRouter')(app,io,mongoose,Account,Shop,Order,onlineUser));
  router.use('/shop', require('./shopRouter')(app,io,mongoose,Account,Shop,Order,onlineUser));
  //router.use('/order', require('./orderRouter')(app,io,mongoose,Account,Shop));

  return router;
};

module.exports = routeInit;
