class KnownAction < ActiveRecord::Base
  validates_uniqueness_of :command
  validates_numericality_of :command, :only_integer => true
  serialize :handle

  def name
    I18n.t(:name, :scope => [:action, :known, ("command_#{command}").to_sym])
  end
end
