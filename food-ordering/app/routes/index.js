
var routeInit = function (app,io,mongoose) {
  var express = require('express');
//var router = express.Router({ mergeParams: true });
var Shop = require('../models/Shop')(mailConfig, mongoose, nodemailer);
var Account = require('../models/Account')(mailConfig, mongoose, nodemailer);
var Order = require('../models/Order')(mongoose);
var mailConfig = {
    host: 'smtp.gmail.com',
    secureConnection: true,
    port: 465,
    auth: {
        user: 'foodtongcom@gmail.com',
        pass: 'comtongfood'
    }
}
var nodemailer = require('nodemailer');
var router = express.Router();

  router.use('/search', require('./searchRouter')(app,io,mongoose,Shop));
  router.use('/user', require('./userRouter')(app,io,mongoose,Account,Shop,Order));
  router.use('/shop', require('./shopRouter')(app,io,mongoose,Account,Shop,Order));
  //router.use('/order', require('./orderRouter')(app,io,mongoose,Account,Shop));

  return router;
};

module.exports = routeInit;
