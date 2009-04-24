// for horizontal menu
Event.observe(window, 'load', function() {
  $$('ul.dropdown li').each(function(item) {
    item.observe('mouseover', function() {
      item.addClassName('over');
    });
    item.observe('mouseout', function() {
      item.removeClassName('over');
    });
  });
});
 
// for hoverable behaviour
// attaches .hover class to descendents of the .hoverable class
Event.observe(window, 'load', function() {
  $$('.hoverable > *').each(function (e) {
    Event.observe(e, 'mouseover', function() {
      Element.addClassName(e, 'hover');
    });  
 
    Event.observe(e, 'mouseout', function() {
      Element.removeClassName(e, 'hover');
    });
  });
});
 
// flash message fading
document.observe("dom:loaded", function() {
  setTimeout(hideFlashMessages, 2000);
});
 
function hideFlashMessages() {
  $$('div#flash-notice, div#flash-warning, div#flash-error').each(function(e) { 
    if (e) Effect.Fade(e, { duration: 1.5 });
  });
}
 
Ajax.Base.prototype.initialize = Ajax.Base.prototype.initialize.wrap( 
   function(p, options){ 
     p(options); 
     this.options.parameters = this.options.parameters || {}; 
     this.options.parameters.authenticity_token = window._token || ''; 
   } 
);
 
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

