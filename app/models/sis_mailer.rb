class SisMailer < ActionMailer::Base
  require "smtp_tls"
  
   def sendmail
     @subject = 'i love ruby on rails'  
     @recipients = 'tang-jilong@163.com' #接收者email地址  
     @from = 'tang.jilong@gmail.com' #发送者email地址  
#     sent_on Time.now 
     puts "sent already!!"
#     headers "Organization" => "Pragmatic Programmers, LLC"
#     body :greeting => "WAUW"
   end  
  
  
end
