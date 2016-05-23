module.exports = function(mongoose) {
	 // var ProductSchema = new mongoose.Schema({
  //   catagory:   {type: [{
  //     fastfood: { type: [{
  //     	all:{type:[String]},
  //     	FamousBrand:{type:[String]},
  //     	OverRice:{type:[String]},
  //     	Noodes:{type:[String]},
  //     	PotFood:{type:[String]},
  //     	Dumplings:{type:[String]}
  //     }]},
  //     featurefood: { type: [{
  //     	all:{type:[String]},
  //     	SeaFood:{type:[String]},
  //     	Sichuan:{type:[String]},
  //     	ToastFish:{type:[String]},
  //     	Guangdong:{type:[String]},
  //     	Muslim:{type:[String]}
  //     }]},
  //     foreigner: { type: [{
  //     	all:{type:[String]},
  //     	Korea:{type:[String]},
  //     	Japan:{type:[String]},
  //     	West:{type:[String]},
  //     	Spaghetti:{type:[String]}
  //     }]},
  //     sides: { type: [{
  //     	all:{type:[String]},
  //     	Local:{type:[String]},
  //     	snacks:{type:[String]},
  //     	Barbecue:{type:[String]},
  //     }]},
  //     dessert: { type: [{
  //     	all:{type:[String]},
  //     	Cake:{type:[String]},
  //     	Bread:{type:[String]},
  //     }]},
  //     drink: { type: [{
  //     	all:{type:[String]},
  //     	Tea:{type:[String]},
  //     	Juice:{type:[String]},
  //     }]},
  //   }]},

  // });
	var ProductSchema = new mongoose.Schema({
    ProductId:{ type: String, unique: true },
    catagory:   {type: [{
      fastfood: { type: [{
      	all:{type:[String]},
      	FamousBrand:{type:[String]},
      	OverRice:{type:[String]},
      	Noodes:{type:[String]},
      	PotFood:{type:[String]},
      	Dumplings:{type:[String]}
      }]},
      featurefood: { type: [{
      	all:{type:[String]},
      	SeaFood:{type:[String]},
      	Sichuan:{type:[String]},
      	ToastFish:{type:[String]},
      	Guangdong:{type:[String]},
      	Muslim:{type:[String]}
      }]},
      foreigner: { type: [{
      	all:{type:[String]},
      	Korea:{type:[String]},
      	Japan:{type:[String]},
      	West:{type:[String]},
      	Spaghetti:{type:[String]}
      }]},
      sides: { type: [{
      	all:{type:[String]},
      	Local:{type:[String]},
      	snacks:{type:[String]},
      	Barbecue:{type:[String]},
      }]},
      dessert: { type: [{
      	all:{type:[String]},
      	Cake:{type:[String]},
      	Bread:{type:[String]},
      }]},
      drink: { type: [{
      	all:{type:[String]},
      	Tea:{type:[String]},
      	Juice:{type:[String]},
      }]},
    }]}

  });
	var Product = mongoose.model('ProductModel',ProductSchema);
	
	var getProductModel = function(callback){
		Product.findOne({ProductId:"FOS"},function(err,doc){
			if (doc != null) {
				callback(doc);
			} else{
				var productModel = new ProductModel ({
					ProductId:"FOS"
				});
				productModel.save(function(err){
					callback(err);
				});
			}
		});
	}

	var upProductStatistics = function(catagory,shopId){
		if(catagory == "FamousBrand"){
			Product.update({_id:'FOS'},{$push,:{catagory:{
				fastfood:{
					all:shopId,
					FamousBrand:shopId
				}
			}}},{upsert:true},
		      function (err) {
		        console.log(err)
		        callback(err);
		    });
		}
	}
}