Gem::Specification.new do |s|
  s.name        = 'best_boutique_hotels'
  s.version     = '0.1.1'
  s.date        = '2016-06-14'
  s.summary     = "A CLI for www.boutiquehotelawards.com's best hotels list."
  s.description = "A simple gem"
  s.authors     = ["Joseph Lim"]
  s.email       = 'joseph.d.lim.@.gmail'
  s.files       = ["lib/best_boutique_hotels.rb", "lib/best_boutique_hotels/category.rb", "lib/best_boutique_hotels/command_line.rb", "lib/best_boutique_hotels/scraper.rb", "lib/best_boutique_hotels/hotel.rb", "config/environment.rb"]
  s.homepage    = ''
  s.license     = 'MIT'
  s.executables << 'best_boutique_hotels'
  s.add_runtime_dependency "require_all",'~> 1.3', ">=1.3.3"
  s.add_runtime_dependency "nokogiri",'~> 1.6', ">=1.6.8"
  s.add_runtime_dependency "bundler",'~> 1.12', ">=1.12.5"
  s.add_runtime_dependency "ruby-progressbar", '~> 1.8', ">=1.8.1"
  s.add_runtime_dependency "colorize",'~> 0.7', ">=0.7.7"

end
