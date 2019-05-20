# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    rescue_from StandardError, with: :render_unexpected_error
    rescue_from Errors::NotFoundError, with: :render_not_found
    rescue_from Errors::ValidationError, with: :render_unprocessable_entity
    rescue_from Errors::BadRequestError, with: :render_bad_request

    private

    def render_unexpected_error(_error)
      error_message = { error: 'UnexpectedError', message: 'Unexpected server error' }
      render(status: :error, json: error_message)
    end

    def render_not_found(error)
      error_message = { error: error.class.name.demodulize, message: error.message }
      render(status: :not_found, json: error_message)
    end

    def render_unprocessable_entity(error)
      error_message = { error: error.class.name.demodulize, message: error.message }
      render(status: :unprocessable_entity, json: error_message)
    end

    def render_bad_request
      error_message = { error: 'BadRequestError', message: 'Invalid request syntax' }
      render(status: :bad_request, json: error_message)
    end
  end
end
