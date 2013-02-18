require 'csv'

module InviteCSV
  # expects a csv file with no headers:
  #   first_name, last_name, email
  def self.invite_list(file_name, paper)
    CSV.foreach(file_name) { |row|
      puts "first_name: #{row[0]} last_name: #{row[1]} email: #{row[2]}"
      invite_user({:first_name => row[0], :last_name => row[1], :email => row[2] }, paper)
      # our AWS account is only supposed to send a max of 5 emails a second so sleep a bit here
      # we'll try to stay well under the rate one email every 0.2 seconds:
      sleep(0.4)
    }
  end
  
  # {:email => 'blah', :first_name => 'blah', :last_name => 'blah'}
  def self.invite_user(attribs, paper)
    u = User.invite!(attribs)
    if u.errors.empty?
      paper.users << u if paper
    else
      puts "problem with #{u}"
    end
  end
end

