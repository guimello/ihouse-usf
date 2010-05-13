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
     });
     
   $(".discover-devices").live("click", function(){
          $.getScript(this.href);
          return false;
   });

   $(".edit-special-fields-on-device").live("click", function(){	 
          $(this).closest("tr").find(".enable-disable-advanced").attr("disabled", "");
          $(this).closest("tr").find(".enable-disable-advanced").first().focus();
          return false;
   });

   $(".device-form").submit(function(){
          $(this).find(".enable-disable-advanced").attr("disabled", "");          
   });

   $(".device-icon").live("click", function(){
          $(this).deviceIconBox();
   });
});