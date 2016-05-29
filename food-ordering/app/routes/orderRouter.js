var routeOrder = function (app,io,mongoose,Account,Shop) {
	var express = require('express');
	var router = express.Router();

	var request = require('request');
	var URL = require('URL');
	var bodyParser = require('body-parser');
	var path = require('path');
	app.use(bodyParser.urlencoded({
	    extended: true
	}));
	app.use(bodyParser.json());

	var jwt = require('jsonwebtoken');

	var userTokenConfig = {
	    'secret': 'wochengrenwokanbudongzhegetokenshiTMzmlaide',
	    'database': 'mongodb://localhost:27017/Server'
	}
	app.set('userTokenScrete', userTokenConfig.secret);

	var shopTokenConfig = {
    'secret': 'zhegeshishopdetakensecretwochongxinxieleyige',
    'database': 'mongodb://localhost:27017/Server'
	}
	app.set('shopTokenScrete', shopTokenConfig.secret);

	


	router.use("/user", function(req, res, next) {

    // check header or url parameters or post parameters for token
    var token = req.body.token || req.param('token') || req.headers['x-access-token'] || req.session.userToken;
    // decode token
    if (token) {
        // verifies secret and checks exp
        jwt.verify(token, app.get('userTokenScrete'), function(err, decoded) {
            if (err) {
                return res.json({ success: false, message: 'Failed to authenticate token.' });
            } else {
                // if everything is good, save to request for use in other routes
                req.decodedUser = decoded;
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



	router.use("/shop", function(req, res, next) {

    // check header or url parameters or post parameters for token
    var token = req.body.token || req.param('token') || req.headers['x-access-token'] || req.session.userToken;
    // decode token
    if (token) {
        // verifies secret and checks exp
        jwt.verify(token, app.get('shopTokenScrete'), function(err, decoded) {
            if (err) {
                return res.json({ success: false, message: 'Failed to authenticate token.' });
            } else {
                // if everything is good, save to request for use in other routes
                req.decodedShop = decoded;
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

	router.route('/shop/order')
	.post(function(req,res){
		res.json({
			id:req.decodedShop._id,
			msg:"/shop/order"
		})
	})

	router.route('/user/order')
	.post(function(req,res){
		res.json({
			id:req.decodedUser._id,
			msg:"/user/order"
		})
	})
	return router;
};

module.exports = routeOrder;