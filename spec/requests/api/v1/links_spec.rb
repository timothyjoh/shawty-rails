# frozen_string_literal: true

require 'rails_helper'

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
end
