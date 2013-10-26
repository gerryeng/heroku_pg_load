Gem::Specification.new do |s|
  s.name        = 'heroku_pg_loader'
  s.version     = '0.0.2'
  s.date        = '2013-10-26'
  s.summary     = "A simple gem to load your Heroku Postgres production database into a local database"
  s.description = "A simple gem toload your Heroku Postgres production database into a local database"
  s.authors     = ["Gerry Eng"]
  s.email       = 'm@gerryeng.com'
  s.files       = ["lib/heroku_pg_loader.rb"]
  s.executables << 'heroku_pg_load'
  s.homepage    = 'http://gerryeng.com'
  s.license       = 'MIT'
end