class S3Bucket
  include ActiveModel::Model

  attr_accessor :name, :created_at

  def objects(path = '', marker)
    response = S3Bucket.s3.list_objects(bucket: name, delimiter: '/', prefix: path)
    result = []
    response.each do |r|
      r.contents.map(&:key)
    end
  end

  def self.all
    resp = s3.list_buckets
    resp.buckets.map do |b|
      S3Bucket.new name: b.name, created_at: b.creation_date
    end
  end

  def self.s3
    @client ||= Aws::S3::Client.new
  end

end