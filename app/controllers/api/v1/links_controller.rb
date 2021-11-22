# frozen_string_literal: true

module Api
  module V1
    # API access to create, edit and delete links
    class LinksController < ApplicationController
      # POST /links
      def create
        @link = Link.new(link_creation_params)
        if @link.save
          render json: link_json(@link, 'Link successfully created.')
        else
          render error: { error: 'Unable to create User.' }, status: :bad_request
        end
      end

      # PUT /users/:id
      def update
        @link = find_link
        if @link
          @link.update(link_mutation_params)
          render json: link_json(@link, 'Link successfully updated.'), status: :accepted
        else
          render json: { error: 'Unable to update link. ' }, status: :bad_request
        end
      end

      # DELETE /users/:id
      def destroy
        @link = find_link
        if @link
          @link.destroy
          render json: { message: 'Link successfully deleted.', url: @link.url }, status: :ok
        else
          render json: { error: 'Unable to delete link.', url: @link.url }, status: :bad_request
        end
      end

      private

      def link_creation_params
        params.permit(:url, :slug)
      end

      def link_mutation_params
        params.permit(:slug)
      end

      def link_json(link, message)
        link.as_json(only: %i[url], methods: %i[mutation_key shorty editable]).merge({ message: message })
      end
    end
  end
end
