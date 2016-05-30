module.exports = function(config, mongoose, nodemailer) {
  var crypto = require('crypto');
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
      shopId: { type: String},
      itemId: { type: String},
      amount:{type:Number},
      date:{type: Date, default: Date.now}
    }]},
    favoriteShop:{type:[{
      shopId:{type: String}
    }]},
    favoriteItem:{type:[{
      shopId:{type:String},
      itemId:{type: String}
    }]},
    orders:{order: [{type: mongoose.Schema.Types.ObjectId, ref:'Order'}] }
    //order:{}
    // order:{type:[{
    //   date:{type: Date,default: Date.now},
    //   dishs:{type: [{
    //     shopId:{type: String},
    //     itemId:{type: String},
    //     amount:{type: Number}
    //   }]},
    //   userId:{type: String},
    //    comment:{type:[{
    //      date:{type: Date,default: Date.now},
    //      userId:{type: String},
    //      content:{type: String}
    //    }]} 
    // }]}
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
  Account.update({_id:accountId}, {$push: {orders:{
            "order":orderId
        }}},{upsert:true},
      function (err) {
        //callback(err);
        if (err == null) {
          Account.findOne({_id:accountId}).populate('order.orders').exec(function (err, doc) {
              if (err) {
                callback(err);
              }
              callback(doc);
          })
        }
    });
}

var findOrderByUserId = function(accountId,callback){
  Account.findOne({_id:accountId}).populate('orders.order').exec(function (err, doc) {
              if (err) {
                callback(err);
              }
              callback(doc);
          })
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
    findOrderByUserId:findOrderByUserId
  }
}
