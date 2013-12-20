shared_examples_for "a template that renders the rules/form partial" do
  it "renders the rules/form partial" do
    render
    rendered.should render_template(:partial => "form", :locals => { :rule => @rule })
  end
end

shared_examples_for "a template that renders the email_groups/form partial" do
  it "renders the email_groups/form partial" do
    render
    rendered.should render_template(:partial => "form", :locals => { :email_group => @email_group })
  end
end

shared_examples_for "a template that renders the sources/form partial" do
  it "renders the sources/form partial" do
    render
    rendered.should render_template(:partial => "form", :locals => { :source => @source })
  end
end

# shared_examples_for "a template that renders the shared/page_fields partial" do |record|
#   it "renders the shared/page_fields partial" do
#     simple_form_for(@product_category) {|f| @f = f}
#     render
#     rendered.should render_template(:partial => "shared/page_fields", :locals => { :f => @f })
#   end
# end
# 
# shared_examples_for "a template that renders the shared/address_fields partial" do |record|
#   it "renders the shared/address_fields partial" do
#     simple_form_for(record) {|f| @f = f}
#     render
#     rendered.should render_template(:partial => "shared/address_fields", :locals => { :f => @f })
#   end
# end

def add_load_paths
  before(:each) do
    view.lookup_context.prefixes << 'base' << 'application'
  end
end

def ability_authorization
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end
end

def lower_plural_human(class_name)
  class_name.model_name.human.downcase.pluralize
end