class ShareMailer < ActionMailer::Base
  
  def share_email(user,shared_paper,sender,note)
    recipients user.email
    from 'videopaperbuilder@gmail.com'
    subject "[Video Paper Builder] #{sender.name} has shared a Video Paper with you"
    sent_on Time.now.utc
    body :user=>user, :shared_paper=>shared_paper, :sender=>sender, :note=>note
  end
end
