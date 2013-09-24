require 'spec_helper'
require 'delegate'

class MyClass
  include InBusiness
end

describe "Using InBusiness as a module" do
  subject do
    MyClass.new
  end

  describe "it responds to the same API as InBusiness" do
    it { should respond_to(:open?) }
    it { should respond_to(:closed?) }
    it { should respond_to(:hours) }
    it { should respond_to(:hours=) }
    it { should respond_to(:holidays) }
    it { should respond_to(:holidays=) }
    it { should respond_to(:reset) }
    it { should respond_to(:is_holiday?) }
    it { should respond_to(:days) }
  end
end
