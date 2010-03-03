$(document).ready(function()
{
    $(".pagination a").live("click", function()
    {
        $.bbq.pushState({ page: $.deparam.querystring(this.href).page });
        return false;
    });
    
    $(window).bind("hashchange.page", function(e)
    {
        $.getScript($.param.querystring(document.location.href, e.fragment));
    });
    
    $(window).trigger("hashchange.page");
});