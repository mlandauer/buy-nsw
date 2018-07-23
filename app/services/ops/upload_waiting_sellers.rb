require 'csv'

class Ops::UploadWaitingSellers < ApplicationService
  attr_reader :waiting_sellers, :file_contents

  def initialize(file: nil, file_contents: nil, persist: false)
    @file = file
    @file_contents = file_contents
    @persist = persist

    @waiting_sellers = []
    @persisted = false
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        validate_file
        set_file_contents
        parse_from_csv
        build_seller_objects
        validate_rows
        persist_rows
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

  def persisted?
    @persisted == true
  end

  def persist?
    @persist.present?
  end

private
  attr_reader :file, :csv

  def validate_file
    raise Failure unless file.present? || file_contents.present?
  end

  def set_file_contents
    if file_contents.present?
      @file_contents = Base64.decode64(file_contents)
    else
      @file_contents = File.read(file.path)
    end
  end

  def parse_from_csv
    begin
      @csv = CSV.parse(file_contents, headers: true)
    rescue CSV::MalformedCSVError
      raise Failure
    end
  end

  def build_seller_objects
    @waiting_sellers = csv.map {|row|
      WaitingSeller.new(prepare_fields(row))
    }
  end

  def validate_rows
    raise Failure unless waiting_sellers.any?
  end

  def persist_rows
    if persist?
      waiting_sellers.each(&:save!)
      @persisted = true
    end
  end

  def prepare_fields(row)
    row.to_hash.slice(*fields).tap {|atts|
      atts['state'].downcase! if atts['state'].present?
    }
  end

  def fields
    ['name', 'abn', 'address', 'suburb', 'postcode', 'state', 'country',
      'contact_name', 'contact_email', 'contact_position', 'website_url']
  end

end
