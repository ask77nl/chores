require 'spec_helper'

describe Email do

 before { @email = FactoryGirl.build(:email) }
 subject { @email }

 it { should respond_to(:from) }
 it { should respond_to(:to) }
 it { should respond_to(:subject) }
 it { should respond_to(:body) }

describe "when subject is not present" do
    before { @email.subject = "" }
    it { should_not be_valid }
  end

end
