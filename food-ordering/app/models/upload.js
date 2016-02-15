module.exports = function(mongoose) {
	  var uploadSchema = new mongoose.Schema({
    url: { type: String }
   
  });

	  var registerCallback = function(err) {
    if (err) {
      return console.log(err);
    };

    return console.log('image was saving');
  };

	  var upload = mongoose.model('upload', uploadSchema);

	var uploadImage=function(image,res){
		console.log("start uploading")
		var user = new upload({
      image: image
    });
		user.save(registerCallback);
    res.send(200);
    console.log('img upload successfully');
	};

	var uploadUrl=function(url){
		console.log(url)
		var user = new upload({
      url: url
    });
		
   user.save();
    console.log('img upload successfully');

		//console.log(req)
		//console.log(res)
	};

	var getImage=function(){
		console.log("start getting image");

	};
return {
	//upload:uploadImage,
	getImage:getImage,
	uploadUrl:uploadUrl
}
};