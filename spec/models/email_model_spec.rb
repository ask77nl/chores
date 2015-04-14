require 'spec_helper'

describe Email do

 before { @email = FactoryGirl.build(:email) }
 subject { @email }

 it { should respond_to(:from) }
 it { should respond_to(:to) }
 it { should respond_to(:subject) }
 it { should respond_to(:body) }
 it { should respond_to(:user_id) }

describe "when subject is not present" do
    before { @email.subject = "" }
    it { should_not be_valid }
  end

describe "when user is not present" do
    before { @email.user_id = "" }
    it { should_not be_valid }
  end


end
