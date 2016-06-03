module.exports = function(config, mongoose, nodemailer) {
  var crypto = require('crypto');
  var eventEmitter = require('events').EventEmitter;  
  //var Order = require('Order');
  var AccountSchema = new mongoose.Schema({
    email:     { type: String, unique: true },
    password:  { type: String},
    phone:     { type: String},
    name:      {type: String},
    photoUrl:  { type: String},
    address:   {type: [{
      name: { type: String},
      phone: { type: String},
      type: { type: String},
      addr: { type: String}
    }]},
    location: {type: [{
      name: { type: String},
      loc:{type:[Number]}
    }]},
    cart: {type: [{
      shopId: { type:mongoose.Schema.Types.ObjectId, ref:'Shop'},
      itemId: { type: mongoose.Schema.Types.ObjectId},
      amount:{type:Number},
      date:{type: Date, default: Date.now}
    }]},
    favoriteShop:{type:[{
      shopId:{type:mongoose.Schema.Types.ObjectId, ref:'Shop'},
    }]},
    favoriteItem:{type:[{
      shopId:{type:mongoose.Schema.Types.ObjectId, ref:'Shop'},
      itemId:{type:mongoose.Schema.Types.ObjectId}
    }]},
    orders:{type:[{
      order:{type: mongoose.Schema.Types.ObjectId, ref:'Order'}
    }]}
  });

  var Account = mongoose.model('Account', AccountSchema);

  var registerCallback = function(err) {
    if (err) {
      return console.log(err);
    };

    return console.log('Account was created');
  };

  var changePassword = function(accountId, newpassword) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(newpassword);
    var hashedPassword = shaSum.digest('hex');
    Account.update({_id:accountId}, {$set: {password:hashedPassword}},{upsert:false},
      function changePasswordCallback(err) {
        console.log('Change password done for account ' + accountId);
    });
  };

  var forgotPassword = function(email, resetPasswordUrl, callback) {
    var user = Account.findOne({email: email}, function findAccount(err, doc){
      if (err) {
        // Email address is not a valid user

      } else {
        var smtpTransport = nodemailer.createTransport('SMTP', config);
        resetPasswordUrl += '?account=' + doc._id;
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

  var login = function(email, password,req, callback) {
        var shaSum = crypto.createHash('sha256');
        shaSum.update(password);
        Account.findOne({email:email,password:shaSum.digest('hex')},function(err,doc){
            req.session.user = doc;
            callback(doc);
            //console.log(doc);

            //return doc._id;
        });

    };

  var findAccount = function(email, callback) {
    Account.findOne({email:email}, function(err,doc){
        callback(doc);
    })
  }

  var findAccountById = function(id, callback) {
    Account.findOne({_id:id}, function(err, doc){
      if (err) {
        callback(err)
      }
      callback(doc);
    })
  }

  var register = function(email, password, phone, name, callback) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(password);
    var user = new Account({
      email: email,
      password: shaSum.digest('hex'),
      phone: phone,
      name: name
      //address:"default address"   //无效 不知道为啥暂时
    });
    user.save(function(err){
      callback(err);
    });
    
    //res.send(200);
   
  }

var uploadAvatar = function(accountId, photoUrl, callback) {
    Account.update({_id:accountId}, {$set:{photoUrl:photoUrl}},{upsert:false},
      function(err){
        callback(err);
      });
} 

var addAddress = function(accountId, newAddress, callback) {
        Account.update({_id:accountId}, {$push: {address:{
          "name":newAddress.name,
          "phone":newAddress.phone,
          "type":newAddress.type,
          "addr":newAddress.address
        }}},{upsert:true},
      function (err) {
        console.log(err)
        callback(err);
    });
}

var updateAddress = function(accountId, newAddress, addrId, callback) {
  Account.findOne({_id:accountId}, function(err, account){
        
        if (!err){
          //console.log(doc);
          //console.log(doc.address);
          account.address.forEach(function(addr){
            
            if(addr._id == addrId){
              addr.name = newAddress.name,
              addr.phone = newAddress.phone,
              addr.addr = newAddress.address,
              addr.type = newAddress.type
            }

          })
          account.save(function(err){
            callback(err);
          });
        }
    })
}

var deleteAddress = function(accountId, address, callback) {
        Account.update({_id:accountId}, {$pull: {address:{"name":address.name,
          "phone":address.phone}}},{upsert:true},
      function (err) {
        console.log(err)
        callback(err);
    });
}
var addLocation = function(accountId, locationName, coordinate, callback) {
        Account.update({_id:accountId}, {$push: {location:{
          "name" : locationName,
          "loc" : coordinate
        }}},{upsert:true},
      function (err) {
        callback(err);
    });
}

var deleteLocation = function(accountId, locationName, callback) {
        Account.update({_id:accountId}, {$pull: {location:{
          "name":locationName
        }}},{upsert:true},
      function (err) {
        callback(err);
    });
};

var addItemToCart = function(accountId,shopId,itemId,amount,callback){
  Account.update({_id:accountId}, {$push: {cart:{
          "shopId" : shopId,
          "itemId" : itemId,
          "amount" : amount
        }}},{upsert:true},
      function (err) {
        callback(err);
    });
}

var deleteItemOfCart = function(accountId,itemId,callback){
  Account.update({_id:accountId}, {$pull: {cart:{
          "itemId" : ItemId
        }}},{upsert:true},
      function (err) {
        callback(err);
    });
}


var addOrder = function(accountId,orderId,callback){
  //console.log("add order");
  Account.update({_id:accountId}, {$push: {orders:{
            "order":orderId
        }}},{upsert:true},
      function (err) {
        
        //callback(err);
        if (err == null) {
          Account.findOne({_id:accountId}).populate({
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
        }else{
          callback(err);
        }
    });
}


var deleteOrder = function(accountId,orderId,callback){
    Account.update({_id:accountId}, {$pull: {orders:{
            "order":orderId
        }}},{upsert:true},
      function (err) {
        callback(err)
    });
}

var findOrderByUserId = function(accountId,index,count,callback){
  var limit = index*count;
  
  Account.findOne({_id:accountId}).populate({
    path:'orders.order',
    options:{
      
      skip:limit - count
      
    }
  }).slice('orders',limit).exec(function (err, doc) {
              if (err) {
                console.log(err);
                callback(err);
              }
              console.log(doc);
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

var addFavoriteShop = function(accountId,shopId,callback){
    Account.findOne({_id:accountId,"favoriteShop.shopId":shopId},function(err,doc){
      if (doc == null) {
          Account.update({_id:accountId},{$push:{favoriteShop:{
            "shopId":shopId
          }}},{upsert:true},
          function(err,doc){
            // callback(doc);
              if (err == null) {
              Account.findOne({_id:accountId}).populate({
              path:"favoriteShop.shopId",
                match:{_id:shopId},
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
      }else{
        callback("err");
      }
    });
}

var findFavoriteShop = function(accountId,index,count,callback){
    var limit = index*count;
    Account.findOne({_id:accountId}).populate({
            path:"favoriteShop.shopId",
              selecte:'',
              options:{
                skip:limit - count
              }
             }).slice("favoriteShop",limit).exec(function (err, doc) {
                if (err) {
                  callback(err);
                }
                console.log(doc);
                var array = [];
                for(var i=limit - count;i<doc.favoriteShop.length;i++){
                    if(doc.favoriteShop[i]!=null){
                        array.push(doc.favoriteShop[i]);            
                    }
                    else{
                      break;
                    }
                }

                for (var i = array.length - 1; i >= 0; i--) {
                    array[i].shopId.dish = undefined;
                    array[i].shopId.orders = undefined;
                    array[i].shopId.email = undefined;
                    array[i].shopId.password = undefined;
                    array[i].shopId._id = undefined;
                    array[i]._id = undefined;

                }
                
                callback(array);
            })
              
}

var deleteFavoriteShop = function(accountId,shopId,callback){
    //console.log(accountId);
    Account.findOne({_id:accountId},function(err,doc){
      if (doc != null) {

          Account.update({_id:accountId},{$pull:{favoriteShop:{
            "shopId":shopId
          }}},{upsert:true},
          function(err,doc){
            //console.log(doc);
            //console.log(err);
            callback(doc);
          });
      }else{
        console.log(err);
        callback("account not exist");
      }
    });
}

var addFavoriteItem = function(accountId,shopId,itemId,callback){
    Account.findOne({_id:accountId,"favoriteItem.itemId":itemId},function(err,doc){
      if (doc == null) {
        Account.update({_id:accountId},{$push:{favoriteItem:{
            "shopId":shopId,
            "itemId":itemId
          }}},{upsert:true},
          function(err,doc){        
            if (err == null) {
                Account.findOne({_id:accountId}).populate({
                path:"favoriteShop.shopId",
                match:{_id:shopId},
                selecte:'',
                options:{
                  limit:1
                }
               }).exec(function (err, doc) {
                  if (err) {
                    callback(err);
                  }else{
            
                    for(var i = 0;i<doc.favoriteShop.length;i++){
                        if (doc.favoriteShop[i].shopId == null) {
                            doc.favoriteShop.splice(i,1);
                            i=-1;continue;
                        }
                    }
                    
                    var dishs = doc.favoriteShop[0].shopId.dish;
                    var isFindItem = false;
                    for(var i = 0;i<dishs.length;i++){
                        console.log(dishs[i]._id);
                      if (String(dishs[i]._id).valueOf() == String(itemId).valueOf()) {
                          callback(dishs[i]);
                          isFindItem = true
                      }
                    }
                    if (!isFindItem) {
                        callback("dish not found");
                    }
                  }
              })
            }else{
              callback(err);  
            }
            
          });
      }else{
        callback("found duiplicate item");  
      }
    });
}


var findFavoriteItem = function(accountId,index,count,callback){
  
  Account.findOne({_id:accountId},function(err,doc){
      if (doc != null) {
        var resultNumber = count;
        var limit = index * resultNumber;
        var items = doc.favoriteItem;
        var array = [];
          for (var i = limit - resultNumber; i < limit; i++) {
              if (items[i] != null) {
                array.push(items[i]);
              } else{
                break;
              }
          }
           
           var result = [];
           var obj;
           var j = 0;
           var myEventEmitter = new eventEmitter;
           myEventEmitter.on('next',addResult);
           function addResult(){
              result.push(obj)
              j++;
              if (j == array.length) {
                callback(result);
              }
           }
          
           
           var populateFav = promiseify(populateFavoriteItem);           
           for (var i = 0; i <array.length ; i++) {
                var ii = i;
                populateFavoriteItem(accountId,array[ii],function(doc){
                  //result.push(doc);
                  obj = doc;
                  myEventEmitter.emit("next");
                })
           }
           
      }else{
        console.log(err);
        callback("account not exist");
      }
    });

}

var populateFavoriteItem = function(accountId,item,callback){
        var result = {};
        Account.findOne({_id:accountId}).populate({
                path:"favoriteShop.shopId",
                match:{_id:item.shopId},
                selecte:'',
                options:{
                  limit:1
                }
               }).exec(function (err, doc) {
                  if (err) {
                    callback(err);
                  }else{
            
                    for(var i = 0;i<doc.favoriteShop.length;i++){
                        if (doc.favoriteShop[i].shopId == null) {
                            doc.favoriteShop.splice(i,1);
                            i=-1;continue;
                        }
                    }
                    
                    var dishs = doc.favoriteShop[0].shopId.dish;
                    
                    for(var i = 0;i<dishs.length;i++){
                        
                      if (String(dishs[i]._id).valueOf() == String(item.itemId).valueOf()) {
                          callback(dishs[i]);
                      }
                    
                    }
                  }
              })

}

var deleteFavoriteItem = function(accountId,shopId,itemId,callback){
      Account.findOne({_id:accountId},function(err,doc){
      if (doc != null) {

          Account.update({_id:accountId},{$pull:{favoriteItem:{
            "shopId":shopId,
            "itemId":itemId
          }}},{upsert:true},
          function(err,doc){
            //console.log(doc);
            //console.log(err);
            callback(doc);
          });
      }else{
        console.log(err);
        callback("account not exist");
      }
    });
}

  return {
    register: register,
    forgotPassword: forgotPassword,
    changePassword: changePassword,
    login: login,
    Account: Account,
    findAccount: findAccount,
    findAccountById: findAccountById,
    uploadAvatar:uploadAvatar,
    addAddress: addAddress,
    updateAddress: updateAddress,
    deleteAddress: deleteAddress,
    addLocation:addLocation,
    deleteLocation:deleteLocation,
    addItemToCart:addItemToCart,
    deleteItemOfCart:deleteItemOfCart,
    addOrder:addOrder,
    deleteOrder:deleteOrder,
    findOrderByUserId:findOrderByUserId,
    addFavoriteShop:addFavoriteShop,
    findFavoriteShop:findFavoriteShop,
    deleteFavoriteShop:deleteFavoriteShop,
    addFavoriteItem:addFavoriteItem,
    findFavoriteItem:findFavoriteItem,
    deleteFavoriteItem:deleteFavoriteItem
  }
}
