
$(function(){
    var _buffer = "", _keep, _flush, _change_string,
    i, _line_container,
    _result_container=$("#result"),
    _process_line = function(content){
	var edited_content = content;
	return edited_content.replace(/ /g, '&nbsp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    },
    _process_buffer = function(){
	_result_container.empty();
	for(i in _buffer){

	    if((typeof(_keep) === 'object' && _keep !== null && !_keep.test(_buffer[i])) ||
	       (typeof(_flush) === 'object' && _flush !== null && _flush.test(_buffer[i]))) {
		continue;
	    }

	    _line_container = $("<div/>", {
		"id": "_r_" + i,
		"class" : "row_container"
	    }).appendTo(_result_container);
	    
	    $("<div/>", {
		"class": "row_controls"
	    }).appendTo(_line_container);
	    
	    $("<div/>", {
		"class": "row_number_label",
		"text": '['+i+']'
	    }).appendTo(_line_container);
	    

	    //TODO: replace all possible html statements
	    $("<div/>", {
		"class": "row_line",
		"html": _process_line(_buffer[i])
	    }).appendTo(_line_container);
	}
	
    },
    _temp_handler = function(){
	var keep = $("#keep").val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	flush = $("#flush").val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	change_string = $("#change_string").val().split(/[\n\r]/);
	_buffer = $("#main-content").val().split('\n');


	_keep = (typeof(keep) === 'string' && keep.length >0)?new RegExp(keep) : null;
	_flush = (typeof(flush) === 'string' && flush.length >0)?new RegExp(flush) : null;



	_change_string = change_string;
	_process_buffer();
    };

    $("#main-content, #keep, #flush, #change_string").bind("keyup", null, _temp_handler);



});