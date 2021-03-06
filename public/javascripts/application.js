// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

$(document).ready(function() {
	// markItUp initialization
	$("textarea.textile").markItUp(mySettings);
	
	//Chroma Hash
	$("input:password").chromaHash({bars: 3, salt:"6d29ae950d425767c87ee4127d5d6047", minimum:6});

  /* Fancybox Default
     Galleries are created from found anchors who have the same "rel" tags
     Use the title attribute if you want to show a caption */
  $("a.colorbox").colorbox({
      rel: "group",
      current: "{current} of {total}"
  });
});
