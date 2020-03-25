require 'spec_helper'

describe SchoologyRealm do
  it "should not allow two realms with identical information to be created" do
    realm1 = FactoryBot.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    expect(realm1).to be_valid
    expect(realm1.save).to be_truthy
    realm2 = FactoryBot.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    expect { realm2.save }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should allow all realms in the database" do
    realm = FactoryBot.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    realm.save
    expect(SchoologyRealm.allowed?('group', 1)).to be_truthy
  end

  it "should disallow all realms not in the database" do
    expect(SchoologyRealm.allowed?('group', 1)).to be_falsey
  end

  it "should return all courses and groups" do
    realm1 = FactoryBot.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    expect(realm1).to be_valid
    expect(realm1.save).to be_truthy

    realm2 = FactoryBot.build(:schoology_realm, :realm_type => 'course', :schoology_id => 1)
    expect(realm2).to be_valid
    expect(realm2.save).to be_truthy

    realm3 = FactoryBot.build(:schoology_realm, :realm_type => 'section', :schoology_id => 1)
    expect(realm3).to be_valid
    expect(realm3.save).to be_truthy

    expect(SchoologyRealm.all_courses_and_groups()).to eq [realm1, realm2, realm3]
  end

end
