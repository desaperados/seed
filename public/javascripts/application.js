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