// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({ 
	beforeSend: function(request) {
		request.setRequestHeader("Accept", "text/javascript");
                $("submit").hide();
	},
        complete: function(event, XMLHttpRequest, ajaxOptions) {
                $("submit").show();
	    $(".title-me").tipTip();
        },
	error: function(XMLHttpRequest, textStatus, errorThrown){		
		alert("Ops...Error");
	}
});

$(document).ajaxSend(function(event, request, settings) {
	if (typeof(AUTH_TOKEN) == "undefined") return;
	
	settings.data = settings.data || "";
	settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});


jQuery.fn.submitViaAjax = function() {
	this.submit(function() {
		$.post(this.action, $(this).serialize(), null, "script");
		return false;
	})
	return this;
};

jQuery.fn.zebraTable = function() {
	$(this).find("tbody").find("tr:odd").addClass("odd").removeClass("even");
	$(this).find("tbody").find("tr:even").addClass("even").removeClass("odd");
	
	return this;
};

jQuery.fn.highlightMe = function(){
  $(this).effect("highlight", {}, 3000);
  return $(this);
};

jQuery.fn.confirmPlz = function() {
	return ($(this).attr("confirm_message")) ? $(this).attr("confirm_message") : "Are you sure you want to delete this record?\nNote: there is no undo.";
};

jQuery.fn.watchMeAjax = function(o){
  $(this).each(function(){
          var options = jQuery.extend({
	          tag: "span",
	          klass: "",
	          parent: true,
	          wait: 1000,
	          element: $(this),
	          default_class: "i-am-a-message",
	          url: $(this).attr("url"),
	          ajax_only: false
	}, o);

	if(!options.ajax_only)
	{
	          if(!options.klass)
		        options.klass = " round-loading ";
	          options.klass += options.default_class;
	 }

	if(!options.callback)
	{
	          options.callback = function(text){		        
		var object = options.element;
		if(options.parent)
		      object = object.parent();
		
		if(!options.ajax_only)
		{
		      object.find(options.tag + "." + options.default_class).remove();
		      object.append("<" + options.tag + " class='indented-10 icon " + options.klass +" '></" + options.tag + ">");
		}
		
		$.getScript(options.url + text + "&input_id=" + options.element.attr("id"));
		return false;
	          };
	}

	$(this).typeWatch(options);
  });

  return $(this);
};

jQuery.fn.deviceIconBox = function(options){
          $(this).removeDeviceIconBox();
         
          var boxIcon = $("<div>").css({position: "absolute", left: $(this).position().left + 20, top: $(this).position().top, width: 200,
				backgroundColor: "white", zIndex: 9999999}).
		      addClass('rounded-4 shadow-normal pading-medium').attr("id", "device_icon_box");

           var title = $("<div>").html("Choose a custom icon"). addClass("title lightest rounded-4");
           var close = $("<div>").addClass('icon cross close-icons-choice pointer-me').html("&nbsp;").
	         css({position: "relative", left: 50, display: "inline"});
           title.append(close);
           boxIcon.append(title);
           var inner = $("<div>").css({margin: "10px 10px 10px 10px"});
           
           var icons = allAvailableIcons();
           for(var i in icons)
           {
	        if(i % 9 == 0 && i != 0)
		     inner.append("<div>&nbsp;</div>");
	        inner.append($("<span>").addClass("pointer-me device-icon-chosen icon " + icons[i]));
	        
	        
           }
           

           boxIcon.append(inner);
           $(this).parent().append(boxIcon);
           return $(this);
};

jQuery.fn.removeDeviceIconBox = function(){
          $("#device_icon_box").remove();
          return $(this);
};

function allAvailableIcons()
{
          return ["lights", "television", "fan", "star", "lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan"];
}

jQuery.fn.appendMessage = function(o){
  var options = jQuery.extend({
          tag: "span",
          klass: "i-am-a-message",
          message: "",
          icon: ""
  }, o);

  $(this).parent().find(options.tag + "." + options.klass).remove();
  $(this).parent().append("<" + options.tag + " class='indented-10 icon " + options.klass + " " + options.icon + " ' >" + options.message + "</" + options.tag + ">");
  return $(this);
};

$(document).ready(function(){
        $(".device-icon-chosen").live("click", function(){	 
	      var divIcon = $(this).closest("td").find(".device-icon");	      
	      var classes = divIcon.attr("class");
	      
	      var divArrayClass = classes.split(" ");
	      var iconClass = $(this).attr("class");
	      iconClass = iconClass.split(" ");

	      var newClass = iconClass[iconClass.length - 1];
	      divIcon.removeClass(divArrayClass[divArrayClass.length - 1]).addClass(newClass);
	      $(this).closest("td").find(".hidden-device-icon").val(newClass);
	      $(this).removeDeviceIconBox();
	      
	      return $(this);
        });
                
        $(".close-icons-choice").live("click", function(){
	      $(this).removeDeviceIconBox();
        })
        $(".title-me").tipTip();
        
        $(".hide-after-click").live("click", function(event)
        {
            $(this).hide();
        });

	$(".delete-link").live("click", function(event){
		
		confirm_message = $(this).attr("confirm_message") ? $(this).attr("confirm_message") : "Are you sure you want to delete this record?\nNote: there is no undo.";
		
		if (confirm(confirm_message))
		{ 
			$.ajax({url: this.href, 
					type: "DELETE", 
					dataType: "script"});
		}; 
		return false;	
	});
	
	$(".mass-selector-checkbox").live("click", function(event){
		$(this.form).find(".mass-selectable-checkbox").attr("checked", this.checked);
	});
	
	$(".mass-selectable-checkbox").live("click", function(event){
		$(this.form).find(".mass-selector-checkbox").attr("checked", "");
	});
	
	$("#project_selection").live("click", function(event){
		
		if ($(this).closest("div").find("ul").html() != null)
		{
			if ($(this).closest("div").find("ul").is(":visible")) {
				$(this).closest("div").find("ul").slideUp("fast");
				$(this).closest("div").removeClass("rounded-8 shadow-normal bg-normal transparent-95");
			}
			else {
				$(this).closest("div").addClass("rounded-8 shadow-normal bg-normal transparent-95");
				$(this).closest("div").find("ul").slideDown("fast");
			}
			
			return false;
		}
		else		
			window.location = $(this).attr("href");		
	});	
});