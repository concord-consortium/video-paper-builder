require 'uri'

class Video < ActiveRecord::Base
    attr_accessible :private, :thumbnail, :thumbnail_time, :entry_id, :upload_uri, :transcoded_uri, :aws_transcoder_job

    before_save :parse_upload_uri

    # Constants
    COMPLEX_SECONDS_PATTERN = /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/
    SIMPLE_SECONDS_PATTERN = /(^-?\d\d*$)/

    ###################################
    # AR Plugins/gems
    ###################################
    #paperclip
    has_attached_file :thumbnail, :styles=>{:thumb=>"120x120>"}


    ###################################
    # Associations
    ###################################
    belongs_to :video_paper

    ###################################
    # Validations
    ###################################
    #validates_presence_of :description
    validates_presence_of :upload_uri, :message=>"You need to upload a video."
    validates_inclusion_of :private, :in=>[true,false]
    validates_uniqueness_of :video_paper_id
    #validates_length_of :description, :maximum=>500
    validates_format_of :thumbnail_time, :with=>SIMPLE_SECONDS_PATTERN,:allow_nil=>true,:allow_blank=>true

    ##################################
    # instance methods
    ##################################

    # Public Methods
    def processed?
      return self.processed
    end

    def transcoded?
      return (self.transcoded_uri != nil) && ((self.aws_transcoder_state == 'completed') || (self.aws_transcoder_state == 'warning'))
    end

    def public?
      !private?
    end

    def thumbnail_time=(time)
      unless time.nil? || time.blank?
        if time.to_s.match(COMPLEX_SECONDS_PATTERN)
          seconds = time

          parsed_seconds_array = seconds.split(":")
          time = (parsed_seconds_array.at(0).to_i * 3600) + (parsed_seconds_array.at(1).to_i * 60) + parsed_seconds_array.at(2).to_i
        end
      end
      write_attribute(:thumbnail_time, time)
    end

    def upload_filename
      if !self.upload_uri.nil? && !self.upload_uri.empty?
        self.upload_uri.split('/')[-1]
      else
        nil
      end
    end

    def generate_signed_url
      if self.transcoded?
        signed_url self.transcoded_uri
      else
        nil
      end
    end

    def generate_signed_thumbnail_url
      if self.transcoded?
        signed_url "#{self.transcoded_uri}-00001.png"
      else
        nil
      end
    end

    def generate_thumbnail_url
      if self.thumbnail?
        self.thumbnail.url(:thumb)
      elsif self.transcoded?
        signed_url "#{self.transcoded_uri}-00001.png"
      else
        nil
      end
    end

    # Protected Methods

    def signed_url(url)
      s3 = AWS::S3.new
      bucket = s3.buckets[VPB::Application.config.aws["s3"]["bucket"]]
      obj = bucket ? bucket.objects[url] : nil
      obj ? obj.url_for(:read).to_s : nil #, :response_content_type => 'video/mp4') # also think about setting endpoint to hostname
    end

    def parse_upload_uri
      # the upload uri is set to the full url by s3_uploader - this removes the domain and bucket
      prefix = S3DirectUpload.config.url
      if self.upload_uri[0 ... prefix.length] == prefix
        self.upload_uri = URI.decode(self.upload_uri[prefix.length .. -1])
      end
    end

end
