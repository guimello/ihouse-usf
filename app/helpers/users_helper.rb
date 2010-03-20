module UsersHelper
  def locale_select(form)
    form.select :locale, {t(:portuguese, :scope => :locale) => "pt",
                          t(:english, :scope => :locale) => "en"}
  end

  def theme_select(form)
    form.select :style, {t(:blue, :scope => [:user, :style, :colors]) => "blue",
                         t(:green, :scope => [:user, :style, :colors]) => "green",
                         t(:pink, :scope => [:user, :style, :colors]) => "pink",
                         t(:black, :scope => [:user, :style, :colors]) => "black",
                         t(:red, :scope => [:user, :style, :colors]) => "red",
                         t(:darkred, :scope => [:user, :style, :colors]) => "darkred",
                         t(:yellow, :scope => [:user, :style, :colors]) => "yellow",
                         t(:white, :scope => [:user, :style, :colors]) => "white"}
  end 
end
