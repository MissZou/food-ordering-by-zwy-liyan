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
	/*var data = {
        "image": $("#list").attr("src")
    };*/
   /* var form = new FormData();  
        form.append("file", $("#file")[0].files[0]);  
*/
 var formData = new FormData($("#frmUploadFile")[0]);

//alert(data)
console.log(formData);

    $.ajax({
        url: '/api/postupload',
        type: 'POST',
        data: formData,
        async: false,
    cache: false,
    contentType: false,
    processData: false,
        success: function(data, status) {
            if (data.code == 200) {
                alert("登录成功");
                console.log(data.msg.url)
                
            }
        },
        error: function(data, status) {
            if (status == 'error') {
                alert("登录失败");
            }
        }
    });

}