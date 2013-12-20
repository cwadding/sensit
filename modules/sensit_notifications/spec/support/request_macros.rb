module RequestMacros
  
  # attr_accessor :user, :company
  
  
  def login_user(user, password)
    visit new_user_session_path
    fill_in I18n.t("activerecord.attributes.user.login"), :with => user.username
    fill_in I18n.t("activerecord.attributes.user.password"), :with => password
    click_button I18n.t("global.submit-login")
  end
  
  def login
    @user ||= FactoryGirl.create(:user, :password => "password")
    login_user(@user, "password")
    @user
  end
  
  # def with_role(role)
  #   @user = login if @user.nil?
  #   @job ||= FactoryGirl.create(:job)
  #   @job.roles |= [Role.find_or_create_by_name(role)]
  #   @user.jobs |= [@job]
  # end
end