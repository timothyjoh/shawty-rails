# frozen_string_literal: true

module Api
  module V1
    # API access to create, edit and delete links
    class LinksController < ApplicationController
      # POST /links
      def create
        @link = Link.new(link_creation_params)
        if @link.save
          render json: @link.as_json(only: %i[url], methods: %i[mutation_key shorty])
        else
          render error: { error: 'Unable to create User.' }, status: :bad_request
        end
      end

      # PUT /users/:id
      def update
        @link = Link.find_by(mutation_key: params[:mutation_key])
        if @link
          @link.update(link_mutation_params)
          render json: { message: 'Link successfully updated. ' }, status: :ok
        else
          render json: { error: 'Unable to update link. ' }, status: :bad_request
        end
      end

      # DELETE /users/:id
      def destroy
        @link = Link.find_by(mutation_key: params[:mutation_key])
        if @link
          @link.destroy
          render json: { message: 'Link successfully deleted. ' }, status: :ok
        else
          render json: { error: 'Unable to delete User. ' }, status: :bad_request
        end
      end

      private

      def link_creation_params
        params.permit(:url, :slug)
      end

      def link_mutation_params
        params.permit(:mutation_key, :slug)
      end
    end
  end
end
