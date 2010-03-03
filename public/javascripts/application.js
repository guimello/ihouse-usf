// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.ajaxSetup({ 
	beforeSend: function(request) {
		request.setRequestHeader("Accept", "text/javascript");
                $("submit").hide();
	},
        complete: function(event, XMLHttpRequest, ajaxOptions) {
                $("submit").show();
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

$(document).ready(function(){
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