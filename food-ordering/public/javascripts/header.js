$(".expand").on("click",function(){
	if($(".list").css("display")=="block"){
		$(".list").slideUp();
	}else{
		$(".list").slideDown();
	}
})