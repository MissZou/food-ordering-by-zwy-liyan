module.exports = function(config, mongoose, nodemailer) {
  var crypto = require('crypto');
  //var Order = require('Order');
  var ShopSchema = new mongoose.Schema({
    email:{ type: String, unique: true },
    password:{type: String},
    shopName:     { type: String},
    address:     { type: String},
    location:{type:[Number],index: '2d'},
    shopPicUrl:      {type: String},
    mark:  { type: Number},
    open:{type:Boolean},
    shopType:{type:String},
    
    dish:   {type: [{
      dishName: { type: String},
      tags: { type: Array},
      price: { type: Number},
      intro: { type: String},
      dishPic:{ type: String},
      index:{type:Number},
      category:{type: String},
      comment:{type:[{
        date:{type: Date,default: Date.now},
        userId:{type: mongoose.Schema.Types.ObjectId, ref:'Account'},
        mark:{type:Number},
        content:{type: String}
      }]}
    }]},
    //orders:{order: [{type: mongoose.Schema.Types.ObjectId, ref:'Order'}] }
    orders:{type:[{
      order:{type: mongoose.Schema.Types.ObjectId, ref:'Order'}
    }]}
    
  });


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
 
var changeShopInfo = function(shopId,shop,callback){
      Shop.findOne({_id:shopId},function(err,doc){
      if (err) {
        console.log(err);
      }else{
        
       if (shop.shopPicUrl != null) {
          doc.shopPicUrl = shop.shopPicUrl;
          doc.markModified("shopPicUrl");        
       }
        doc.save(function(err,doc){
          console.log(doc);
          callback(doc);
        });


      }
    })
}

   var findShopsAndDishs = function(searchText,location, callback){
    // Shop.find({shopName:RegExp(shopName)},function(err,doc){
    //   callback(doc);
    // }
    ///var loc = [39.956578, 116.327024];

   Shop.find({location:{$near:location,$maxDistance: 25}}).limit(150).exec(function(err, doc) {
        if (err) {
           console.log(err);
         }
         var shopArray = [];
 
         for (var i = doc.length - 1; i >= 0; i--) {
             var obj={};        
             var isFindShop = false;
             var isFindDish = false;
           if (doc[i].shopName) {
             if (doc[i].shopName.indexOf(searchText)>=0 ) {
                 //shopArray[doc[i].shopName] = [doc[i]._id];    
                 obj[doc[i].shopName]=doc[i]._id;
                isFindShop = true;
             }
             if (doc[i].dish.length != 0) {
 
              for (var j = doc[i].dish.length - 1; j >= 0; j--) {

                   if (doc[i].dish[j].dishName.indexOf(searchText)>=0) {
                       isFindDish = true        
                        obj["dish"]=doc[i].dish[j].dishName;
                        obj["dishId"]=doc[i].dish[j]._id;
                      if (!isFindShop) {
                          obj[doc[i].shopName]=doc[i]._id;
                      }
                   }
               }
             }
             if (isFindShop) {
               shopArray.push(obj);
            }
              if (!isFindShop && isFindDish) {
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
    Shop.update({_id:shopId}, {$set:{shopPicUrl:shopPicTrueUrl}},{upsert:false},
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

var changeDishInfo = function(shopId, dish, callback){
    
    Shop.findOne({_id:shopId},function(err,doc){
      if (err) {
        console.log(err);
      }else{
        
        if (dish.price != null) {
          doc.dish.id(dish._id).price = dish.price;  
        }
        if (dish.dishName != null) {
          doc.dish.id(dish._id).dishName = dish.dishName;  
        }
        if (dish.intro != null) {
          doc.dish.id(dish._id).intro = dish.intro;  
        }
        if (dish.dishPic != null) {
          doc.dish.id(dish._id).dishPic = dish.dishPic;  
        }
        if (dish.category != null) {
          doc.dish.id(dish._id).category = dish.category;  
        }
        if (dish.tags != null) {
          doc.dish.id(dish._id).tags = dish.tags;  
        }


        doc.markModified("dish");
        doc.save(function(err,doc){
          console.log(doc);
          callback(doc);
        });


      }
    })
}



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




var queryNearShops = function(loc,distance,callback){
  var maxDistance = distance;
    Shop.find({location:{$near:loc,$maxDistance: maxDistance}}).limit(15).exec(function(err, doc) {
        if (err) {
          console.log(err);
        }
        callback(doc);
      });
};

var findNearShops = function(loc,distance,index,count,callback){
  var maxDistance = distance;
  var limit = index*count;
    Shop.find({location:{$near:loc,$maxDistance: maxDistance}}).skip(limit - count).limit(limit).exec(function(err, doc) {
        if (err) {
          console.log(err);
        }
        console.log(doc);
        for (var i = doc.length - 1; i >= 0; i--) {
            doc[i].dish = undefined;
            doc[i].orders = undefined;
            doc[i].email = undefined;
            doc[i].password = undefined;
            
        }
        callback(doc);
      });
};

var addComments = function(dishId,date,userId,mark,contnet,callback){
  Shop.findOne({_id:dishId},{$pull:{comment:{
    "content":content,
    //"date":date,
    "mark":mark,
    "userId":userId
  }}})
};


var findItemById = function(shopId,itemId,callback){
  Shop.findOne({_id:shopId},function(err,doc){
      if (err) {
        callback(err)
        
      }else{
        if (doc != null && doc.dish != null) {
          for (var i = doc.dish.length - 1; i >= 0; i--) {
              if (doc.dish[i]._id == itemId) {
                  console.log(doc.dish[i]);
                  callback(doc.dish[i]);
              }
          }  
        }else{
          callback("err");
        }
        

      }
  })
}

var addOrder = function(shopId,orderId,callback){
  Shop.update({_id:shopId}, {$push: {orders:{
            "order":orderId
        }}},{upsert:true},
      function (err) {
        //callback(err);
        if (err == null) {
          Shop.findOne({_id:shopId}).populate({
            path:"orders.order",
            match:{_id:orderId},
            selecte:'',
            options:{
              limit:1
            }
          }).exec(function (err, doc) {
              if (err) {
                callback(err);
              }
              callback(doc);
          })
        }
    });
}

var findOrderByShopId = function(shopId,index,count,callback){
var limit = index*count;
  
  Shop.findOne({_id:shopId}).populate({
    path:'orders.order',
    options:{
      skip:limit - count
    }
  }).slice('orders',limit).exec(function (err, doc) {
              if (err) {
                console.log(err);
                callback(err);
              }
                var array = [];
                for(var i=limit - count;i<doc.orders.length;i++){
                    if(doc.orders[i].order!=null){
                        array.push(doc.orders[i]);            
                    }
                    else{
                      break;
                    } 
                }

              callback(array);
          })
}

//=======test api=========
var deleteShop = function(shopId,callback){
  Shop.findById(shopId).remove().exec(function(err,doc){
    callback(doc);
  });
}

//var addDishInfo = 

  return {
    createShop: createShop,
    findShop: findShop,
    findShopById: findShopById,
    changeShopInfo:changeShopInfo,
    uploadShopCover:uploadShopCover,
    addDish:addDish,
    changeDishInfo:changeDishInfo,
    forgotPassword: forgotPassword,
    changePassword: changePassword,
    login: login,
    addDishPic:addDishPic,
    queryNearShops:queryNearShops,
    findNearShops:findNearShops,
    findShopByName:findShopByName,
    findShopsAndDishs:findShopsAndDishs,
    findItemById:findItemById,
    deleteShop:deleteShop,//test api
    addOrder:addOrder,
    findOrderByShopId:findOrderByShopId
  }
}