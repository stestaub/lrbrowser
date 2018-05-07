class S3ObjectsController < ApplicationController

  def index
    marker = params[:marker] || ''
    path = params[:path] || ''

    options = {}
    options[:bucket] = 'stestaub-backups'
    options[:max_keys] = 500
    options[:delimiter] = '/'
    options[:prefix] = params[:path] || ''
    options[:marker] = params[:marker]

    @page = S3Bucket.s3.list_objects(options)

  end


end