class Rack::PageSpeed::Config
  class NoSuchFilterError < RuntimeError; end

  attr_reader :filters, :options

  def initialize options = {}, &block
    @filters, @options, @public = [], options, options[:public]
    raise ArgumentError, ":public needs to be a directory" unless File.directory? @public.to_s
    filters_to_methods
    enable_filters_from_options
    instance_eval &block if block_given?
  end

  def method_missing filter
    raise NoSuchFilterError, "No such filter \"#{filter}\". Available filters: #{(Rack::PageSpeed::Filters::Base.available_filters).join(', ')}"
  end

  private
  def enable_filters_from_options
    return nil unless @options[:filters]
    case @options[:filters]
      when Array  then @options[:filters].map { |filter| self.send filter }
      when Hash   then @options[:filters].each { |filter, options| self.send filter, options }
    end
  end

  def filters_to_methods
    Rack::PageSpeed::Filters::Base.available_filters.each do |klass|
      (class << self; self; end).send :define_method, klass.name do |*options|
        @filters << klass.new(options.any? ? @options.merge(*options) : @options)
      end
    end
  end
end