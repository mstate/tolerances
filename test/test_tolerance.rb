require 'test/unit'
require 'tolerance'

class TestTolerance < Test::Unit::TestCase
  def setup
    Tolerance.untagged = 0
  end
  def test_should_create_vanilla_tolerance_with_only_center_and_halfwidth
    tol = Tolerance.new 5, 1
    assert_equal 5, tol.center
    assert_equal 1, tol.halfwidth
    assert_equal :raw, tol.type
    assert_nil tol.quantile
    assert_nil tol.format
    assert_equal 'untagged_1', tol.tag
  end
  def test_should_accept_specified_quantile
    tol = Tolerance.new 5, 1, :quantile => :normal
    assert_equal :normal, tol.quantile
    tol = Tolerance.new 5, 1, :quantile => 'N'
    assert_equal :normal, tol.quantile
  end
  def test_should_allow_tag_assignment
    tol = Tolerance.new 5, 1, :tag => 'tag'
    assert_equal 'tag', tol.tag
  end
  def test_should_allow_percent_type
    tol = Tolerance.new 5, 50, :type => :percent
    assert_equal :percent, tol.type
    tol = Tolerance.new 5, 50, :type => '%'
    assert_equal :percent, tol.type
  end
  def test_should_allow_order_type
    tol = Tolerance.new 5, 1, :type => 'o'
    assert_equal :order, tol.type
    tol = Tolerance.new 5, 1, :type => :order
    assert_equal :order, tol.type
  end
  def test_should_allow_uniform_quantile
    tol = Tolerance.new 5, 1, :quantile => "U"
    assert_equal :uniform, tol.quantile
    tol = Tolerance.new 5, 1, :quantile => :uniform
    assert_equal :uniform, tol.quantile
  end
  def test_should_have_uniform_and_tag
    tol = Tolerance.new 0.7, 0.25, :quantile => "U", :tag => 'tag'
    assert_equal 0.7, tol.center
    assert_equal 0.25, tol.halfwidth
    assert_equal :uniform, tol.quantile
    assert_equal 'tag', tol.tag
  end
  def test_should_set_percent_type_and_uniform_quantile
    tol = Tolerance.new 5, 50, :type => "%", :quantile => "U"
    assert_equal :percent, tol.type
    assert_equal :uniform, tol.quantile
  end
  def test_should_set_order_type_and_uniform_quantile
    tol = Tolerance.new 5, 1, :type => "o", :quantile => "U"
    assert_equal :order, tol.type
    assert_equal :uniform, tol.quantile
  end
  def test_should_set_raw_type_with_triangular_quantile
    tol = Tolerance.new 5, 1, :quantile => "T"
    assert_equal :raw, tol.type
    assert_equal :triangular, tol.quantile
  end
  def test_should_sample_at_center_point
    tol = Tolerance.new 5, 1
    assert_equal 5, tol.value_at(0)
  end
  def test_should_parse_a_single_tolerance
    tol = Tolerance.parse '5+/-1'
    assert_equal 5, tol.center
    assert_equal 1, tol.halfwidth
  end
  def test_should_parse_more_than_one_tolerance
    tols = Tolerance.parse '5+/-1 10+/-1'
    assert_equal 2, tols.size
  end
  def test_should_return_nil_if_no_tolerances_found_during_parse
    tol = Tolerance.parse ''
    assert_nil tol
  end
  def test_integer_tolerance
    tol = Tolerance.parse '5+/-1'
    assert_equal 5, tol.center
    assert_equal 1, tol.halfwidth
  end
  def test_float_tolerance
    tol = Tolerance.parse '5.1+/-1.2'
    assert_equal 5.1, tol.center
    assert_equal 1.2, tol.halfwidth
  end
  def test_exponential_tolerance
    tol = Tolerance.parse '5.1e+01+/-1.2'
    assert_equal 5.1e+01, tol.center
    assert_equal 1.2, tol.halfwidth
  end
  def test_tolerance_with_format
    tol = Tolerance.parse '1.35+/-0.2_4.2f'
    assert_equal '4.2f', tol.format
  end
  def test_tolerance_with_single_quoted_tag
    tol = Tolerance.parse "5+/-1 'tag'"
    assert_equal 'tag', tol.tag
  end
  def test_should_allow_no_space_between_tag_and_tolerance
    tol = Tolerance.parse "5+/-1'tag'"
    assert_equal 1, tol.halfwidth
    assert_equal 'tag', tol.tag
  end
  def test_tolerance_with_double_quoted_tag_with_single_quote
    tol = Tolerance.parse '5+/-1 "mix\'d"'
    assert_equal "mix\'d", tol.tag
  end
  def test_tolerance_with_more_general_tag
    tol = Tolerance.parse "5+/-1 'tag^2_2+3->4*1.0'"
    assert_equal 'tag^2_2+3->4*1.0', tol.tag
  end
  def test_tolerance_with_more_general_tag_followed_by_single_quote
    tol = Tolerance.parse "5+/-1 'tag' I'm here"
    assert_equal 'tag', tol.tag
  end
  def test_tolerance_with_leading_debris
    tol = Tolerance.parse "exp1 = 0.7+/-0.25U 'Eta_O2'"
    assert_equal 0.7, tol.center
  end
  def test_tolerance_with_trailing_debris
    tol = Tolerance.parse "0.7+/-0.25U 'Eta_O2' and things"
    assert_equal 'Eta_O2', tol.tag
  end
  def test_percentage_tolerance
    tol = Tolerance.parse "5+/-1%"
    assert_equal :percent, tol.type
  end
  def test_zero_padded_percentage_tolerance
    tol = Tolerance.parse "5+/-03%"
    assert_equal 3, tol.halfwidth
    assert_equal :percent, tol.type
  end
  def test_order_tolerance
    tol = Tolerance.parse "5+/-1o"
    assert_equal :order, tol.type
  end
  def test_tolerance_with_normal_quantile
    tol = Tolerance.parse "5+/-1N"
    assert_equal :normal, tol.quantile
  end
  def test_tolerance_with_uniform_quantile
    tol = Tolerance.parse "5+/-1U"
    assert_equal :uniform, tol.quantile
  end
  def test_tolerance_with_triangular_quantile
    tol = Tolerance.parse "2+/-0.5T"
    assert_equal :triangular, tol.quantile
  end
  def test_tolerance_with_only_interval
    tol = Tolerance.parse "2+/-0.5I"
    assert_equal :interval, tol.quantile
  end
  def test_order_tolerance_with_normal_quantile
    tol = Tolerance.parse "5+/-1oN"
    assert_equal :order, tol.type
    assert_equal :normal, tol.quantile
  end
end
