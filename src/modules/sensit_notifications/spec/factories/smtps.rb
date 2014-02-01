# == Schema Information
#
# Table name: smtps
#
#  id              :integer(4)      not null, primary key
#  server          :string(255)
#  port            :integer(4)
#  username        :string(255)
#  password_digest :string(255)
#  email_address   :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :smtp do
    address "smtp.gmail.com"
    domain "foobar@gmail.com"
    port 465    
  end
  factory :smtp_withauth, :parent => :smtp do
    username "foobar"
    password "password"
    password_confirmation "password"
  end
end
