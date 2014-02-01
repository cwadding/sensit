module ViewMacros
  def mark_required(klass, attribute)
      "* #{klass.human_attribute_name(attribute)}" if klass.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator  
  end
end