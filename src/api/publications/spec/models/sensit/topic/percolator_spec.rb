require 'spec_helper'

module Sensit
	describe Topic::Percolator do

		describe "#create_rule" do
			it "creates a rule" do
				percolator = new Sensit::Topic::Percolator(name: "rule")
				expect{
					percolator.create_rule
				}.to change(::Sensit::Rule, :count).by(1)				
			end
		end

		describe "#destroy_rule" do
			before(:each) do
				Sensit::Rule.create(:name => "rule")
			end
			it "destroys the rule" do
				percolator = new Sensit::Topic::Percolator(name: "rule")
				expect{
					percolator.destroy_rule
				}.to change(::Sensit::Rule, :count).by(-1)				
			end
		end		

		describe "#after_create" do
			before(:each) do
				@feed = Topic::Feed.new
			end
			describe 'after_create' do
				it 'should run the proper callbacks' do
					@feed.should_receive(:create_rule)
					@feed.run_callbacks(:after_create)
				end
			end
		end

		describe "#after_destroy" do
			before(:each) do
				@feed = Topic::Feed.new
			end
			describe 'after_destroy' do
				it 'should run the proper callbacks' do
					@feed.should_receive(:destroy_rule)
					@feed.run_callbacks(:after_update)
				end
			end
		end
	end
end