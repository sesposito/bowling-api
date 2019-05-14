# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    rescue_from StandardError, with: :render_unexpected_error unless Rails.env.development?
    rescue_from Errors::NotFoundError, with: :render_not_found
    rescue_from Errors::ValidationError, with: :render_unprocessable_entity

    private

    def render_not_found(error)
      error_message = { error: error.class.name.demodulize, message: error.message }
      render(status: :not_found, json: error_message)
    end

    def render_unprocessable_entity(error)
      error_message = { error: error.class.name.demodulize, message: error.message }
      render(status: :unprocessable_entity, json: error_message)
    end

    def render_unexpected_error
      error_message = { error: 'UnexpectedError', message: 'Unexpected server error' }
      render(status: :error, json: error_message)
    end
  end
end
