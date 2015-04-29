# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/tolerances.rb'

Hoe.new('tolerances', Tolerances::VERSION) do |p|
  p.rubyforge_name  = 'nasarb'
  p.remote_rdoc_dir = 'tolerances'
  p.developer('Bil Kleb', 'Bil.Kleb@nasa.gov')
  p.rsync_args = '-rpv --delete' # to perserve group permissions
end

# vim: syntax=Ruby
