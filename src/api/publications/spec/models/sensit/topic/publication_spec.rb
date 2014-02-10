require 'spec_helper'

module Sensit
	describe Topic::Publication do
		it { should validate_presence_of(:host) }
		it {should belong_to :topic}

		it {should have_many(:percolations).dependent(:destroy)}
		it {should have_many(:rules).through(:percolations)}
		

		describe ".with_action" do
			before(:each) do
				@publication = FactoryGirl.create(:publication)
				@publication.actions = ["create", "destroy"]
				@publication.save
			end
			it "returns the publications matching the action" do
				publications = Topic::Publication.with_action("create")
				publications.map(&:id).should include(@publication.id)
			end
		end

		describe ".with_rules" do
			before(:each) do
				@publication1 = FactoryGirl.create(:publication)
				@publication1.rules << Sensit::Rule.create(:name => "Rule1")
				rule2 = Sensit::Rule.create(:name => "Rule2")
				@publication1.rules << rule2
				rule3 = Sensit::Rule.create(:name => "Rule3")
				@publication1.rules << rule3
				@publication2 = FactoryGirl.create(:publication)
				@publication2.rules << rule3
				@publication3 = FactoryGirl.create(:publication)
				@publication3.rules << rule2
			end
			it "returns the publications matching the action" do
				publications = Topic::Publication.with_rules(["Rule1", "Rule2"])
				publications.map(&:id).should include(@publication1.id)
				publications.map(&:id).should include(@publication2.id)
			end
		end		


		describe "#actions=" do
			it "sets the bitmask for the actions actions" do
				publication = Topic::Publication.new
				publication.actions = ["create" "destroy"]
				publication.actions_bitmask.should == 5
			end
		end

		describe "#actions" do
			publication = Topic::Publication.new
			publication.actions_bitmask = 5
			publication.actions.should == ["create" "destroy"]
		end	

		describe "#publish"	do
			# publish(message, action)
		end
	end
end
