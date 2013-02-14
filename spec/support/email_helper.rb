module EmailHelper
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def clear_email_queue
    ActionMailer::Base.deliveries = []
  end
end
