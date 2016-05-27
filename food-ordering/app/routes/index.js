
var routeInit = function (app,io,mongoose) {
  var express = require('express');
//var router = express.Router({ mergeParams: true });
var router = express.Router();

  router.use('/search', require('./searchRouter')(app,io,mongoose));
  router.use('/user', require('./userRouter')(app,io,mongoose));
  router.use('/shop', require('./shopRouter')(app,io,mongoose));

  return router;
};

module.exports = routeInit;
