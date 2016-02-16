document.querySelector('input[name=files]').onchange = function(e){
     readFile(e.target.files[0]);
}

function readFile(file){

  var reader = new FileReader();

  reader.onload = function(e){
    document.getElementById("list").src = e.target.result;
  };

  reader.readAsDataURL(file);
}

$("#upload").on("click",upload);
function upload(){
 var formData = new FormData($("#frmUploadFile")[0]);

console.log(formData);

    $.ajax({
        url: '/user/avatar',
        type: 'POST',
        data: formData,
        async: false,
    cache: false,
    contentType: false,
    processData: false,
        success: function(data, status) {
            if (data.code == 200) {
                alert("上传成功");
                console.log(data.msg.url)
                
            }
        },
        error: function(data, status) {
            if (status == 'error') {
                alert("上传失败");
            }
        }
    });

}