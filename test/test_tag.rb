require 'helper'

class TagModelTest < Test::Unit::TestCase
  context "A tag" do
    should "have a time" do
      Tag.new.respond_to? :time
    end

    should "have a station" do
      Tag.new.respond_to? :station
    end

    should "be invalid if time is missing" do
      assert !Tag.new(:station => "blah").valid?
    end

    should "be invalid if station is missing" do
      assert !Tag.new(:time => Time.parse('2011-01-01').utc.to_i).valid?
    end

    should "be invalid if time is invalid" do
      assert !Tag.new(:station => "0.c236.ce15.ce1.dab", :time => 0).valid?
    end

    should "be valid if station and time are provided" do
      tag = Tag.new(:time => Time.parse('2011-01-01').utc.to_i, :station =>"blah")
      assert tag.valid?
    end

    should "have timestamps" do
      Tag.new.respond_to? :created_at
      Tag.new.respond_to? :updated_at
    end

    should "have a uuid" do
      assert !Tag.new.uuid.empty?
    end

    context "with time and station" do
      setup do
        tag_time = Time.parse "2011-06-01T09:00:00Z"
        @tag = Tag.new(:time => tag_time.to_i, :station => '0.c224.ce15.ce1.dab')
        episode_data = {
          "pid"=>"p00h4xyn",
          "duration"=>2700,
          "service_outlet_key"=>"fm",
          "display_subtitle"=>"01/06/2011",
          "end_time"=>"2011-06-01T09:45:00Z",
          "timestamp"=>"2011-05-31T23:07:37.594Z",
          "brand_title"=>"Woman's Hour",
          "service_key"=>"radio4",
          "service_type"=>"radio",
          "type"=>"episode",
          "display_title"=>"Woman's Hour",
          "is_repeat"=>false,
          "service_title"=>"BBC Radio 4",
          "description"=>"Presented by Jane Garvey. UK under attack from Tineola Bisselliella - the clothes moth!",
          "brand_pid"=>"b007qlvb",
          "episode_title"=>"01/06/2011",
          "episode_pid"=>"b011jsq6",
          "schedule_day"=>"2011-05-31T23:00:00Z",
          "start_time"=>"2011-06-01T09:00:00Z"
        }

        mock_solr = mock()
        mock_solr.stubs(:episode).returns(episode_data)
        Solr.stubs(:new).with(@tag.time, 'radio4').returns(mock_solr)
      end

      should "fetch episode data from Solr" do
        assert_equal 'b011jsq6', @tag.episode_data['episode_pid']
      end

      should "calculate an offset time" do
        assert_equal 0, @tag.offset_time
      end

      should "return an iplayer url" do
        assert_equal "http://www.bbc.co.uk/iplayer/episode/b011jsq6?t=0s", @tag.iplayer_url
      end

      should "return a /programmes url" do
        assert_equal "http://www.bbc.co.uk/programmes/b011jsq6", @tag.programmes_url
      end

      should "return a canonical url" do
        assert_equal "http://www.bbc.co.uk/programmes/b011jsq6?t=0", @tag.canonical_url
      end

      should "return a title" do
        assert_equal "Woman's Hour", @tag.title
      end

      should "return a description" do
        assert_equal "Presented by Jane Garvey. UK under attack from Tineola Bisselliella - the clothes moth!", @tag.description
      end

      should "convert programmes id to a readable service title" do
        assert_equal "BBC Radio 4", @tag.service_title
      end
    end

    context "when looking up programmes id" do
      should "strip '/fm' when converting radio4 radiodns station id to programmes id" do
        tag = Tag.new(:time => 123, :station => '0.c224.ce15.ce1.dab')
        assert_equal 'radio4', tag.programmes_id
      end

      should "convert radio1 radiodns station id to programmes id" do
        tag = Tag.new(:time => 123, :station => '0.c221.ce15.ce1.dab')
        assert_equal 'radio1', tag.programmes_id
      end
    end
  end
end
