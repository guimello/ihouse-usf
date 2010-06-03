jQuery.fn.actAsTabbable = function(options)
{
  var settings;
  
  if (typeof options == "object") settings = options;
  
  settings = $.extend({
    "deleteTitles": true,
    "tabClass": "tabmeplz"
  }, settings || {});
  
  var self = this;
  
  var list = $(document.createElement("ul")).addClass("basic-tab");
  
  var tabIndex = 0;
  
  $(this).children(".tabmeplz").each(function()
  {
    var title = $(this).find(".tab-title").html();
    var link = "<a href='#' class='tablink' tabindex='" + tabIndex + "'>" + title + "</a>";
    
    $(list).append($(document.createElement("li")).html(link));
    
    if (settings.deleteTitles) $(this).find(".tab-title").remove();
    
    tabIndex++;
  });
  
  $(list).children("li:first").addClass("selected");
  
  var div = $(document.createElement("div")).addClass("tabsplz-navigation");
  $(div).append(list);
  
  $(this).prepend("<div class='clear'></div>").prepend(div);
  
  $(this).children(".tabmeplz").hide();
  $(this).children(".tabmeplz:first").show();
  
  $(".tabsplz-navigation").find(".tablink").click(function()
  {
    $(this).parents("li").siblings().removeClass("selected");
    $(this).parents("li").addClass("selected");
    
    $(self).children(".tabmeplz").hide();
    
    var index = parseInt($(this).attr("tabindex")) + 2;

    $(self).children("div:eq(" + index + ")").show();
    
    return false;
  });
  
  return this;
}

$(document).ready(function()
{
  $(".basic-tab").find("a").click(function()
  {
    $(".basic-tab").find("li").removeClass("selected");
    $(this).parent().addClass("selected");
  });
  
  $(".hastabs").actAsTabbable();
  $(".hastabs2").actAsTabbable({"deleteTitles": false});
});
