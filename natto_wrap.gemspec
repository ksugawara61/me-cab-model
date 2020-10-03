# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'natto_wrap/version'

GITHUB_URL = 'https://github.com/ksugawara61/natto_wrap'

Gem::Specification.new do |spec|
  spec.name          = 'natto_wrap'
  spec.version       = NattoWrap::VERSION
  spec.authors       = ['ksugawara61']
  spec.email         = ['listadoko@gmail.com']

  spec.summary       = 'A lightweight wrapper library for natto'
  spec.description   = spec.summary
  spec.homepage      = GITHUB_URL
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_runtime_dependency 'natto', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.metadata = {
    'bug_tracker_uri' => "#{GITHUB_URL}/issues",
    'changelog_uri' => "#{GITHUB_URL}/blob/master/CHANGELOG.md",
    'documentation_uri' => "#{GITHUB_URL}/blob/master/README.md",
    'homepage_uri' => GITHUB_URL,
    'source_code_uri' => GITHUB_URL
  }
end
