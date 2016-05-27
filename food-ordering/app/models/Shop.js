module.exports = function(config, mongoose, nodemailer) {
  var crypto = require('crypto');
  var ShopSchema = new mongoose.Schema({
    email:{ type: String, unique: true },
    password:{type: String},
    shopName:     { type: String},
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
      index:{type:Number},
      comment:{type:[{
        date:{type: Date,default: Date.now},
        userId:{type: String},
        content:{type: String}
      }]}
    }]},

//    dish:{type:[DishSchema]},

    order:{type:[{
      orderId:{type: String},
      date:{type: Date,default: Date.now},
      dishs:{type: [{
        _id:{type: String},
        number:{type: Number}
      }]},
      userId:{type: String}
    }]}
    
  });

// var DishSchema = new mongoose.Schema({
//   dishName: { type: String},
//       tags: { type: Array},
//       price: { type: Number},
//       intro: { type: String},
//       dishPic:{ type: String},
//       index:{type:Number},
//       comment:{type:[{
//         date:{type: Date,default: Date.now},
//         userId:{type: String},
//         content:{type: String}
//       }]}
//     });

  var Shop = mongoose.model('Shop', ShopSchema);
//  var Product = require('ProductModel')(mongoose);

  var createShop = function(email,password,shopName, address,location, shopPicUrl, open,shopType, callback) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(password);
    var shopInstance = new Shop({
      email: email,
      password: shaSum.digest('hex'),
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

  var login = function(email, password,req, callback) {
        var shaSum = crypto.createHash('sha256');
        shaSum.update(password);
        Shop.findOne({email:email,password:shaSum.digest('hex')},function(err,doc){
            req.session.user = doc;
            callback(doc);
            //console.log(doc);

            //return doc._id;
        });

    };
   var findShop = function(email, callback) {
    Shop.findOne({email:email}, function(err,doc){
        callback(doc);
    })
  }

  var findShopById = function(id, callback) {
    Shop.findOne({_id:id}, function(err, doc){
      callback(doc);
    })
  }
  var changePassword = function(shopId, newpassword) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(newpassword);
    var hashedPassword = shaSum.digest('hex');
    Shop.update({_id:shopId}, {$set: {password:hashedPassword}},{upsert:false},
      function changePasswordCallback(err) {
        console.log('Change password done for shopId ' + shopId);
    });
  };

  var forgotPassword = function(email, resetPasswordUrl, callback) {
    var user = Shop.findOne({email: email}, function findShop(err, doc){
      if (err) {
        // Email address is not a valid user

      } else {
        var smtpTransport = nodemailer.createTransport('SMTP', config);
        resetPasswordUrl += '?shopId=' + doc._id;
        //console.log('sendmail');
        smtpTransport.sendMail({
          from: 'thisapp@example.com',
          to: doc.email,
          subject: 'FoodTong Password Request',
          text: 'Click here to reset your password: ' + resetPasswordUrl
        }, function forgotPasswordResult(err) {
          if (err) {
            console.log(err);
            callback(false);
          } else {
            callback(true);
          }
        });
      }
    });
  };

  var uploadShopCover = function(shopId, shopPicTrueUrl, callback) {
    Shop.update({_id:shopId}, {$set:{shopPicTrueUrl:shopPicTrueUrl}},{upsert:false},
      function(err){
        callback(err);
      });
};

var addDish = function(shopId, newDish, callback) {
        Shop.update({_id:shopId}, {$push: {dish:{
          "dishName":newDish.dishName,
          "tags":newDish.tags,
          "price":newDish.price,
          "intro":newDish.intro,
          "index":newDish.index
        }}},{upsert:true},
      function (err,doc) {
        if (err != null) {
          callback(err);  
        }else{
          callback(doc);
        }
        
    });
};

// var findDishs = function(shopId,callback){
//   Shop.find({_id,shopId},)
// };

// var addDishPic = function(shopName, key,url, callback) {
//   Shop.findOne({ shopName: shopName},
//   function (err,doc) {
//   doc.dish.forEach(function (event) {
//       if (event.index ==key) {
//         event.dishPic=url;
//       }
//     });
//    doc.save();
//   })
// };

// var addDish = function(shopId, newDish, callback) {
//   Shop.dish.create({
//           "dishName":newDish.dishName,
//           "tags":newDish.tags,
//           "price":newDish.price,
//           "intro":newDish.intro,
//           "index":newDish.index
//   });
// };

var queryNearShops = function(loc,distance,callback){
  var maxDistance = distance;
    Shop.find({location:{$near:loc,$maxDistance: maxDistance}}).limit(15).exec(function(err, doc) {
        if (err) {
          console.log(err);
        }

        callback(doc);
      });
};

var addComments = function(dishId,date,contnet,userId){
  Shop.find({_id:dishId},{$pull:{comment:{
    "content":content,
    //"date":date,
    "userId":userId
  }}})
};



  return {
    createShop: createShop,
    findShop: findShop,
    findShopById: findShopById,
    uploadShopCover:uploadShopCover,
    addDish:addDish,
    forgotPassword: forgotPassword,
    changePassword: changePassword,
    login: login,
    //addDishPic:addDishPic,
    queryNearShops:queryNearShops
  }
}
