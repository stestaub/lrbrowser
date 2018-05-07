require 'rails_helper'
require 'benchmark/memory'

describe 'catalog_finder' do

  include CatalogFinder

  let(:bucket) { 'stestaub-backups' }
  let(:s3) { Aws::S3::Client.new }

  describe 'all_catalogs' do
    subject { all_catalogs bucket, s3 }

    it 'should list all items' do
      puts subject.first(100)
    end
  end

  describe 'aws client experiments' do
    let(:service) { Aws::S3::Client.new }
    it 'should return list of elements' do

      Benchmark.time do |x|
        x.report('Max keys: 50') { all_catalogs(bucket, s3, max_keys:50).first(50) }
        x.report('Max keys: 100') { all_catalogs(bucket, s3, max_keys:1000).first(50) }
        x.compare!
      end
    end

  end


end