require 'ostruct'

################################################################################
module ActiveRecord
  ################################################################################
  module Acts
    ################################################################################
    module Virtual
      
      ################################################################################
      def self.included(base)
        base.send :extend, ClassMethods
      end
      
      ################################################################################
      module ClassMethods
      
        ################################################################################
        def act_as_virtual(attribute, options = {})
          serialize attribute
          
          before_validation :convert_custom_attributes_to_hash
          after_validation :convert_custom_attributes_to_ostruct
          
           
          define_method :after_initialize do
            self.send "#{attribute}=", OpenStruct.new((eval(attribute.to_s).kind_of?(OpenStruct)) ? eval(attribute.to_s).marshal_dump : eval(attribute.to_s))
          end
                   
          define_method :convert_custom_attributes_to_hash do
            self.send "#{attribute}=", eval(attribute.to_s).marshal_dump if eval(attribute.to_s).kind_of? OpenStruct
          end

          define_method :convert_custom_attributes_to_ostruct do
            self.send "#{attribute}=", OpenStruct.new(eval(attribute.to_s)) if eval(attribute.to_s).kind_of? Hash
          end         
          
          #send :include, InstanceMethods
        end       
      end
      
      ################################################################################
      module InstanceMethods              
      end      
    end
  end
end
