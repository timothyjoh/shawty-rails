# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Api::V1::Links', type: :request do
  describe 'POST /api/v1/links' do
    context 'with custom slug' do
      before do
        post '/api/v1/links',
             params: { url: 'https://alongwebsitedomainname.com/whatever_you_like_to_read.html', slug: 'goodread' }
      end

      it 'returns the url' do
        expect(JSON.parse(response.body)['url']).to eq('https://alongwebsitedomainname.com/whatever_you_like_to_read.html')
      end

      it 'returns the shorturl' do
        expect(JSON.parse(response.body)['shorty']).to eq('http://shawty.wtf/goodread')
      end

      it 'returns the mutation key' do
        link = Link.last
        expect(JSON.parse(response.body)['mutation_key']).to eq("#{link.slug}-#{link.secret}")
      end
    end

    context 'generated slug' do
      before do
        post '/api/v1/links',
             params: { url: 'https://alongwebsitedomainname.com/whatever_you_like_to_read.html' }
      end

      it 'returns the url' do
        expect(JSON.parse(response.body)['url']).to eq('https://alongwebsitedomainname.com/whatever_you_like_to_read.html')
      end

      it 'returns the shorturl' do
        link = Link.last
        expect(JSON.parse(response.body)['shorty']).to eq("http://shawty.wtf/#{link.slug}")
      end

      it 'returns the mutation key' do
        link = Link.last
        expect(JSON.parse(response.body)['mutation_key']).to eq("#{link.slug}-#{link.secret}")
      end
    end
  end

  describe 'PUT /api/v1/links/:id' do
    before(:each) do
      @link = create(:link)
      @new_slug = 'updated slug'
      put "/api/v1/links/#{@link.mutation_key}", params: { slug: @new_slug }
    end

    it 'responds with 202' do
      expect(response.status).to eq(202)
    end

    it 'updates the slug' do
      updated_link = Link.find(@link.id)
      expect(updated_link.slug).to eq(@new_slug.parameterize(separator: '_'))
      expect(JSON.parse(response.body)['mutation_key']).to include(updated_link.slug)
      expect(JSON.parse(response.body)['mutation_key']).to include(updated_link.secret)
    end

    it 'has a new short url' do
      updated_link = Link.find(@link.id)
      expect(JSON.parse(response.body)['shorty']).to include(updated_link.slug)
    end
  end

  describe 'DELETE /api/v1/links/:id' do
    before(:each) do
      @link_one = create(:link)
      @link_two = create(:link)
      delete "/api/v1/links/#{@link_one.mutation_key}"
    end

    it 'should respond with 200' do
      expect(response.status).to eq(200)
    end

    it 'should receive message' do
      expect(JSON.parse(response.body)['message']).to eq('Link successfully deleted.')
    end

    it 'should have one record remaining' do
      links = Link.all
      expect(links.size).to eq(1)
      expect(Link.last.slug).to eq(@link_two.slug)
    end
  end
end
# rubocop:enable Metrics/BlockLength
