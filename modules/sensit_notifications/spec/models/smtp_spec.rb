require 'spec_helper'
require 'active_attr'

describe Smtp do
  # it { should have_attribute(:domain) }
  # it { should have_attribute(:address) }
  # it { should have_attribute(:port) }
  # it { should have_attribute(:username) }
  # it { should have_attribute(:crypted_password) }

  
  
  
  
  
  
  
  # it {should validate_numericality_of(:port).with_message("port is not a number (\"abcd\")")}


  it {should validate_presence_of(:domain)}
  it {should validate_presence_of(:address)}
  it {should validate_presence_of(:port)}
  
  # it should only validate the presence of the passwords if the username is present  
  it {should allow_value("foo@bar.com").for(:domain)}

  # it {should validate_presence_of(:password)}
  # it {should validate_presence_of(:password_confirmation)}
  
  

end
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

