class MailerHelperMailer < ApplicationMailer
    def send_invite(user,invitedMail)
        @user = user
        @url  = "https://enviosya-aguspazos.c9users.io/users/new?existingUser=#{user.id}"
        
        mail(to: invitedMail, subject: 'Bienvenido a EnviosYa')
    end
end
