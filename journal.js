
$(function(){
    var _buffer = [], _keep, _flush, _change_string,
    _result_container=$("#result"), _size,
    _blur_top=0, _blur_bottom=0,
    _process_line = function(content){
	return content.replace(/ /g, '&nbsp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    },
    _process_buffer = function(){
	var i, j=0,k=0, delta, last_match_line;
	for(i=0;i<_size;i++){
	    if((typeof(_keep) === 'object' && _keep !== null && !_keep.test(_buffer[i])) ||
	       (typeof(_flush) === 'object' && _flush !== null && _flush.test(_buffer[i]))) {
		if(k>0) { 
		    k--; } else {
			$("#_r_" + i).hide();
		    }
	    } else {
		$("#_r_" + i).show();
		$("#_r_" + i).removeClass("blur_top").removeClass("blur_bottom").removeClass("blur_top");
		j=0;
		while(j<_blur_top) {		    
		    j++;
		    delta=i-j;
		    if(delta == last_match_line) {
			break;
		    }
		    if(delta>0) {
			$("#_r_" + delta).show();
			$("#_r_" + delta).addClass("blur_top");
		    }
		}
		k=0;
		while(k<_blur_bottom) {		    
		    k++;
		    delta=i+k;
		    if(delta<_size) {
			$("#_r_" + delta).show();
			$("#_r_" + delta).addClass("blur_bottom");
		    }
		}
		last_match_line=i;
	    }
	}
    },
    _update_result_buffer = function(){
	var i, line_container;
	_result_container.empty();
	for(i=0;i<_size;i++){
	    line_container = $("<div/>", {
		"id": "_r_" + i,
		"class" : "row_container"
	    }).appendTo(_result_container);
	    
	    $("<div/>", {
		"class": "row_controls"
	    }).appendTo(line_container);
	    
	    $("<div/>", {
		"class": "row_number_label",
		"text": '['+i+']'
	    }).appendTo(line_container);

	    $("<div/>", {
		"class": "row_line",
		"html": _process_line(_buffer[i])
	    }).appendTo(line_container);
	}
    },
    _global_handler = function(){
	_buffer = $("#main-content").val().split('\n');
	_size = _buffer.length;
	_update_result_buffer();
	_process_buffer();
    },
    _temp_handler = function(){
	var keep = $("#keep").val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	flush = $("#flush").val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	change_string = $("#change_string").val().split(/[\n\r]/);

	_keep = (typeof(keep) === 'string' && keep.length >0)?new RegExp(keep) : null;
	_flush = (typeof(flush) === 'string' && flush.length >0)?new RegExp(flush) : null;

	_blur_top = parseInt($("#keep_blur_input_top").val()) || 0;
	_blur_bottom = parseInt($("#keep_blur_input_bottom").val()) || 0;

	_change_string = change_string;
	_process_buffer();
    };

    $("#main-content").bind("keyup",null, _global_handler);
    $("#keep, #flush, #keep_blur_input_top, #keep_blur_input_bottom").bind("keyup", null, _temp_handler);
    $("#change_string").bind("keyup", null, function(){});
});