# Image-caching filter for rack-pagespeed.
# Cache-Control is set to public with max-age set to a month by default. This value can
# be passed in as an option.
# Strip out Etag in favor of Last-Modified.
# Remove Vary to allow IE to cache images.
#
# Usage -- Add this to your pagespeed configuration:
# cache_images :duration => 12


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