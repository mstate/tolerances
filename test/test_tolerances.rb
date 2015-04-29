require 'test/unit'
require 'tolerances'

class TestTolerances < Test::Unit::TestCase
  def setup
    Tolerance.untagged = 0
  end
  def test_should_find_simple_tolerance
    tols = Tolerances.parse('1+/-0.1')
    assert_equal 1, tols.tolerances.size
    tol = tols.tolerances.first
    assert_equal 1,    tol.center
    assert_equal 0.1,  tol.halfwidth
    assert_equal :raw, tol.type
    assert_nil tol.quantile
    assert_nil tol.format
    assert_equal 'untagged_1', tol.tag
  end
  def test_should_find_two_tolerances_on_same_line
    tols = Tolerances.parse('1+/-0.1 2+/-0.1')
    assert_equal 2, tols.tolerances.size
  end
  def test_should_find_groups_of_tags
    tols = Tolerances.parse('1+/-0.1 "group" 2+/-0.1 "group"')
    assert_equal 2, tols.tags['group'].size
  end
  def test_should_return_interpolated_string_with_values
    tols = Tolerances.parse('2+/-0.1 x 4+/-0.1')
    assert_equal '2.0 x 4.0', tols.result(tols.values_at([0,0]))
  end
  def test_should_return_interpolated_string_with_formatted_values
    tols = Tolerances.parse('2+/-0.1_4.1f x 4+/-0.1_.3f')
    assert_equal ' 2.0 x 4.000', tols.result(tols.values_at([0,0]))
  end
  def test_should_sample_according_to_specified_halfwidth_fraction
    tols = Tolerances.parse('1+/-0.1')
    assert_equal [1.0], tols.values_at([ 0])
    assert_equal [1.1], tols.values_at([ 1])
    assert_equal [0.9], tols.values_at([-1])
  end
  def test_should_fail_if_samples_and_tags_not_same_size
    tols = Tolerances.parse('1+/-0.1')
    assert_raises(RuntimeError){tols.values_at([])}
  end
  def test_should_sample_per_tag_according_to_specified_halfwidth_fraction
    tols = Tolerances.parse('1+/-0.1 "DUP_TAG" 2+/-0.2 "DUP_TAG"')
    assert_equal [ 1.0, 2.0 ], tols.values_at([ 0])
    assert_equal [ 1.1, 2.2 ], tols.values_at([ 1])
    assert_equal [ 0.9, 1.8 ], tols.values_at([-1])
    tols = Tolerances.parse('1+/-0.1 2+/-0.2')
    assert_equal [ 1.0, 1.8 ], tols.values_at([0,-1])
    assert_equal [ 1.1, 2.0 ], tols.values_at([1, 0])
    assert_equal [ 1.1, 1.8 ], tols.values_at([1,-1])
  end

end
