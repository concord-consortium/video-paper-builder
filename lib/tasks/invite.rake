task :invite_cohort_3 => ['environment'] do
  paper = VideoPaper.find(58)
  InviteCSV.invite_list('/web/portal/shared/ITSISU_cohort3_VPB_invite_list.csv', paper)
end