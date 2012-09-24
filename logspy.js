var Connect = function() { 
	var _ws = new WebSocket("ws://localhost:3003"),
	_callback_message, _callback_open, _callback_close, _callback_error;

    _ws.onopen = function() {
     	if(typeof(_callback_open) === 'function') {
     	    _callback_open();
     	}
    };
    _ws.onmessage = function (evt) 
    { 
     	if(typeof(_callback_message) === 'function') {
            _callback_message(evt.data);
        }
    };
    _ws.onclose = function()
    { 
     	if(typeof(_callback_close) === 'function') {
            _callback_close();
        }
    };   
    _ws.onerror = function(evt) {
    	if(typeof(_callback_error) === 'function') {
    	    _callback_error(evt.data);
    	}
    };
    return {
	send: function(message) {
	    _ws.send(message);
	},
	set_callback_message: function(call_back) {
	    _callback_message = call_back;	
	},
	set_callback_open: function(call_back) {
	    _callback_open = call_back;	
	},
	set_callback_close: function(call_back) {
	    _callback_close = call_back;	
	},
	set_callback_error: function(call_back) {
	    _callback_error = call_back;	
	}
    };
}(),
Logspy = {
    Receptor: null,
    Filter: null
};


Logspy.Receptor = function() {
    var _main_message = $("#main_message"), _main_result = $("#result"),
    _buffer = [], _dom_buffer =[], 
    _process_line = function(content){
	return content.replace(/ /g, '&nbsp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    },
    _line_creator = function(message) {
	_buffer.push(message);
	var item_added = _buffer.length,
	line_container = $("<div/>", {
	    "id": "_r_" + item_added,
	    "class" : "row_container"
	});
	_dom_buffer.push(line_container);
	$("<div/>", {
	    "class": "row_controls"
	}).appendTo(line_container);
	
	$("<div/>", {
	    "class": "row_number_label",
	    "text": '[' + item_added + ']'
	}).appendTo(line_container);

	$("<div/>", {
	    "class": "row_line",
	    "html": _process_line(message)
	}).appendTo(line_container);
	return line_container;
    };
	
    Connect.set_callback_open(function(){
	_main_message.html("pipe ON");
	_main_message.removeClass("_off");
	_main_message.addClass("_on");
    });
    Connect.set_callback_close(function(){
	_main_message.html("pipe OFF");
	_main_message.removeClass("_on");
	_main_message.addClass("_off");
    });

    Connect.set_callback_message(function(message){
	_line_creator(message).appendTo(_main_result);
	Logspy.Filter.onFilterChange();
    });
    return {
	buffer: function() {
	    return _buffer;
	},
	dom_buffer: function() {
	    return _dom_buffer;
	}
    };
}();

Logspy.Filter = function() {
    var _keep, _dom_keep=$("#keep"),  _flush, _dom_flush=$("#flush"), _remove_string, 
    _dom_remove_string=$("#remove_string"), _highlight_string, _dom_highlight_string = $("#highlight_string"),
    _buffer = Logspy.Receptor.buffer(),
    _dom_buffer = Logspy.Receptor.dom_buffer(),
    _size = _buffer.length,
    _blur_top=0, _blur_bottom=0,
    _load_filters = function() {
	var keep = _dom_keep.val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	flush = _dom_flush.val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	remove_string = _dom_remove_string.val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,''),
	highlight_string = _dom_highlight_string.val().replace(/[\n\r]/g, "|").replace(/[\|]+/g,'|').replace(/\|$/g,'').replace(/^\|/g,'');

	_keep = (typeof(keep) === 'string' && keep.length >0)?new RegExp(keep) : null;
	_flush = (typeof(flush) === 'string' && flush.length >0)?new RegExp(flush) : null;

	_remove_string = (typeof(remove_string) === 'string' && remove_string.length >0)?new RegExp(remove_string) : null;
	_highlight_string = (typeof(highlight_string) === 'string' && highlight_string.length >0)?new RegExp(highlight_string) : null;

	_blur_top = parseInt($("#keep_blur_input_top").val()) || 0;
	_blur_bottom = parseInt($("#keep_blur_input_bottom").val()) || 0;
    },
    _process_buffer = function() {
	var i, j=0,k=0, delta, dom_delta, last_match_line, flush_flag;
	_size = _buffer.length;
	for(i=0;i<_size;i++){
	    flush_flag = (typeof(_flush) === 'object' && _flush !== null && _flush.test(_buffer[i]));
	    if(typeof(_keep) === 'object' && _keep !== null && !_keep.test(_buffer[i]) || flush_flag) {
		if(flush_flag) {
		    $(_dom_buffer[i]).addClass("should_hide");
		}
		if(k>0) { 
		    k--;
		} else {
		    $(_dom_buffer[i]).hide();
		}		
	    } else {
		$(_dom_buffer[i]).show();
		$(_dom_buffer[i]).removeClass("blur_top").removeClass("blur_bottom").removeClass("blur_top").removeClass("should_hide");
		j=0;
		while(j<_blur_top) {		    
		    j++;
		    delta=i-j;
		    if(delta == last_match_line) {
			break;
		    }
		    if(delta>0) {
			dom_delta = $("#_r_" + delta);
			dom_delta.show();
			dom_delta.addClass("blur_top");
		    }
		}
		k=0;
		while(k<_blur_bottom) {		    
		    k++;
		    delta=i+k;
		    if(delta<_size) {
			dom_delta = $("#_r_" + delta);
			dom_delta.show();
			dom_delta.addClass("blur_bottom");
		    }
		}
		last_match_line=i;
	    }
	}
    };

    return {
	onFilterChange: function() {
	    _load_filters();
	    _process_buffer();
	}
    };
}();


$(function(){
    var _adapt_height = function() {
	$('#result').height(($(window).height() -200).toString()+ "px");
    };
    $("#remove_string, #highlight_string, #keep, #flush, #keep_blur_input_top, #keep_blur_input_bottom").bind("keyup", null, Logspy.Filter.onFilterChange);
    _adapt_height();
    $(window).bind("resize", _adapt_height);
});
