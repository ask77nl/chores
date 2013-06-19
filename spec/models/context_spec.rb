require 'spec_helper'

describe Context do

 before { @context = FactoryGirl.build(:context) }
 subject { @context }

 it { should respond_to(:name) }

end
