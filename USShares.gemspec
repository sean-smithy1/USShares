Gem::Specification.new do |spec|
  spec.name        = 'USShares'
  spec.version     = '0.0.1'
  spec.date        = '2014-11-22'
  spec.summary     = "Import Shares from Yahoo"
  spec.description = ""
  spec.authorss     = ['Sean Smith', 'Kyle Smith']
  spec.email       = 'kyle.smithy2@gmail.com'
  spec.files       += Dir.glob('{lib, spec}/**/*') + ['README.mb', 'LICENCE.md']
  spec.homepage    = 'http://rubygems.org/gems/USShares'
  spec.license       = 'MIT'
  spec.add_runtime_dependency 'mysql2', '~>3.1.0'
  spec.add_development_dependency 'rspec', '~> 2.14.1'
  spec.require_paths = ["lib"]
end
