$(document).ready(function(){
   $(".find-device-actions").live("click", function(){
          $.getScript(this.href);
          return false;
   });
});