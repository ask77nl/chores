require 'spec_helper'

describe Choretype do

 before { @choretype = FactoryGirl.build(:choretype) }
 subject { @choretype }

 it { should respond_to(:name) }

end
