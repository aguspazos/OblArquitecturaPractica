module ShipmentsHelper
    def set_receiver
        receiver = User.where(email: @shipment.receiver_email).take
        if(receiver.blank?)
            MailerHelperMailer.send_invite(current_user,@shipment.receiver_email).deliver!
        else
            @shipment.receiver_id = receiver.id
        end
    end
end
