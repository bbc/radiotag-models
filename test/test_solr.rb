require 'helper'

class SolrTest < Test::Unit::TestCase
  context "Solr" do
    setup do
      @tag_time = 1234567890 # February 13, 2009 at 23:31:30
      @solr = Solr.new(@tag_time, 'radio4')
    end

    should "build a start time query from the time" do
      assert_equal @solr.start_term, "start_time:[* TO 2009-02-13T23:31:30Z]"
    end

    should "build an end time query from the time" do
      assert_equal @solr.end_term, "end_time:[2009-02-13T23:31:30Z TO *]"
    end

    should "build a servie query from the key" do
      assert_equal @solr.service_term, 'service_key:"radio4"'
    end

    should "build a full query string by joining terms by AND" do
      solr = Solr.new(1234, 'radio4')
      solr.expects(:start_term).returns('andy')
      solr.expects(:end_term).returns('bob')
      solr.expects(:service_term).returns('chris')

      assert_equal solr.solr_query_string, "andy AND bob AND chris"
    end

    should "build a URI escaped query" do
      solr = Solr.new(1234, 'radio4')
      solr.expects(:solr_query_string).returns('bob AND fred')
      assert_equal solr.query_path, "/solr/select?q=bob%20AND%20fred&wt=json"
    end

    should "extract the relevant data from the returned JSON" do
      solr = Solr.new(1234, 'radio4')
      solr.expects(:data).returns({"response" => {"docs" => ["the data"]}})

      assert_equal solr.episode, "the data"
    end
  end
end
