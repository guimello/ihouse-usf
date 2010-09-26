require "#{Rails.root}/lib/active_record/acts/virtual.rb"
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Virtual)
