require 'spec_helper'

describe User do

before do
    @user = FactoryGirl.build(:user) 
  end

subject {@user}

 it { should respond_to(:email) }
 it { should respond_to(:encrypted_password) }
 it { should respond_to(:password) }
 it { should respond_to(:password_confirmation) }


describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
 end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end


describe "when password is not present" do
  before { @user.password = @user.password_confirmation = " " }
  it { should_not be_valid }
end

describe "when password doesn't match confirmation" do
  before { @user.password_confirmation = "mismatch" }
  it { should_not be_valid }
end


end
