class SchoologyRealm < ActiveRecord::Base
  class <<self
    def allowed?(realm_type, schoology_id)
      self.find_by_realm_type_and_schoology_id(realm_type, schoology_id) != nil
    end

    def all_courses_and_groups()
      self.where(realm_type: ['group', 'course', 'section'])
    end
  end
end
