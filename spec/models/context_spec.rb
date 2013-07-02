require 'spec_helper'

describe Context do

 before { @context = FactoryGirl.build(:context) }
 subject { @context }

 it { should respond_to(:name) }


 describe "when name is not present" do
    before { @context.name = "" }
    it { should_not be_valid }
 end

end

