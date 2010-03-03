$(document).ready(function(){
	
	$(".user_style").change(function(){
		var theme = $(this).val();
		
		$(".change_style").each(function(style_tag)
		{
			$(this).attr("href", $(this).attr("href").replace(/stylesheets\/[a-z]+\//, "stylesheets/"+theme+"/"));			
		});
		
		return false;
	});
	
});