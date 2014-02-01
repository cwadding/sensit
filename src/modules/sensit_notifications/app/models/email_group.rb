# == Schema Information
#
# Table name: email_groups
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  email_addresses :string(255)
#  phone_numbers   :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class EmailGroup < ActiveRecord::Base
  has_paper_trail
  attr_accessible :name, :addresses_sentence, :phone_numbers_sentence
  
  validates :name, :uniqueness => true, :length => {
    :minimum => 4,
    :maximum => 20
  }
  validates_presence_of :name
  
  validates_presence_of :addresses_sentence, :unless => Proc.new{ |group| group.phone_numbers.present?}
  validates_presence_of :phone_numbers_sentence, :unless => Proc.new{ |group| group.email_addresses.present?}

  serialize :email_addresses, Array
  serialize :phone_numbers, Array
  
  
  def addresses_sentence
    self.email_addresses.to_sentence if self.email_addresses.count > 0
  end
  
  def addresses_sentence=(address_text)
    unless address_text.blank?
      address_text.split(/[\s+]?[;,|:\s][\s+]?/).each do |address|
        self.email_addresses << address
      end
    end
  end
  
  def phone_numbers_sentence
    self.email_addresses.to_sentence if self.email_addresses.count > 0
  end
  
  def phone_numbers_sentence=(phone_text)
    unless phone_text.blank?
      phone_text.split(/[\s+]?[;,|:\s][\s+]?/).each do |phone|
        self.phone_numbers << phone
      end
    end
  end
end
