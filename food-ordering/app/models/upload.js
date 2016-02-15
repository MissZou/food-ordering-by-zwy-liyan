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

    var uploadUrl = function(url) {
        console.log(url)
        var user = new upload({
            url: url
        });

        user.save();
        console.log('img upload successfully');

        //console.log(req)
        //console.log(res)
    };
    return {
        uploadUrl: uploadUrl
    }
};
