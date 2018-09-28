class NewProblemMailer < ApplicationMailer
  default to: -> { ENV['ZEN_DESK_EMAIL_ADDRESS'] },
          from: -> { ENV['ZEN_DESK_EMAIL_ADDRESS'] }

  def report_email
    @user_email = params[:user].try(:email)
    @task = params[:task]
    @issue = params[:issue]
    @url = params[:url]
    @browser = params[:browser]

    subject = "buy.nsw: A new problem was reported"
    subject = Rails.env.upcase + " | " + subject unless Rails.env.production?
    mail(subject: subject, reply_to: @user_email)
  end
end
