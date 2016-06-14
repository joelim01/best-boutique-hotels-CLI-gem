Gem::Specification.new do |s|
  s.name        = 'best_boutique_hotels'
  s.version     = '0.0.0'
  s.date        = '2016-06-14'
  s.summary     = "A CLI for www.boutiquehotelawards.com's best hotels list."
  s.description = "A simple gem"
  s.authors     = ["Joseph Lim"]
  s.email       = 'joseph.d.lim.@.gmail'
  s.files       = ["lib/best_boutique_hotels.rb"]
  s.homepage    = ''
  s.license     = 'MIT'
  s.add_runtime_dependency "require_all", "nokogiri", "open-uri", "bundler", "rake"
  s.add_development_dependency "rspec", "pry", "rake"
end
