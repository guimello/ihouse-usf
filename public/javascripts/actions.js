$(document).ready(function(){
   $(".find-device-actions").live("click", function(){
      $(this).loadingSubmit();
      $.getScript(this.href);
      return false;
   });
});


jQuery.fn.actionIconBox = function(options){
  $(this).removeActionIconBox();

  var boxIcon = $("<div>").css({position: "absolute", left: $(this).position().left + 20, top: $(this).position().top, width: 200,
  backgroundColor: "white", zIndex: 9999999}).
  addClass('rounded-4 shadow-normal pading-medium').attr("id", "action_icon_box");

   var title = $("<div>").html("").addClass("title lightest rounded-4");
   var close = $("<div>").addClass('icon cross close-icons-choice pointer-me float-right').html("&nbsp;");
   //css({position: "relative", left: 50, display: "inline"});
   title.append(close);
   title.append("<div class='clear'></div>")
   boxIcon.append(title);
   var inner = $("<div>").css({margin: "10px 10px 10px 10px"});

   var icons = allToggleIcons();

   for(var i = 0; i < icons.length; i = i + 2)
   {
      if(i % 9 == 0 && i != 0)
        inner.append("<div>&nbsp;</div>");
      outter = $('<span>').addClass('outter').css({margin: '1px 10px 1px 1px'});
      outter.append($("<span>").addClass("pointer-me action-icon-chosen on icon " + icons[i]));
      outter.append($("<span>").addClass("pointer-me action-icon-chosen off icon " + icons[i + 1]));
      inner.append(outter);
   }


   boxIcon.append(inner);
   $(this).parent().append(boxIcon);
   return $(this);
};

jQuery.fn.removeActionIconBox = function(){
          $("#action_icon_box").remove();
          return $(this);
};

$(document).ready(function(){
   $(".action-icon-chosen").live("click", function(){
        var outter = $(this).closest('span.outter');
        var divIcon = $(this).closest("dd").find(".action-icon-on");
        var classes = divIcon.attr("class");

        var divArrayClass = classes.split(" ");
        
        var iconClass = $('.on', outter).attr("class");
        iconClass = iconClass.split(" ");

        var newClass = iconClass[iconClass.length - 1];
        divIcon.removeClass(divArrayClass[divArrayClass.length - 1]).addClass(newClass);
        $(this).closest("dd").find(".hidden-action-icon-on").val(newClass);

        divIcon = $(this).closest("dd").find(".action-icon-off");
        classes = divIcon.attr("class");

        divArrayClass = classes.split(" ");

        iconClass = $('.off', outter).attr("class");
        iconClass = iconClass.split(" ");

        newClass = iconClass[iconClass.length - 1];
        divIcon.removeClass(divArrayClass[divArrayClass.length - 1]).addClass(newClass);
        $(this).closest("dd").find(".hidden-action-icon-off").val(newClass);
        $(this).removeActionIconBox();

        return $(this);
     });

     $(".close-icons-choice").live("click", function(){
        $(this).removeActionIconBox();
     });

   $(".action-icon").live("click", function(){
          $(this).actionIconBox();
   });
});