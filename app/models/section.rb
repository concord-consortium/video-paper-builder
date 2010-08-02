class Section < ActiveRecord::Base
  belongs_to :video_paper, :foreign_key=> "video_paper_id"
end
