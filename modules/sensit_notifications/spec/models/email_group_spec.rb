require 'spec_helper'

describe EmailGroup do
  it { should allow_mass_assignment_of(:name)}
  it { should allow_mass_assignment_of(:addresses_sentence)}
  it { should allow_mass_assignment_of(:phone_numbers_sentence)}

  it { should validate_presence_of(:name)}
  
  it {should ensure_length_of(:name).is_at_least(4).is_at_most(20)}
  

  describe "virtual attributes" do
    before(:each) do
      @email_group = EmailGroup.new
    end
    describe "#addresses_sentence" do
      context "without recipients" do
        it "should return a blank string" do
          @email_group.send(:addresses_sentence).should be_blank
        end
      end
      context "with recipients" do
        before(:each) do
          @email_group.email_addresses = ['dfdsf@fssa.com', 'sasdsa@dfsdf.com', 'sadsa@ffsafs.com']
        end
        it "should join the addresses into a single string" do
          @email_group.send(:addresses_sentence).should == 'dfdsf@fssa.com, sasdsa@dfsdf.com, and sadsa@ffsafs.com'
        end
      end
    end
    describe "#addresses_sentence=" do
      # context "with valid emails" do
      #   before(:all) do
      #     @emails = ['dfdsf@fssa.com','sasdsa@dfsdf.com','sadsa@ffsafs.com']
      #   end
      #   after(:each) do
      #     @email_group.email_addresses.count should == 3
      #   end
      #   it "should split the string with spaces" do
      #     @email_group.addresses_sentence = @emails.join(' ')
      #   end
      #   it "should split the string with ;" do
      #     @email_group.addresses_sentence = @emails.join('; ')
      #   end
      #   it "should split the string with ," do
      #     @email_group.addresses_sentence = @emails.join(', ')
      #   end
      #   it "should split the string with a line return" do
      #     @email_group.addresses_sentence = @emails.join("\n")
      #   end
      # end
    end
  end
  
  
end
# == Schema Information
#
# Table name: email_groups
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

