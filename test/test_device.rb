require 'helper'

class DeviceTest < Test::Unit::TestCase
  context "A Device" do
    setup do
      Device.all.destroy
    end

    should "generate a PIN when created" do
      device = Device.create(:token => "ABC123")
      assert device.pin =~ /\d{4}/, "device.pin (#{device.pin}) should be 4 digits"
    end

  end
end
