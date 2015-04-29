require 'scanf'
require 'quantiles'

class Tolerance

  DEFAULTS = { :type=>:raw, :quantile=>nil, :format=>nil, :tag=>nil }

  FLOAT = /[-+]*(?=\d|\.\d)\d*(?:\.\d*)?(?:[eE][-+]\d+)*/

  REGEX = /(#{FLOAT})            # $1 : number
           \s*\+\/-\s*
           (#{FLOAT})            # $2 : tolerance
           (%|o)?                # $3 : type of tolerance (optional)
           (U|N|I|T)?            # $4 : quantile sampling function (optional)
           (?:_(\d?[.]?\d*[#{Scanf::FormatString::SPECIFIERS}]))?
                                 # $5 : format specifier (optional)
           (?:\s*(["'])(.*?)\6)? # $7 : tag (funky stuff is "-matching)
          /x

  @@untagged = 0

  attr_reader :center, :halfwidth
  attr_reader :type, :quantile, :format, :tag
  attr_accessor :sample_index

  def initialize( center, halfwidth, options={} ) 
    @center, @halfwidth = center.to_f, halfwidth.to_f
    set_options DEFAULTS.merge(options)
  end

  def self.parse(string)
    tolerances = []
    string.scan(REGEX).each do |ctr, width, type, quantile, format, _, tag|
      tolerances <<
        Tolerance.new( ctr, width, :type   => type, :quantile => quantile,
                                   :format => format,    :tag => tag )
    end
    case tolerances.size
    when 0 then nil
    when 1 then tolerances[0]
    else    tolerances
    end
  end

  def value_at( halfwidth_fraction )
    case type
    when :raw then
      @center + halfwidth_fraction*@halfwidth
    when :percent then
      @center + halfwidth_fraction*@center*(@halfwidth/100)
    when :order then
      if @center < 0 then
        -10**( log10(-@center) + halfwidth_fraction*@halfwidth )
      elsif @center > 0 then
         10**( log10( @center) + halfwidth_fraction*@halfwidth )
      else # necessary for Ruby < 1.8.6
         0
      end
    end
  end

  def self.untagged=(index)
    @@untagged = index
  end

  private

  def set_options(options)
    @type = set_type options[:type]
    @quantile = set_quantile options[:quantile]
    @format = options[:format]
    @tag = options[:tag] || "untagged_#{@@untagged+=1}"
  end

  def set_type( type )
    case type
    when 'o' then :order
    when '%' then :percent 
    when nil then DEFAULTS[:type]
    when :raw,:order,:percent then type
    else
      raise "unknown tolerance type: >>#{type}<<"
    end
  end

  def set_quantile( quantile )
    case quantile
    when 'U' then :uniform
    when 'N' then :normal
    when 'I' then :interval
    when 'T' then :triangular
    when nil then DEFAULTS[:quantile]
    when :uniform,:normal,:interval,:triangular then quantile
    else
      raise "unknown tolerance quantile: >>#{quantile}<<"
    end
  end

end
