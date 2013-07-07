require 'spec_helper'

def parse_datetime_in_london(string)
  ActiveSupport::TimeZone["London"].parse(string)
end

describe InBusiness do
    
  after(:each) do
    InBusiness.reset # Clear the settings so they can be set for this example
  end

  describe ".hours" do

    it "returns an OpenStruct by default" do
      InBusiness.hours.should be_a OpenStruct
    end

    it "can be updated from the method" do
      InBusiness.hours.monday.should be_nil
      InBusiness.hours.monday = "09:00".."18:00"
      InBusiness.hours.monday.should eq "09:00".."18:00"
    end

  end

  describe ".hours=" do
    let(:monday_hours) { "09:00".."18:00" }
    let(:options) { { monday: monday_hours } }

    it "instantiates an OpenStruct with the contents of the passed hash" do
      InBusiness.hours = options
      InBusiness.hours.monday.should eq monday_hours
    end

  end

  describe ".holidays" do

    it "returns an empty array by default" do
      InBusiness.holidays.should be_a Array
      InBusiness.holidays.length.should eq 0
    end

    it "can be updated from the method" do
      expect{InBusiness.holidays << Date.parse('1st January 2014')}.to change(InBusiness.holidays, :length).from(0).to(1)
    end

  end

  describe ".holidays=" do
    let(:holidays) do
      [Date.parse('1st January 2014'), Date.parse('1st February 2014')]
    end

    it "sets the holidays array to the passed array" do
      InBusiness.holidays = holidays
      InBusiness.holidays.should eq holidays
    end

  end

  describe ".days" do
    it "returns a hash" do
      InBusiness.days.should be_a Hash
    end

    it "contains mappings of weekday numbers to their English representation" do
      InBusiness.days.fetch("1").should eq "monday"
    end
  end

  describe ".reset" do

    before do
      InBusiness.holidays << Date.parse("1st January 2014")
      InBusiness.hours.monday = "09:00".."23:00"
      InBusiness.reset
    end

    it "resets .holidays to a blank array" do
      InBusiness.holidays.should be_a Array
      InBusiness.holidays.length.should eq 0
    end

    it "resets .hours to an empty OpenStruct" do
      InBusiness.hours.should be_a OpenStruct
      InBusiness.hours.marshall_dump.should be_nil
    end

  end

  describe ".is_holiday?" do
    let(:first_jan_2014) { Date.parse("1st January 2014") }
    before { InBusiness.holidays << first_jan_2014 }

    it "returns true if the provided date is a defined holiday" do
      InBusiness.is_holiday?(first_jan_2014).should be_true
    end

    it "returns false if the provided date is not a defined holiday" do
      InBusiness.is_holiday?(first_jan_2014 + 1.day).should be_false
    end

  end

  context "with no hours set" do

    describe ".open?" do

      it "returns false" do
        Timecop.freeze(DateTime.now) do
          InBusiness.open?(DateTime.now).should be_false
        end
      end

    end

    describe ".closed?" do

      it "returns true" do
        Timecop.freeze(DateTime.now) do
          InBusiness.closed?(DateTime.now).should be_true
        end
      end

    end
  end

  context "with hours set" do
    before do 
      InBusiness.hours.monday = "09:00".."20:00"
    end

    describe ".open?" do

      it "returns true for a time within the hours" do
        Timecop.freeze(parse_datetime_in_london("8th July 2013 12:00")) do
          InBusiness.open?(DateTime.now).should be_true
        end
      end

      it "returns false for a time outside of the hours" do
        Timecop.freeze(parse_datetime_in_london("8th July 2013 20:01")) do
          InBusiness.open?(DateTime.now).should be_false
        end
      end

      it "returns false for a day that hasn't had hours set" do
        Timecop.freeze(parse_datetime_in_london("9th July 2013 10:00")) do
          InBusiness.open?(DateTime.now).should be_false
        end
      end

    end

    describe ".closed?" do

      it "returns false for a time within the hours" do
        Timecop.freeze(parse_datetime_in_london("8th July 2013 19:59")) do
          InBusiness.closed?(DateTime.now).should be_false
        end
      end

      it "returns true for a time outside of the hours" do
        Timecop.freeze(parse_datetime_in_london("8th July 2013 20:01")) do
          InBusiness.closed?(DateTime.now).should be_true
        end
      end

      it "returns true for a day that hasn't had hours set" do
        Timecop.freeze(parse_datetime_in_london("9th July 2013 10:00")) do
          InBusiness.closed?(DateTime.now).should be_true
        end
      end

    end

  end

  context "with holidays set" do

    before do
      InBusiness.holidays << Date.parse("8th July 2013")
      InBusiness.holidays << Date.parse("1st January 2014")
      InBusiness.hours.tuesday = "09:00".."11:00"
    end

    describe ".open?" do

      it "returns false if the passed date is one of the holidays" do
        Timecop.freeze(parse_datetime_in_london("8th July 2013 12:00")) do
          InBusiness.open?(DateTime.now).should be_false
        end
      end

      it "returns true if the passed date is not one of the holidays" do
        Timecop.freeze(parse_datetime_in_london("9th July 2013 10:01")) do
          InBusiness.open?(DateTime.now).should be_true
        end
      end

    end

    describe ".closed?" do

      it "returns true if the passed date is one of the holidays" do
        Timecop.freeze(parse_datetime_in_london("1st January 2014 00:00")) do
          InBusiness.closed?(DateTime.now).should be_true
        end
      end

      it "returns false if the passed date is not one of the holidays" do
        Timecop.freeze(parse_datetime_in_london("9th July 2013 10:01")) do
          InBusiness.closed?(DateTime.now).should be_false
        end
      end

    end

  end



end