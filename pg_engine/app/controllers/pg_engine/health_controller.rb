module PgEngine
  class HealthController < ApplicationController
    rescue_from(Exception) do |error|
      pg_err error
      render_down
    end

    def show
      check_redis
      check_postgres
      render_up
    end

    private

    def check_postgres
      return if User.count.is_a? Integer

      raise PgEngine::Error, 'postgres is down'
    end

    def check_redis
      return if Kredis.counter('healthcheck').increment.is_a? Integer

      raise PgEngine::Error, 'redis is down'
    end

    def render_up
      render html: html_status(color: '#005500')
    end

    def render_down
      render html: html_status(color: '#990000'), status: :internal_server_error
    end

    def html_status(color:)
      # rubocop:disable Rails/OutputSafety
      %(<!DOCTYPE html><html><body style="background-color: #{color}"></body></html>).html_safe
      # rubocop:enable Rails/OutputSafety
    end
  end
end
