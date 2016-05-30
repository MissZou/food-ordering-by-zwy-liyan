module.exports = function(mongoose) {
	var OrderSchema = new mongoose.Schema({
		//orderId:{type: String},
      	user:{type: mongoose.Schema.Types.ObjectId, ref:'Account'},
      	shop:{type: mongoose.Schema.Types.ObjectId, ref:'Shop'},
      	date:{type: Date,default: Date.now},
      	dishs:{type: [{
        	shopId:{type: String},
	    	itemId:{type: String},
	        amount:{type: Number}
	      }]},
	    address:   {type: {
	    	name: { type: String},
	      	phone: { type: String},
	      	addr: { type: String}
	    }},
	    price:{type:Number},
	    message:{type:String},
	    comment:{type:{
	        date:{type: Date,default: Date.now},
	        userId:{type: String},
	        content:{type: String}
	      }} 
	 
	});


var Order = mongoose.model('Order', OrderSchema);

var addOrder = function(userId,shopId,callback){
	console.log("add order");
	var newdishs = [];
  	var dish = {};
	dish["shopId"] = shopId;
	dish["itemId"] = "itemId";
	dish["amount"] = "5";
	newdishs.push(dish);

	var add = {};
	add["name"] = "ly";
	add["phone"] = "186";
	add["addr"] = "hku";

	var testOrder = new Order({
		user:userId,
		shop:shopId,
		dishs:newdishs,
		address:add
	});

	testOrder.save(function(err,doc){
		if (err) {
			console.log(err);
		}
		callback(doc);
		// Order.find({},function(err,doc){
		// 	callback(doc);
		// });
		// Order.find({}).populate('user').exec(function (err, doc) {
	 //  		if (err){
	 //  			return handleError(err);
	 //  		}
	 //  		console.log(doc);
  // 			callback(doc);
		// });
	});

}

	return {
	  	addOrder:addOrder
  	}
}