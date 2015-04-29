require 'tolerances/tolerance'
require 'tolerances/quantiles'
require 'tolerances/simple_stats'

class Tolerances

  VERSION = '1.0.0'

  attr_reader :tolerances, :tags

  def initialize( contents )
    @contents = contents
    @tolerances = []
    @template = ''
    @tags = Hash.new{ |h,k| h[k]=[] }
    find_tolerances
    create_template
    collect_tags
  end

  class << self
    alias parse new
  end

  def values_at( samples )
    if samples.size != tags.size
      raise "samples (#{samples.size}) != tags (#{@tags.size})"
    end
    values = []
    @tolerances.each_with_index do |tol,i|
      values << tol.value_at( samples[tol.sample_index] )
    end
    values
  end

  def result( values )
    @template % values
  end

  private

  def create_template
    @template = @contents.gsub(Tolerance::REGEX) do
      $5 ? "%#$5" : '%s'
    end
  end

  def find_tolerances
    @tolerances = [Tolerance.parse(@contents)].flatten.compact
  end

  def collect_tags
    sample_index = -1
    @tolerances.each do |tolerance|
      sample_index +=1 unless tags.keys.include? tolerance.tag
      tolerance.sample_index = sample_index
      tags[tolerance.tag] << tolerance
    end
    self
  end

end
