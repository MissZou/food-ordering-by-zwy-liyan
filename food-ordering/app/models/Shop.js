module.exports = function( mongoose) {
  var ShopSchema = new mongoose.Schema({
    shopName:     { type: String, unique: true },
    location:     { type: String},
    shopPicUrl:      {type: String},
    shopPicTrueUrl:{type: String},
    mark:  { type: String},
    open:{type:Boolean},
    shopType:{type:String},
    dish:   {type: [{
      dishName: { type: String},
      tags: { type: Array},
      price: { type: Number},
      intro: { type: String}
    }]}
    
  });

  var Shop = mongoose.model('Shop', ShopSchema);

  var createShop = function(shopName, location, shopPicUrl, open,shopType,res, callback) {
    var shopInstance = new Shop({
      shopName: shopName,
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
          "intro":newDish.intro
        }}},{upsert:true},
      function (err) {
        console.log(err)
        callback(err);
    });
};


  return {
    createShop: createShop,
    findShop:findShop,
    uploadShopCover:uploadShopCover,
    addDish:addDish
  }
}
