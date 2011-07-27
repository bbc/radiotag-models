require 'helper'

class UserModelTest < Test::Unit::TestCase
  context "A User" do
    context "with 3 tags" do
      setup do
        @user = User.new
        device = Device.new :user_id => @user.id
        @user.devices << device

        day = 24*60*60
        @today = Tag.new(:station => 'abc', :time => Time.now.to_i)
        @yesterday = Tag.new(:station => 'abc', :time => Time.at(@today.time - day))
        @day_before_yesterday = Tag.new(:station => 'abc', :time => Time.at(@today.time - (day*2)))

        device.tags << @today
        device.tags << @yesterday
        device.tags << @day_before_yesterday
        @user.save!
      end

      should "have tags ordered by time" do
        assert_equal @today, @user.tags_by_time.first
      end

      should "have a limit on the tags returned" do
        assert_equal 1, @user.tags_by_time(:limit => 1).size
      end

      should "have an offset on the tags returned" do
        assert_equal @yesterday, @user.tags_by_time(:limit => 1, :offset => 1).first
      end

      should "group tags by the day they were created" do
        todays_tags = @user.tags_grouped_by_day[0]
        assert_equal @today, todays_tags.first

        yesterdays_tags = @user.tags_grouped_by_day[1]
        assert_equal @yesterday, yesterdays_tags.first
      end
    end
  end
end
