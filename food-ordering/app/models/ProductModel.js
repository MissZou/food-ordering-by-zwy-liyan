module.exports = function(mongoose) {
	 var ShopSchema = new mongoose.Schema({
    catagory:   {type: [{
      fastfood: { type: [{
      	all:{type:String},
      	FamousBrand:{type:String},
      	OverRice:{type:String},
      	Noodes:{type:String},
      	PotFood:{type:String},
      	Dumplings:{type:String}
      }]},
      featurefood: { type: [{
      	all:{type:String},
      	SeaFood:{type:String},
      	Sichuan:{type:String},
      	ToastFish:{type:String},
      	Guangdong:{type:String},
      	Muslim:{type:String}
      }]},
      foreigner: { type: [{
      	all:{type:String},
      	Korea:{type:String},
      	Japan:{type:String},
      	West:{type:String},
      	Spaghetti:{type:String}
      }]},
      sides: { type: [{
      	all:{type:String},
      	Local:{type:String},
      	snacks:{type:String},
      	Barbecue:{type:String},
      }]},
      dessert: { type: [{
      	all:{type:String},
      	Cake:{type:String},
      	Bread:{type:String},
      }]},
      drink: { type: [{
      	all:{type:String},
      	Tea:{type:String},
      	Juice:{type:String},
      }]},
    }]},

  });

}