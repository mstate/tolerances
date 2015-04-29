require 'test/unit'
require 'simple_stats'

# FIXME: no monkey patching please
class Array # mixin statistics
  include SimpleStats
end

class TestArrayStatistics < Test::Unit::TestCase

  def test_median
    assert_equal(0, [0].median)
    assert_equal(1, [1].median)
    assert_equal(0.5, [0,1].median)
    assert_equal(0.5, [0,1.0].median)
    assert_equal(1, [0,2].median)
    assert_equal(1, [0,1,2].median)
  end

  def test_mean
    assert_equal(0, [0].mean)
    assert_equal(0.5, [0,1].mean)
    assert_equal(0.5, [0,1.0].mean)
    assert_equal(0.5, [0.0,0.25,0.50,0.75,1.0].mean)
  end

  def test_variance
    assert_equal(0, [0].variance)
    assert_equal((0.25+0.25)/2, [0,1].variance)
  end

  def test_standard_deviation
    assert_equal(0, [0].standard_deviation)
    assert_equal(Math::sqrt((0.25+0.25)/2), [0,1].standard_deviation)
  end

  def test_coefficient_of_variation
    assert_equal(0, [0].coefficient_of_variation)
    assert_equal(Math.sqrt(0.25)/0.5, [0,1].coefficient_of_variation)
  end

  def test_skewness
    assert_equal(0, [0].skewness)
    assert_equal(0, [0,2].skewness)
  end

  def test_kurtosis
    assert_equal(0, [0].kurtosis)
    assert_equal(1, [0,2].kurtosis)
  end

  def test_histogram
    histo = [-3,-1,0,0,4,3,2].histogram(7)
    assert_equal( 7, histo.size )
    assert_equal( 2, histo[2].last)
  end

  def test_percentile
    samples = (1..10).to_a
    assert_equal(  1, samples.percentile(0)    )
    assert_equal(  1, samples.percentile(2.5)  )
    assert_equal(  1, samples.percentile(10)   )
    assert_equal(  2, samples.percentile(20)   )
    assert_equal(  5, samples.percentile(50)   )
    assert_equal(  8, samples.percentile(80)   )
    assert_equal( 10, samples.percentile(97.5) )
    assert_equal( 10, samples.percentile(100)  )
    samples = [ 2, 3, 1, 4, 5 ]
    assert_equal( 3, samples.percentile(50) )
  end

  def test_within?
    samples = [ 3, 2, 1, 1, 1 ]
    assert( samples.last(3).within?(0) )
    assert( samples.last(4).within?(1) )
    assert( samples.within?(2) )
    assert( !samples.within?(1) )
  end

  def test_within_percent
    samples = [ 3, 2, 1, 1, 1 ]
    assert( samples.last(3).within?(0,:percent=>true) )
    assert( samples.last(4).within?(100,:percent=>true) )
    assert( samples.within?(200,:percent=>true) )
    assert( !samples.within?(100,:percent=>true) )
    samples = [ 2, 1, 0, 0, 0 ]
    assert( samples.last(3).within?(0, :percent=>true) )
  end

end
