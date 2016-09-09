# Be sure to restart your server when you modify this file.

Rails.application.config.action_dispatch.cookies_serializer = :json
Rails.application.config.session_store :active_record_store, :key => '_my_app_session'