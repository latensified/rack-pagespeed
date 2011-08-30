# We will cache all images for a long time. This means that Cache-Control is set to public with max-age set
# to a year by default. This can be configured.
# We strip out Etag in favor of Last-Modified. We remove Vary to allow IE to cache images.
#
# If the use_etags parameter is set, the value will be set. If not, any ETag header will be stripped out.

class Rack::PageSpeed::Filters::CacheImages < Rack::PageSpeed::HeaderFilter
  name 'cache_images'
  priority 1

  def execute! headers
    @options[:duration] ||= 1
    headers['Cache-Control'] ="max-age=#{duration_in_seconds}, public"
    headers.delete 'Etag'
    headers.delete 'Vary'
  end

  private
  def duration_in_seconds
    60 * 60 * 24 * 30 * @options[:duration]
  end
end