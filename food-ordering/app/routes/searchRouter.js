var routeSearch = function (app,io,mongoose,Shop) {
	var 
	  express = require('express'),
	  router = express.Router();

	var request = require('request');
	var URL = require('URL');
	var bodyParser = require('body-parser');
	var path = require('path');
	app.use(bodyParser.urlencoded({
	    extended: true
	}));
	app.use(bodyParser.json());

// router.route('/')
// .get(function(req, res) {
//         res.send('location');
//     })

// .post(function(req, res) {
//     res.send('location');
// })

// .put(function(req,res){
//     res.json({
//         msg:"new search.js router"
//     })
// });

router.route('/')
.post(function(req,res){
	var searchText = req.param('searchText');  
	var coordinateTemp = req.param('location', null);    
   	console.log(coordinateTemp);
	if (searchText != null) { 
		var coordinate = JSON.stringify(coordinateTemp);
	    coordinate = coordinate.split(',');
	    coordinate[0] = coordinate[0].replace(/[^0-9.]/g,'');
	    coordinate[1] = coordinate[1].replace(/[^0-9.]/g,'');
		
		var location = [Number(coordinate[0]),Number(coordinate[1])];
		var location = [39.956578, 116.327024]; //for test purpose
		Shop.findShopsAndDishs(searchText,location,function(doc){
		res.json({
			result:doc
			})
		})
	}

});

router.route('/findlocation')

    .post(function(req,res){

     var searchLocation = req.param('locaiton');  
     
      request(
        { method: 'GET',
          header : {'Content-Type' : 'application/json; charset=UTF-8'},
          uri: URL.format({
              protocol: 'http',
              host: 'api.map.baidu.com',
              pathname: '/place/v2/suggestion',
              query: {
                  query: searchLocation,
                  region: '全国',
                  output: 'json',
                  ak: 't7vL8QtOIrdigs8b4l0rKwTreBGWFFhN',
              }
          }),
          json:true,
        }
      , function (error, response, body) {
        //console.log(response);
          res.charset = 'UTF-8';
          if (response) {
            var result = response.body.result;
            for(var i = 0;i<result.length;i++){
                 if (result[i].location == null) {
                    console.log(result[i].name);
                    result.splice(i,1);
                    i=-1;continue;
                }
            }
                res.json({
                res:result
              })
              
              
          }
          else{
          	 res.json({
                res:null
              })
          }
        }
      )

    });


    

  return router;
};

module.exports = routeSearch;
//module.exports = router; 