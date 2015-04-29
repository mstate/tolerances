require 'test/unit'
require 'simple_stats'
require 'quantiles'

class Array # mixin statistical functions
  include SimpleStats
end

class TestQuantiles < Test::Unit::TestCase

  include Quantiles

  def setup
    srand 1234
  end

# Normal quantile

  def test_normal_quantile_domain_checking
    assert_nothing_thrown{normal(Float::EPSILON)}
    assert_raises(RuntimeError){normal(0)}
    assert_raises(RuntimeError){normal(1)}
    assert_nothing_thrown{normal(1-Float::EPSILON)}
  end
  def test_normal_quantile_at_specific_values
    assert_in_delta( -4.264890795, normal(0.00001), 1e-9 )
    assert_in_delta( -0.674489750, normal(0.25000), 1e-9 )
    assert_in_delta(  0.0,         normal(0.50000), 1e-9 )
    assert_in_delta(  0.674489750, normal(0.75000), 1e-9 )
    assert_in_delta(  4.264890795, normal(0.99999), 1e-9 )
  end
  def test_normal_quantile_nominal_statistics
    samples = []
    1000.times{ samples << normal(rand) }
    assert_in_delta( 0.0, samples.mean,               0.05, "mean" )
    assert_in_delta( 0.0, samples.median,             0.10, "median" )
    assert_in_delta( 1.0, samples.standard_deviation, 0.05, "sigma" )
    assert_in_delta( 0.0, samples.skewness,           0.10, "skewness" )
    assert_in_delta( 3.0, samples.kurtosis,           0.10, "kurtosis" )
  end
  def test_normal_quantile_specified_sigma_statistics
    samples = []
    1000.times{ samples << 0.2*normal(rand) }
    assert_in_delta( 0.0, samples.mean,               0.05, "mean" )
    assert_in_delta( 0.0, samples.median,             0.05, "median" )
    assert_in_delta( 0.2, samples.standard_deviation, 0.05, "sigma" )
    assert_in_delta( 0.0, samples.skewness,           0.10, "skewness" )
    assert_in_delta( 3.0, samples.kurtosis,           0.10, "kurtosis" )
  end

# Uniform quantile

  def test_uniform_quantile_nominal_range
    100.times { assert_in_delta( 0.0, uniform(rand), 0.5 ) }
  end
  def test_uniform_quantile_specified_width
    100.times { assert_in_delta( 0.0, 1.0*2*uniform(rand), 1) }
  end
  def test_uniform_quantile_specified_0p4_fractional_width_range
    100.times { assert_in_delta( 0.0, 0.4*2*uniform(rand), 0.4 ) }
  end
  def test_uniform_quantile_statistics
    samples = []
    1000.times{ samples << uniform(rand) }
    assert_in_delta( 0.0,    samples.mean,     0.01, "mean" )
    assert_in_delta( 0.0,    samples.median,   0.05, "median" )
    assert_in_delta( 1/12.0, samples.variance, 0.05, "sigma" )
    assert_in_delta( 0.0,    samples.skewness, 0.10, "skewness" )
    assert_in_delta( 9/5.0,  samples.kurtosis, 0.05, "kurtosis" )
  end

# Triangular quantile

  def test_triangular_quantile_nominal_range
    100.times { assert_in_delta( 0.0, triangular(rand), 0.5 ) }
  end
  def test_triangular_quantile_specified_halfwidth
    100.times { assert_in_delta( 0.0, 1.0*2*triangular(rand), 1.0 ) }
  end
  def test_triangular_quantile_specified_fractional_width_range
    100.times { assert_in_delta( 0.0, 0.2*2*triangular(rand), 0.2 ) }
  end
  def test_triangular_quantile_statistics
    samples = []
    1000.times { samples << triangular(rand) }
    assert_in_delta( 0.0,    samples.mean,     0.010, "mean" )
    assert_in_delta( 0.0,    samples.median,   0.020, "median" )
    assert_in_delta( 3/72.0, samples.variance, 0.005, "variance" )
    assert_in_delta( 0.0,    samples.skewness, 0.050, "skewness" )
    assert_in_delta( 2.4,    samples.kurtosis, 0.050, "kurtosis" )
  end

# Cauchy quantile

  def test_cauchy_quantile_function_with_known_values
    assert_equal 0, cauchy(0.5)
  end

end
