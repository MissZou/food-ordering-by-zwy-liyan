module.exports = function(config, mongoose, nodemailer) {
  var crypto = require('crypto');
  


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
    location: {type: [String]}
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
          subject: 'SocialNet Password Request',
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

  var register = function(email, password, phone, name, res) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(password);
    var user = new Account({
      email: email,
      password: shaSum.digest('hex'),
      phone: phone,
      name: name,
      address:"default address"   //无效 不知道为啥暂时
    });
    user.save(registerCallback);
    //res.send(200);
   
  }

var uploadAvatar = function(accountId, photoUrl, callback) {
    Account.update({_id:accountId}, {$set:{photoUrl:photoUrl}},{upsert:false},
      function(err){
        callback(err);
      });
} 

var addAddress = function(accountId, newAddress, callback) {
        Account.update({_id:accountId}, {$push: {address:{"name":newAddress.name,
          "phone":newAddress.phone,
          "type":newAddress.type,
          "addr":newAddress.address
        }}},{upsert:true},
      function (err) {
        callback(err);
    });
}

var deleteAddress = function(accountId, address, callback) {
        Account.update({_id:accountId}, {$pull: {address:address}},{upsert:true},
      function (err) {
        callback(err);
    });
}
var addLocation = function(accountId, location, callback) {
        Account.update({_id:accountId}, {$push: {location:location}},{upsert:true},
      function (err) {
        callback(err);
    });
}

var deleteLocation = function(accountId, location, callback) {
        Account.update({_id:accountId}, {$pull: {location:location}},{upsert:true},
      function (err) {
        callback(err);
    });
};

  return {
    register: register,
    forgotPassword: forgotPassword,
    changePassword: changePassword,
    login: login,
    Account: Account,
    findAccount: findAccount,
    uploadAvatar:uploadAvatar,
    addAddress: addAddress,
    findAccountById: findAccountById,
    deleteAddress: deleteAddress,
    addLocation:addLocation,
    deleteLocation:deleteLocation
  }
}
