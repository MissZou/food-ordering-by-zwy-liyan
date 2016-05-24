module.exports = function( mongoose) {
  var ShopSchema = new mongoose.Schema({
    shopName:     { type: String, unique: true },
    address:     { type: String},
    location:{type:[Number],index: '2d'},
    shopPicUrl:      {type: String},
    shopPicTrueUrl:{type: String},
    mark:  { type: String},
    open:{type:Boolean},
    shopType:{type:String},
    dish:   {type: [{
      dishName: { type: String},
      tags: { type: Array},
      price: { type: Number},
      intro: { type: String},
      dishPic:{ type: String},
      index:{type:Number}
    }]}
    
  });

  var Shop = mongoose.model('Shop', ShopSchema);
//  var Product = require('ProductModel')(mongoose);

  var createShop = function(shopName, address,location, shopPicUrl, open,shopType,res, callback) {
    var shopInstance = new Shop({
      shopName: shopName,
      address: address,
      location: location,
      shopPicUrl: shopPicUrl,
      open:open,
      shopType:shopType
      //shopPicTrueUrl:shopPicTrueUrl
    });
    shopInstance.save(function(err){
      callback(err);
    });
  };

   var findShop = function(shopName, callback) {
    Shop.findOne({shopName:shopName}, function(err,doc){
        callback(doc);
    })
  }

  var uploadShopCover = function(shopName, shopPicTrueUrl, callback) {
    Shop.update({shopName:shopName}, {$set:{shopPicTrueUrl:shopPicTrueUrl}},{upsert:false},
      function(err){
        callback(err);
      });
};

var addDish = function(shopName, newDish, callback) {
        Shop.update({shopName:shopName}, {$push: {dish:{
          "dishName":newDish.dishName,
          "tags":newDish.tags,
          "price":newDish.price,
          "intro":newDish.intro,
          "index":newDish.index
        }}},{upsert:true},
      function (err) {
        console.log(err)
        callback(err);
    });
};

var addDishPic = function(shopName, key,url, callback) {
  Shop.findOne({ shopName: shopName},
  function (err,doc) {
  doc.dish.forEach(function (event) {
      if (event.index ==key) {
        event.dishPic=url;
      }
    });
   doc.save();
  })
};

var queryNearShops = function(loc,distance,callback){
//   var options = { near: location, maxDistance: 1000000 };
//   Shop.geoNear(location, { maxDistance : 100000000, spherical : false }, function(err, results, stats) {
//    console.log(results);
//    console.log(err);
//    console.log(stats);
//    callback(results);
// });
var maxDistance = distance;
  Shop.find({location:{$near:loc,$maxDistance: maxDistance}}).limit(15).exec(function(err, doc) {
      if (err) {
        console.log(err);
      }

      callback(doc);
    });

};

  return {
    createShop: createShop,
    findShop:findShop,
    uploadShopCover:uploadShopCover,
    addDish:addDish,
    addDishPic:addDishPic,
    queryNearShops:queryNearShops
  }
}
