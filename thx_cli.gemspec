# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thx_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "thx_cli"
  spec.version       = ThxCli::VERSION
  spec.authors       = ["Yoshiki.Sashiyama"]
  spec.email         = ["picolt10@gmail.com"]

  spec.summary       = "Thx(Peer-To-Peer Bonus System) client."
  spec.homepage      = "https://github.com/sashiyama/thx_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "faraday", "~> 0.14.0"
  spec.add_development_dependency "thor", "~> 0.20.0"
end