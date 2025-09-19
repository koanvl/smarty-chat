Rails.application.config.after_initialize do
  if Rails.env.development?
    webhook_url = ENV['N8N_WEBHOOK_URL']
    if webhook_url.blank?
      Rails.logger.error "WARNING: N8N_WEBHOOK_URL is not set!"
    else
      Rails.logger.info "N8N_WEBHOOK_URL is set to: #{webhook_url}"
    end
  end
end
