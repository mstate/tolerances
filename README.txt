= tolerances

* http://rubyforge.org/projects/nasarb
* http://nasarb.rubyforge.org/tolerances
* mailto:nasarb-developers@rubyforge.org

== DESCRIPTION:

Provides a Tolerance object and a Tolerances collection to facilitate
specifying and analyzing variabilities and uncertainties.

To aid in sampling for Monte-Carlos applications, this package also
includes some inverse cummulative probability distribution functions.

== FEATURES/PROBLEMS:

* Document uncertainties in situ with tolerance markup, e.g., 1.0+/-0.2
* Can be used by Monte Carlos black box techniques for propogating
  uncertainty intervals or computing sensitivities.

== SYNOPSIS:

  require 'rubygems'
  require 'tolerances'

  p Tolerance.parse("Uncertainty: 10+/-1")

  #<Tolerance:0x52f788 @center=10.0, @distribution=nil, @format=nil,
                       @halfwidth=1.0, @tag="untagged_1", @type=:raw>

== REQUIREMENTS:

* rubygems

== INSTALL:

* sudo gem install tolerances

== LICENSE:

Tolerance is released under the NASA Open Source Agreement -- see License.txt[link:files/License_txt.html] for details.
