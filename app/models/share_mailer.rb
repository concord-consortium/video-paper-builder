class ShareMailer < ActionMailer::Base
  
  def share_email(user,shared_paper,sender,note)
    recipients user.email
    from 'videopaperbuilder@gmail.com'
    subject "[VideoPaper Builder] #{sender.name} has shared a VideoPaper with you"
    sent_on Time.now.utc
    body :user=>user, :shared_paper=>shared_paper, :sender=>sender, :note=>note
  end
end
