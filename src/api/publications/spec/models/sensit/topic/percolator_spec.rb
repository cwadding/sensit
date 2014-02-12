require 'spec_helper'

module Sensit
	describe Topic::Percolator do

		describe "#create_rule" do
			it "creates a rule" do
				percolator = Sensit::Topic::Percolator.new(name: "rule")
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
				percolator = Sensit::Topic::Percolator.new(name: "rule")
				expect{
					percolator.destroy_rule
				}.to change(::Sensit::Rule, :count).by(-1)				
			end
		end		

		describe "#after_create" do
			before(:each) do
				@percolator = Sensit::Topic::Percolator.new(name: "rule")
			end
			describe 'after_create' do
				it 'should run the proper callbacks' do
					@percolator.should_receive(:create_rule)
					@percolator.run_callbacks(:create)
				end
			end
		end

		describe "#after_destroy" do
			before(:each) do
				@percolator = Sensit::Topic::Percolator.new(name: "rule")
			end
			describe 'after_destroy' do
				it 'should run the proper callbacks' do
					@percolator.should_receive(:destroy_rule)
					@percolator.run_callbacks(:destroy)
				end
			end
		end
	end
end