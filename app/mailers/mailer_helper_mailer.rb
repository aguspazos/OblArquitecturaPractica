class MailerHelperMailer < ApplicationMailer
    def send_invite(user,invitedMail)
        @user = user
        @url  = "https://enviosya-aguspazos.c9users.io/users/new?existingUser=#{user.id}"
        
        mail(to: invitedMail, subject: 'Bienvenido a EnviosYa')
        puts invitedMail
    end
    def send_estimated_price(shipment)
        @shipment = shipment
        mail(to: @shipment.sender.email, subject: 'Pago en enviosYa')
    end
    def send_price(shipment)
        @shipment = shipment
        mail(to: @shipment.sender.email, subject: 'Pago en enviosYa')
    end
end

