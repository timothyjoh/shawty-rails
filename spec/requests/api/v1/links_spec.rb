# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'api/v1/links', type: :request do
  path '/api/v1/links' do
    post('create link') do
      tags 'Convert a URL to a Shorty'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          url: {
            type: :string,
            description: 'The destination URL that needs shortening',
            example: 'https://thislongwebsitedomainname.is/way_too_long.html'
          },
          slug: {
            type: :string,
            description: 'A short slug (if blank, this will be auto-generated)',
            example: 'shortslug'
          }
        }
      }

      response(200, 'The Shorty was successfully created') do
        schema type: :object,
               properties: {
                 url: { type: :string, description: 'The destination URL',
                        example: 'https://thislongwebsitedomainname.is/way_too_long.html' },
                 shorty: { type: :string, description: 'The shortened URL, will redirect to the destination',
                           example: 'http://shawty.wtf/shortslug' },
                 mutation_key: { type: :string, description: 'Use this key in PUT and DELETE API calls',
                                 example: 'shortslug-somesecretkeyforediting' },
                 editable: { type: :string, description: 'A URL to an editable form on this site',
                             example: 'http://shawty.wtf/shortslug-somesecretkeyforediting' },
                 message: { type: :string, description: 'Status message after creation',
                            example: 'Link successfully created.' }
               }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/links/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'The `mutation_key`'

    put('update link') do
      tags 'Update the `slug` of a Shorty'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          slug: {
            type: :string,
            description: 'Update the slug with this parameter',
            example: 'My new slug'
          }
        }
      }

      response(202, 'The Shorty\'s slug was successfully updated') do
        schema type: :object,
               properties: {
                 url: { type: :string, description: 'The destination URL',
                        example: 'https://thislongwebsitedomainname.is/way_too_long.html' },
                 shorty: { type: :string, description: 'The shortened URL, will redirect to the destination',
                           example: 'http://shawty.wtf/my_new_slug' },
                 mutation_key: { type: :string, description: 'Use this key in PUT and DELETE API calls',
                                 example: 'my_new_slug-somesecretkeyforediting' },
                 editable: { type: :string, description: 'A URL to an editable form on this site',
                             example: 'http://shawty.wtf/my_new_slug-somesecretkeyforediting' },
                 message: { type: :string, description: 'Status message after creation',
                            example: 'Link successfully updated.' }
               }

        let(:id) { Link.create(url: 'https://thisisthelongesturlever.co.uk').mutation_key }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete link') do
      tags 'Delete a Shorty'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'The Shorty was deleted') do
        schema type: :object,
               properties: {
                 message: { type: :string, description: 'Status message after deletion',
                            example: 'Link successfully deleted.' }
               }

        let(:id) { Link.create(url: 'https://thisisthelongesturlever.co.uk').mutation_key }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end

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
