################################################################################
module Locale

  ################################################################################
  def self.included(klass)
    klass.class_eval do

      ################################################################################
      def set_locale
        default_locale = :en
        
        if user_logged?
          locale = current_user.locale
        else
          #locale = request.env['HTTP_ACCEPT_LANGUAGE'].nil? ? nil : request.env['HTTP_ACCEPT_LANGUAGE'][/[^,;]+/]
          locale = request.env['HTTP_ACCEPT_LANGUAGE'].nil? ? nil : request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
        end
        
        begin
          I18n.locale = locale
        rescue
          I18n.locale = default_locale
        end
      end
    end
  end
end