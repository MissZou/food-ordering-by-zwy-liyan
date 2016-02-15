module.exports = function(config, mongoose, nodemailer) {
  var crypto = require('crypto');
  


  var AccountSchema = new mongoose.Schema({
    email:     { type: String, unique: true },
    password:  { type: String},
    phone:     { type: String},
    name:      {type: String},
    photoUrl:  { type: String},
    address:   [String]
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

  var login = function(email, password, callback) {
        var shaSum = crypto.createHash('sha256');
        shaSum.update(password);
        Account.findOne({email:email,password:shaSum.digest('hex')},function(err,doc){
            callback(doc);
        });

    };

  var foundAccount = function(email, callback) {
    Account.findOne({email:email}, function(err,doc){
        callback(null != doc);
    })
  }

  var register = function(email, password, phone, name, res) {
    var shaSum = crypto.createHash('sha256');
    shaSum.update(password);

    console.log('Registering ' + email);
    var user = new Account({
      email: email,
      password: shaSum.digest('hex'),
      phone: phone,
      name: name
    });
    user.save(registerCallback);
    res.send(200);
    console.log('Save command was sent');
  }

  var addAddress = function(accountId, newAddress, callback) {
       var user = Account.findOne({_id:accountId}, function(err,doc){
        user.address.push(newAddress);
        callback(doc);
    });
  }

  return {
    addAddress: addAddress,
    register: register,
    forgotPassword: forgotPassword,
    changePassword: changePassword,
    login: login,
    Account: Account,
    foundAccount: foundAccount
  }
}
