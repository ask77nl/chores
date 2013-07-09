require 'spec_helper'

describe Context do

 before { @context = FactoryGirl.build(:context) }
 subject { @context }

 it { should respond_to(:name) }
 it { should respond_to(:user_id) }



 describe "when name is not present" do
    before { @context.name = "" }
    it { should_not be_valid }
 end

 describe "when user_id is not present" do
    before { @context.user_id = "" }
    it { should_not be_valid }
 end

end

