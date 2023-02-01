require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_albums_table
    seed_sql = File.read('spec/seeds/albums_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library2_test' })
    connection.exec(seed_sql)
  end
  
  describe AlbumRepository do
    before(:each) do 
      reset_albums_table
    end
  
  def reset_artists_table
      seed_sql = File.read('spec/seeds/artists_seeds.sql')
      connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library2_test' })
      connection.exec(seed_sql)
  end
    
   describe ArtistRepository do
      before(:each) do 
        reset_artists_table
    end

  context 'GET/albums' do
    it 'should return the list of albums' do 
      response = get('/albums')


      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
      expect(response.body).to include('<a href="/albums/1"')
    end
  end
    
  context 'GET/albums/:id' do
    it 'should return info about the album 1' do
      response = get('/albums/1')


      expect(response.status).to eq(200)
      # expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
    end
  end

  context 'POST/albums' do
    it 'should create a new album' do
      response = post('/albums', 
      title: 'OK Computer', 
      release_year: '1997', 
      artist_id: '1')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

    end
  end

  context 'GET/artists' do
    it 'should return all artists' do
      response = get('/artists')

      expected_response = 'Pixies'

      expect(response.status).to eq(200)
      expect(response.body).to include(expected_response)
      expect(response.body).to include('<a href="/artists/1">')
    end
  end

  context 'GET/artists/:id' do
    it 'should return an artist with artist id 1' do
      response = get('/artists/1')

      expected_response = 'Pixies'

      expect(response.status).to eq(200)
      expect(response.body).to include(expected_response)
      
    end
  end

  context 'POST/artists' do
    it 'should create a new album' do
      response = post('/artists',
      name: 'Wild nothing',
      genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')
    end
  end
end
end

end
