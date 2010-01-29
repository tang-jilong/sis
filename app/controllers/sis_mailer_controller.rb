class SisMailerController < ApplicationController
  
  def sendemail
    SisMailer.deliver_sendmail 
    redirect_to_index
  end
  
end
