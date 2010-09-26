class KnownActionsController < ApplicationController

  skip_before_filter :check_user_logged, :set_locale, :get_user, :check_user_is_correct

  def find
    @known_action = KnownAction.find_by_command params[:command]
    respond_to do |format|
      format.json {render :json => @known_action.to_json}
    end
  end
end
