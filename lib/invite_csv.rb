require 'csv'

module InviteCSV
  # expects a csv file with no headers
  # and the first colum is a name 
  # and second column is email
  # If the name has 3 parts the first 2 will be joined
  def self.invite_list(file_name, paper)
    CSV.foreach(file_name) { |row|
      name = row[0].split(' ')
      if name.size == 3
        name[0] = name[0] + " " + name[1]
        name[1] = name[2]
      end
      invite_user({:first_name => name[0], :last_name => name[1], :email => row[1] }, nil)
    }
  end
  
  # {:email => 'blah', :first_name => 'blah', :last_name => 'blah'}
  def self.invite_user(attribs, paper)
    u = User.send_invitation(attribs)
    if u.errors.empty?
      paper << u if paper
    else
      puts "problem with #{u}"
    end
  end
end

