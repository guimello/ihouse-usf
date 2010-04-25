$(document).ready(function(){
   $(".discover-devices").live("click", function(){
          $.getScript(this.href);
          return false;
   });
});