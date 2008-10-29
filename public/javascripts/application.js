// for horizontal menu
Event.observe(window, 'load', function() {
  $$('ul.menu li').each(function(item) {
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
 
function true_if_not_ie() {
  true
}
 
// flash message fading
document.observe("dom:loaded", function() {
  setTimeout(hideFlashMessages, 2000);
});
 
function hideFlashMessages() {
  $$('div#flash-notice, div#flash-warning, div#flash-error').each(function(e) { 
    if (e) Effect.Fade(e, { duration: 2.0 });
  });
}
 
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

//  Lightview 2.3.2 - 03-09-2008
//  Copyright (c) 2008 Nick Stakenburg (http://www.nickstakenburg.com)
//
//  Lightview Config moved here to avoid problems with bundle_fu

var Lightview = {
  Version: '2.3.2',

  // Configuration
  options: {
    backgroundColor: '#ffffff',                            // Background color of the view
    border: 12,                                            // Size of the border
    buttons: {
      opacity: {                                           // Opacity of inner buttons
        disabled: 0.4,
        normal: 0.7,
        hover: 1
      },
      side: { display: true },                             // show side buttons
      innerPreviousNext: { display: true },                // show the inner previous and next button
      slideshow: { display: true }                         // show slideshow button
    },
    cyclic: false,                                         // Makes galleries cyclic, no end/begin.
    images: '../images/lightview/',                        // The directory of the images, from this file
    imgNumberTemplate: 'Image #{position} of #{total}',    // Want a different language? change it here
    keyboard: { enabled: true },
    overlay: {                                             // Overlay
      background: '#000',                                  // Background color, Mac Firefox & Mac Safari use overlay.png
      close: true,
      opacity: 0.85,
      display: true
    },
    preloadHover: true,                                    // Preload images on mouseover
    radius: 12,                                            // Corner radius of the border
    removeTitles: true,                                    // Set to false if you want to keep title attributes intact
    resizeDuration: 0.3,                                  // When effects are used, the duration of resizing in seconds
    slideshowDelay: 5,                                     // Seconds to wait before showing the next slide in slideshow
    titleSplit: '::',                                      // The characters you want to split title with
    transition: function(pos) {                            // Or your own transition
      return ((pos/=0.5) < 1 ? 0.5 * Math.pow(pos, 4) :
        -0.5 * ((pos-=2) * Math.pow(pos,3) - 2));
    },
    viewport: true,                                        // Stay within the viewport, true is recommended
    zIndex: 5000,                                          // zIndex of #lightview, #overlay is this -1

    // Optional
    closeDimensions: {                                     // If you've changed the close button you can change these
      large: { width: 77, height: 22 },                    // not required but it speeds things up.
      small: { width: 25, height: 22 },
      topclose: { width: 22, height: 18 }                  // when topclose option is used
    },
    defaultOptions : {                                     // Default open dimensions for each type
      ajax:   { width: 400, height: 300, method: 'get' },
      iframe: { width: 400, height: 300, scrolling: true },
      inline: { width: 400, height: 300 },
      flash:  { width: 400, height: 300 },
      quicktime: { width: 480, height: 220, autoplay: true, controls: true }
    },
    sideDimensions: { width: 16, height: 22 }              // see closeDimensions
  },

  classids: {
    quicktime: 'clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B',
    flash: 'clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'
  },
  codebases: {
    quicktime: 'http://www.apple.com/qtactivex/qtplugin.cab#version=7,3,0,0',
    flash: 'http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,115,0'
  },
  errors: {
    requiresPlugin: "<div class='message'>The content your are attempting to view requires the <span class='type'>#{type}</span> plugin.</div><div class='pluginspage'><p>Please download and install the required plugin from:</p><a href='#{pluginspage}' target='_blank'>#{pluginspage}</a></div>"
  },
  mimetypes: {
    quicktime: 'video/quicktime',
    flash: 'application/x-shockwave-flash'
  },
  pluginspages: {
    quicktime: 'http://www.apple.com/quicktime/download',
    flash: 'http://www.adobe.com/go/getflashplayer'
  },
  // used with auto detection
  typeExtensions: {
    flash: 'swf',
    image: 'bmp gif jpeg jpg png',
    iframe: 'asp aspx cgi cfm htm html jsp php pl php3 php4 php5 phtml rb rhtml shtml txt',
    quicktime: 'avi mov mpg mpeg movie'
  }
};