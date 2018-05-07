module CatalogFinder

  # Returns a Lazy enumerator
  # @param [String] bucket_name
  # @param [Aws::S3::Client] aws_client
  # @return [Enumerator::Lazy]
  def all_catalogs(bucket_name, aws_client, options = {})
    response = aws_client.list_objects ( {bucket: bucket_name, max_keys: 500} ).merge(options)
    response.lazy.collect_concat { |r| r.contents.select { |o| o.key[-6..-1] == '.lrcat' }.map(&:key).lazy }
  end

end