VIDEO_PAPER_ID = 1
INVITE_CSV_PATH = '/vpb/tmp/invite_list.csv'

desc 'Example of the bulk invite'
task :invite_example => ['environment'] do
  paper = VideoPaper.find(VIDEO_PAPER_ID)
  require 'invite_csv'
  InviteCSV.invite_list(INVITE_CSV_PATH, paper)
end