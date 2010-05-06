$(document).ready(function(){
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
});