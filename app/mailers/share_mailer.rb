class ShareMailer < ActionMailer::Base
  default :from => 'videopaperbuilder@gmail.com'
  
  def share_email(user,shared_paper,sender,note)
    @user = user
    @shared_paper = shared_paper
    @sender = sender
    @note = note
    mail(:to => user.email, :subject => "[VideoPaper Builder] #{sender.name} has shared a VideoPaper with you")
    # body :user=>user, :shared_paper=>shared_paper, :sender=>sender, :note=>note
  end
end
