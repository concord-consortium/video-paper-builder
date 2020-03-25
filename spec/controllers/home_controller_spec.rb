require "spec_helper"

describe HomeController do

  describe "with no logged in user" do

    it "should support index without schoology oauth" do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template(:index)
    end

    describe "with schoology oauth" do
      before(:each) do
        ENV["SCHOOLOGY_CONSUMER_KEY"] = "foo"
        ENV["SCHOOLOGY_CONSUMER_SECRET"] = "bar"
      end
      after(:each) do
        ENV.delete("SCHOOLOGY_CONSUMER_KEY")
        ENV.delete("SCHOOLOGY_CONSUMER_SECRET")
      end

      it "should set the schoology_host session var if referer isn't concord.org" do
        expect(session[:schoology_host]).to be_nil
        request.env["HTTP_REFERER"] = "http://example.com"
        get :index, {:realm => "group", :realm_id => 1}
        expect(session[:schoology_host]).to eq "example.com"
        expect(response.status).to eq 200
        expect(response).to render_template("_unauthorized_schoology_realm")
      end

      it "should redirect to unauthorized template if unauthorized" do
        get :index, {:realm => "group", :realm_id => 1}
        expect(response.status).to eq 200
        expect(response).to render_template("_unauthorized_schoology_realm")
      end

      it "should redirect to schoology auth if authorized" do
        realm = FactoryBot.build(:schoology_realm)
        realm.save
        get :index, {:realm => realm.realm_type, :realm_id => realm.schoology_id}
        expect(response.status).to eq 302
        expect(response).to redirect_to("/users/auth/schoology")
        realm.delete
      end
    end
  end

  describe "with logged in user" do
    before(:each) do
      user = FactoryBot.create(:user, :email => "foo@bar.com")
      sign_in user
    end

    it "should support index without schoology oauth" do
      get :index
      expect(response.status).to eq 302
      expect(response).to redirect_to new_video_paper_path()
    end

    describe "with schoology oauth" do
      before(:each) do
        ENV["SCHOOLOGY_CONSUMER_KEY"] = "foo"
        ENV["SCHOOLOGY_CONSUMER_SECRET"] = "bar"
      end
      after(:each) do
        ENV.delete("SCHOOLOGY_CONSUMER_KEY")
        ENV.delete("SCHOOLOGY_CONSUMER_SECRET")
      end

      it "should redirect to unauthorized template if unauthorized" do
        get :index, {:realm => "group", :realm_id => 1}
        expect(response.status).to eq 200
        expect(response).to render_template("_unauthorized_schoology_realm")
      end

      it "should redirect to schoology auth if authorized and user isn't authed by schoology" do
        realm = FactoryBot.build(:schoology_realm)
        realm.save
        get :index, {:realm => realm.realm_type, :realm_id => realm.schoology_id}
        expect(response.status).to eq 302
        expect(response).to redirect_to("/users/auth/schoology")
        realm.delete
      end

      it "should bypass schoology auth if already schoology authed" do
        realm = FactoryBot.build(:schoology_realm)
        realm.save
        user = FactoryBot.create(:user, :email => "baz@bar.com", :provider => "schoology", :uid => realm.schoology_id)
        user.save
        sign_in user
        get :index, {:realm => realm.realm_type, :realm_id => realm.schoology_id}
        expect(response.status).to eq 302
        expect(response).to redirect_to new_video_paper_path()
        realm.delete
        user.delete
      end

    end
  end

  it "should support test_exception" do
    expect { get :test_exception }.to raise_error("This is a test. This is only a test.")
  end

  it "should support about" do
    get :about
    expect(response.status).to eq 200
    expect(response).to render_template(:about)
  end

  it "should support contact" do
    get :contact
    expect(response.status).to eq 200
    expect(response).to render_template(:contact)
  end

  it "should support help_videos" do
    get :help_videos, {:video_name => "images"}
    expect(response.status).to eq 200
    expect(response).to render_template("help_videos/images")
  end

  it "should support help_videos and ensure against hacking" do
    get :help_videos, {:video_name => "im/ag/es"}
    expect(response.status).to eq 200
    expect(response).to render_template("help_videos/images")
  end

  it "should support preflight" do
    expect(session['preflighted']).to be_nil
    get :preflight
    expect(response.status).to eq 200
    expect(session['preflighted']).to eq "1"
    session['preflighted'] = nil
  end
end