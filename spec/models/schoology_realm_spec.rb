require 'spec_helper'

describe SchoologyRealm do
  it "should not allow two realms with identicatl information to be created" do
    realm1 = FactoryGirl.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    realm1.should be_valid
    realm1.save.should be_true
    realm2 = FactoryGirl.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    expect { realm2.save }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should allow all realms in the database" do
    realm = FactoryGirl.build(:schoology_realm, :realm_type => 'group', :schoology_id => 1)
    realm.save
    SchoologyRealm.allowed?('group', 1).should be_true
  end

  it "should disallow all realms not in the database" do
    SchoologyRealm.allowed?('group', 1).should be_false
  end
end
