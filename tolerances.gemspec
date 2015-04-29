Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'tolerances'
  s.version     = '1.0.1'
  s.summary     = 'Mathematical library for supporting Monte-Carlo simulations'
  s.description = 'Provies simple statitistics and quantiles.'
  s.required_ruby_version = '>= 2.2.0'

  s.authors            = ['Someone at NASA', 'Mike State']
  s.email             = 'mstate@gmail.com'
  s.homepage          = 'https://github.com/mstate/tolerances'
  # s.rubyforge_project = 'actionmailer'
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"
  s.requirements << 'none'
end
