
var routeInit = function (app,io,mongoose) {
  //app.use('sessions', require('./sessions')(router));
  var express = require('express');
//var router = express.Router({ mergeParams: true });
var router = express.Router();
  // app.use('/test', require('./searchRouter')(router));
  // app.use('/user', require('./user')(app,io,mongoose));
  // app.use('/shop', require('./shop')(app,io,mongoose));
// router.use('/search', require('./searchRouter'));
// router.use('/user', require('./user'));
// router.use('/shop', require('./shop'));
  router.use('/location', require('./searchRouter')(app,io,mongoose));
  router.use('/user', require('./userRouter')(app,io,mongoose));
  router.use('/shop', require('./shopRouter')(app,io,mongoose));
  // app.use('/test', require('./searchRouter'));
  // app.use('/user', require('./user')(app,io,mongoose));
  // app.use('/shop', require('./shop')(app,io,mongoose));
  return router;
};

module.exports = routeInit;

// var 
//   express = require('express'),
//   router = express.Router();

//   router.use('/test', require('./searchRouter'));
//   router.use('/user', require('./user')(io,mongoose,app));
//   router.use('/shop', require('./shop')(io,mongoose,app));

// module.exports = router; 