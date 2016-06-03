module.exports = function(mongoose) {
	var OrderSchema = new mongoose.Schema({
		//orderId:{type: String},
      	user:{type: mongoose.Schema.Types.ObjectId, ref:'Account'},
      	shop:{type: mongoose.Schema.Types.ObjectId, ref:'Shop'},
      	date:{type: Date,default: Date.now},
      	dishs:{type: [{
        	//shopId:{type: String},
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
	        userId:{type: mongoose.Schema.Types.ObjectId, ref:'Account'},
	        content:{type: String}
	      }} 
	 
	});


var Order = mongoose.model('Order', OrderSchema);

var addOrder = function(userId,shopId,dishs,address,price,message,callback){

	var tempOrder = new Order({
		user:userId,
		shop:shopId,
		dishs:dishs,
		address:address,
		price:price,
		message:message
	});

	tempOrder.save(function(err,doc){
		if (err) {
			console.log(err);
			//callback(err);
		}
		callback(doc);

	});

}



	return {
	  	addOrder:addOrder
  	}
}