$(document).ready(function()
{
  $("#basic-search").submit(function(){
    $.get(this.action, $(this).serialize(), null, "script");
    return false;
  })
});