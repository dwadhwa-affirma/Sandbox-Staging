$(document).ready(function(){

// Table Row Selection

var all_checkbox = $("input.select_item:checkbox"); 




all_checkbox.on('click',function(){

	var target_checkbox = $(this);

	var target_parent = target_checkbox.parent().parent();
	
	if(target_checkbox.is(':checked')){
		target_parent.addClass('selected_row');
	}
	else{
		target_parent.removeClass('selected_row');
	}
});


$('.attach_file').on('click', function(){
	var current_targ = $(this);

	$('.fileupload').trigger('click');
});

// Messages Show/Hide

var recent_comm_h = $('.mrecent').innerHeight();

var newheight = (recent_comm_h + 50);

$('.msg_cont_wrap').css('height', +newheight +'px');

$('.showhidemsg').on('click', function(){
	var otherlist_height = $('.previous_list').innerHeight();
	var lat_h = ((otherlist_height + newheight) - 100);
	$(this).toggleClass('openmsg')

	if($('.previous_list').css('display') == 'none'){
		$('.previous_list').addClass('plist_open')
		$(this).html("Hide Previous Messages");
		$('.msg_cont_wrap').css('height', +lat_h +'px');
		
	}

	else{
		$(this).html("Previous Messages");
		$('.previous_list').removeClass('plist_open')
		$('.msg_cont_wrap').css('height', +newheight +'px');
	}
	
});



});