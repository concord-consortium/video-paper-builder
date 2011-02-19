AfterStep('@pause') do |senario, step|
  print "Press Return to continue"
  STDIN.getc
end