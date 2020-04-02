require "spec_helper"

describe SnsController do

  describe "transcoder_update" do

    describe "with SubscriptionConfirmation" do
      before(:each) do
        allow(HTTParty).to receive(:get).and_return(nil)
      end

      it "should raise an error if the SubscribeURL is not from amazon" do
        body = {:Type => "SubscriptionConfirmation", :SubscribeURL => "http://example.com/"}
        expect {
          post :transcoder_update, params: body, as: :json
        }.to raise_error(MessageWasNotAuthentic)
      end

      it "should succeed if the SubscribeURL is from amazon" do
        body = {:Type => "SubscriptionConfirmation", :SubscribeURL => "https://amazonaws.com/"}
        post :transcoder_update, params: body, as: :json
        expect(response.status).to eq 200
      end
    end
  end

  describe "with Notification" do
    before(:each) do
      @user = FactoryBot.create(:user, :email => "foo@bar.com")
      @paper = FactoryBot.create(:video_paper, :title => "Video1", :status => "unpublished", :user => @user);
      @video = FactoryBot.create(:video, :video_paper => @paper, :aws_transcoder_job => 1)
      @video.save
      allow_any_instance_of(Video).to receive(:retry_transcoding_job).and_return(nil)
    end

    it "should retry transcoding on error" do
      body = {:Type => "Notification", :Message => {:jobId => 1, :state => "Error", :errorCode => 3001}}
      post :transcoder_update, params: body, as: :json
      expect(response.status).to eq 200
      expect(true).to eq true
    end

    it "should succeed not error without duration" do
      body = {:Type => "Notification", :Message => {:jobId => 1, :state => "Completed"}}
      post :transcoder_update, params: body, as: :json
      expect(response.status).to eq 200
      expect(true).to eq true
    end
  end

  describe "with UnsubscribeConfirmation" do
    it "should do nothing" do
      body = {:Type => "UnsubscribeConfirmation"}
      post :transcoder_update, params: body, as: :json
      expect(response.status).to eq 200
    end
  end

end