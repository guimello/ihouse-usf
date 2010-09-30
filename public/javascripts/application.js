// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({ 
  beforeSend: function(request) {
    //request.setRequestHeader("Accept", "text/javascript");
                $("submit").hide();
  },
        complete: function(event, XMLHttpRequest, ajaxOptions) {
                $("submit").show();
                $(".title-me").tipTip();
                $(".loading-button").stopLoadingSubmit();
        },
  error: function(XMLHttpRequest, textStatus, errorThrown){    
    //alert("Ops...Error");
    $.Growl.show({
      'title'  : 'Ops...',
      'message': 'The server made a boo boo...',
      'icon'   : 'error',
      'timeout': 2000
    });
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

function allAvailableIcons()
{
  return ["lights", 'thermometer-red', 'thermometer-blue', "television", "fan", "star", "lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan","lights", "television", "fan"];
}

function allToggleIcons()
{
  return ["lights-on", "lights-off", "fan", "star", "television", "add"];
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

jQuery.fn.loadingSubmit = function() {
        clone = $("<button type='button'></button>");
        clone.addClass($(this).attr("class") + " loading-button");
        clone.append($(this).children("span:first").clone().addClass("loading").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"));

        $(this).parent().append(clone);
        $(this).hideSubmitButton();
        $(this).parents("form:first").addClass("sending");

	return this;
};

jQuery.fn.stopLoadingSubmit = function() {
	$(this).parents("form:first").removeClass("sending");
        $(".hidden-submit").removeClass("hidden-submit").show();
        $(this).remove();

	return this;
};

jQuery.fn.canSubmit = function() {
	 if($(this).hasClass("sending"))
               return false;

	return true;
};

jQuery.fn.hideSubmitButton = function() {
	$(this).addClass("hidden-submit").hide();
	return this;
};

$(document).ready(function(){        
  $(".title-me").tipTip();

  $(".hide-after-click").live("click", function(event)
  {
      $(this).hide();
  });


  $('form').submit(function(){
      if(!$(this).canSubmit() || $(this).hasClass("custom-submit"))
          return false;


      $('button[type=submit]', this).each(function(index){
          if(index == 0)
              $(this).loadingSubmit();
          else
              $(this).hideSubmitButton();
      });

      if($(this).hasClass("ajax-submit"))
      {
          $.get(this.action, $(this).serialize(), null, "script");
          return false;
      }

      return true;
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
