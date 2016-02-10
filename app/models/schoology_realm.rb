class SchoologyRealm < ActiveRecord::Base
  attr_accessible :schoology_id, :realm_type

  class <<self
    def allowed?(realm_type, schoology_id)
      self.find_by_realm_type_and_schoology_id(realm_type, schoology_id) != nil
    end

    def all_courses_and_groups()
      self.find_all_by_realm_type(['group', 'course', 'section'])
    end
  end
end
