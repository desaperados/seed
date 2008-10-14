Ajax.Base.prototype.initialize = Ajax.Base.prototype.initialize.wrap( 
   function(p, options){ 
     p(options); 
     this.options.parameters = this.options.parameters || {}; 
     this.options.parameters.authenticity_token = window._token || ''; 
   } 
);

function show_clicked(anchor) {
	anchor.up(0).setStyle({background: '#ffff99'});
	anchor.setStyle({color: '#333333'});
}

// Events Form Helpers
function toggle_when_field(checkbox) {
	if (checkbox.checked) {
		$("_datetime").hide();
		$('event_datetime').value = "";
		$("_date").show();
	} else {
		$("_datetime").show();
		$('event_from_date').value = "";
		$('event_to_date').value = "";
		$("_date").hide();
	}
}

function set_to_date_value(element) {
	$("event_to_date").value = element.value;
}