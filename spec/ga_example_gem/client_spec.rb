require 'spec_helper'

describe GaExampleGem::Client do
	before do
    @client = GaExampleGem::Client.new
    @client.configure do |config|
      config.api_key = "its a secret to everybody"
    end
  end

  describe '#get_xkcd' do
  	before do
      # Intercept an HTTP request that looks like this,
      # and return a specific JSON file instead for the body
      stub_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?num=1').
        to_return(body: fixture('single_xkcd.json'))
    end

    it "fetchs a single xkcd webcomic" do
      # Make the request
      comic = @client.get_xkcd(1)

      # Expect that you made a request
      expect(a_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?num=1')).to have_been_made

      # Check the results of the JSON file/body of HTTP request that we intercepted
      expect(comic.first["title"]).to eq "Barrel - Part 1"
    end
  end

  describe '#get_xkcds_from_year' do
    before do
      stub_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?year=2006').to_return(body: fixture('xkcds_year.json'))
    end

    it 'fetches all comics from a year when passed year' do
      year_comics = @client.get_xkcds_from_year(2006)

      expect(a_request(:get, 'http://xkcd-unofficial-api.herokuapp.com/xkcd?year=2006')).to have_been_made

      expect(year_comics.first["safe_title"]).to eq "Barrel - Part 1"

      expect(year_comics.last["safe_title"]).to eq "Island (sketch)"



    end
  end
end