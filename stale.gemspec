Gem::Specification.new do |s|
  s.name        = "stale"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Norbert Crombach"]
  s.email       = ["norbert.crombach@primetheory.org"]
  s.homepage    = "http://github.com/norbert/stale"
  s.summary     = %q{Experimental fragment caching layer.}

  s.rubyforge_project = "stale"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(/^test\//)
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '~> 3.2'
  s.add_development_dependency 'mocha', '0.12.1'
end
