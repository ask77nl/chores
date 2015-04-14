require 'spec_helper'

describe Choretype do

 before { @choretype = FactoryGirl.build(:choretype) }
 subject { @choretype }

 it { should respond_to(:name) }

describe "when name is not present" do
    before { @choretype.name = "" }
    it { should_not be_valid }
  end

end
