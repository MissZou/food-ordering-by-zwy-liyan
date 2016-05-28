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
      userId:{type: String},
       comment:{type:[{
         date:{type: Date,default: Date.now},
         userId:{type: String},
         content:{type: String}
       }]} 
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

  var createShop = function(email,password,shopName, address,location, open,shopType, callback) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(password);
    var shopInstance = new Shop({
      email: email,
      password: shaSum.digest('hex'),
      shopName: shopName,
      address: address,
      location: location,
      
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

  var findShopByName = function(shopName, callback){
    // Shop.find({shopName:RegExp(shopName)},function(err,doc){
    //   callback(doc);
    // })
    var loc = [39.956578, 116.327024];
    //Shop.find({shopName:RegExp(shopName)},{location:{$near:loc,$maxDistance: 50}}).limit(15).exec(function(err,doc){
      Shop.find({shopName:RegExp(shopName)}).limit(15).exec(function(err,doc){
      if (err) {
        callback(err);  
      }
          var shopArray = {};
      for (var i = doc.length - 1; i >= 0; i--) {
        //shopArray.push(doc[i].shopName,doc[i]._id);
        shopArray[doc[i].shopName] = [doc[i]._id];
      }
      
      callback(shopArray);
    })
  }


 // var findShopsAndDishs = function(searchText,location, callback){
   //   // Shop.find({shopName:RegExp(shopName)},function(err,doc){
   //   //   callback(doc);
   //   // }
  //   ///var loc = [39.956578, 116.327024];
 
   //   Shop.find({location:{$near:location,$maxDistance: 25},shopName:RegExp(searchText)}).limit(15).exec(function(err,doc){
   //           if (err) {
  //       callback(err);  
   //     }
  //         var shopArray = {};
   //     for (var i = doc.length - 1; i >= 0; i--) {
  //       //shopArray.push(doc[i].shopName,doc[i]._id);
   //       shopArray[doc[i].shopName] = [doc[i]._id];
   //     }
       
   //     callback(shopArray);
   //   })
   // }
 
   var findShopsAndDishs = function(searchText,location, callback){
    // Shop.find({shopName:RegExp(shopName)},function(err,doc){
    //   callback(doc);
    // }
    ///var loc = [39.956578, 116.327024];

   Shop.find({location:{$near:location,$maxDistance: 25}}).limit(15).exec(function(err, doc) {
        if (err) {
           console.log(err);
         }
         var shopArray = [];
 
         for (var i = doc.length - 1; i >= 0; i--) {
             var obj={};        
             var isFindShop = false;
           if (doc[i].shopName) {
             if (doc[i].shopName.indexOf(searchText)>=0 ) {
                 //shopArray[doc[i].shopName] = [doc[i]._id];    
                 obj[doc[i].shopName]=doc[i]._id;
                 //shopArray.push(obj);
                 //shopArray.push(doc[i].shopName+':'+doc[i]._id);
                isFindShop = true;
             }
             if (doc[i].dish.length != 0) {
 
              for (var j = doc[i].dish.length - 1; j >= 0; j--) {

                   if (doc[i].dish[j].dishName.indexOf(searchText)>=0) {
                      //shopArray[doc[i].shopName] = [doc[i].dish[j].dishName];       
                      //shopArray.push(doc[i].shopName+':'+doc[i].dish[j].dishName);
                     
                     obj["dish"]=doc[i].dish[j].dishName;
                     //obj[doc[i].shopName]=doc[i]._id;
                     //shopArray.push(obj);
                   }
               }
             }
             if (isFindShop) {
 
               shopArray.push(obj);
            }

           }
         }
         callback(shopArray);
       });
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
          console.log("add dish err");
           console.log(err);
          callback(err);  
        }else{
          console.log("add dish doc");
           console.log(doc);
          callback(doc);
        }
        
    });
};


var addDishPic = function(shopId, key,url, callback) {
  Shop.findOne({ _id:shopId},
  function (err,doc) {
  doc.dish.forEach(function (event) {
      if (event.dishName ==key) {
        event.dishPic=url;
      }
    });
   doc.save();
  })
};

// var findDishs = function(shopId,callback){
//   Shop.find({_id,shopId},)
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
    addDishPic:addDishPic,
    queryNearShops:queryNearShops,
    findShopByName:findShopByName,
    findShopsAndDishs:findShopsAndDishs
  }
}
