module.exports = function( mongoose) {
  var ShopSchema = new mongoose.Schema({
    shopName:     { type: String, unique: true },
    location:     { type: String},
    shopPicUrl:      {type: String},
    shopPicTrueUrl:{type: String},
    mark:  { type: String},
    open:{type:Boolean},
    shopType:{type:String}
   /* address:   {type: [{
      name: { type: String},
      phone: { type: String},
      type: { type: String},
      addr: { type: String}
    }]},
    location: {type: [String]}*/
  });

  var Shop = mongoose.model('Shop', ShopSchema);

  var createShop = function(shopName, location, shopPicUrl, open,shopType,shopPicTrueUrl,res, callback) {
    var shopInstance = new Shop({
      shopName: shopName,
      location: location,
      shopPicUrl: shopPicUrl,
      open:open,
      shopType:shopType,
      shopPicTrueUrl:shopPicTrueUrl
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

  return {
    createShop: createShop,
    findShop:findShop
  }
}
