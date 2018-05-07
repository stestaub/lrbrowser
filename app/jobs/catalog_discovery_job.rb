class CatalogDiscoveryJob < ApplicationJob

  include CatalogFinder

  def perform(bucket)
    catalogs = all_catalogs(bucket, Aws::S3::Client.new)
    update_catalog_index(bucket, catalogs)
  end

  # Takes a list of catalog keys for a given bucket and
  # updates the database records so that:
  #
  # * Catalog References in the db that not exist in current_catalog will be marked as deleted:
  # * Catalog Referneces in the db that still exist will have updated last_seen
  # * Catalog References not yet in the db will be added.
  #
  def update_catalog_index(bucket, current_catalogs)
    previously_scanned = CatalogReference.where(bucket: bucket)
    removed = previously_scanned.where.not(key: current_catalogs)

    removed.mark_as_removed

    current_catalogs.each do |cat|
      # Setup the catalog as Database record to keep track on it
      CatalogReference.create_or_update key: cat do |record|
        record.discovered_at ||= DateTime.now
        record.last_seen ||= DateTime.now
      end
    end
  end


end