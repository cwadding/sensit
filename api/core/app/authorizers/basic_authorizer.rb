class BasicAuthorizer < ApplicationAuthorizer
  # Class method: can this user at least sometimes create a Schedule?
  def self.creatable_by?(user)
    user.manager?
  end

  # Instance method: can this user delete this particular schedule?
  def deletable_by?(user)
    # resource.in_future? && user.manager? && resource.department == user.department
  end
end