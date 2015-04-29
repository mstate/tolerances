module Quantiles

  # approximation from Peter J. Acklam
  def normal(p)
    (Float::EPSILON..1-Float::EPSILON).include? p or
      raise "#{p}: outside probabiliy domain (0,1)"
    a = [ -3.969683028665376e+01,  2.209460984245205e+02,
          -2.759285104469687e+02,  1.383577518672690e+02,
          -3.066479806614716e+01,  2.506628277459239e+00 ]
    b = [ -5.447609879822406e+01,  1.615858368580409e+02,
          -1.556989798598866e+02,  6.680131188771972e+01,
          -1.328068155288572e+01 ]
    c = [ -7.784894002430293e-03, -3.223964580411365e-01,
          -2.400758277161838e+00, -2.549732539343734e+00,
           4.374664141464968e+00,  2.938163982698783e+00 ]
    d = [  7.784695709041462e-03,  3.224671290700398e-01,
           2.445134137142996e+00,  3.754408661907416e+00 ]
    if p < 0.02425 then # lower region
      q = Math.sqrt(-2*Math.log(p))
      (((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) /
       ((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1)
    elsif p < 0.97575 then # central region (symmetrical)
      q = p - 0.5
      r = q*q
      (((((a[0]*r+a[1])*r+a[2])*r+a[3])*r+a[4])*r+a[5])*q /
      (((((b[0]*r+b[1])*r+b[2])*r+b[3])*r+b[4])*r+1)
    else # upper region
      q = Math.sqrt(-2*Math.log(1-p))
      -(((((c[0]*q+c[1])*q+c[2])*q+c[3])*q+c[4])*q+c[5]) /
        ((((d[0]*q+d[1])*q+d[2])*q+d[3])*q+1)
    end
  end
  module_function :normal

  def uniform(p)
    (0..1).include? p or raise "#{p}: outside probability domain [0,1]"
    p-0.5
  end
  module_function :uniform

  def triangular(p)
    (0..1).include? p or raise "#{p}: outside probability domain [0,1]"
    if p < 0.5
      -0.5 + Math.sqrt( 0.5*p )
    else # symmetric reflection
       0.5 - Math.sqrt( 0.5*(1-p) )
    end
  end
  module_function :triangular

  def cauchy(p)
    (0..1).include? p or raise "#{p}: outside probability domain [0,1]"
    Math.tan(Math::PI*(0.5-p))
  end
  module_function :cauchy

end
