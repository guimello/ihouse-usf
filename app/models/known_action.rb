class KnownAction < ActiveRecord::Base
  validates_uniqueness_of :command
  serialize :handle

  def name
    I18n.t(:name, :scope => [:action, :known, command.to_sym])
  end
end
