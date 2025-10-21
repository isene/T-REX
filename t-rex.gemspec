Gem::Specification.new do |s|
  s.name        = 't-rex'
  s.version     = '4.1.0'
  s.licenses    = ['Unlicense']
  s.summary     = "T-REX - Terminal Rpn calculator EXperiment"
  s.description = "This is a terminal curses RPN calculator similar to the traditional calculators from Hewlett Packard. See https://www.hpmuseum.org/rpn.htm for info on RPN (Reverse Polish Notation). Version 4.1.0: Add ENG (engineering notation) mode with Ctrl+E toggle - exponents always multiples of 3."
  s.authors     = ["Geir Isene"]
  s.email       = 'g@isene.com'
  s.files       = ["bin/t-rex"]
  s.add_runtime_dependency 'rcurses', '~> 6.0'
  s.add_runtime_dependency 'xrpn', '~> 3.0'
  s.executables << 't-rex'
  s.homepage    = 'https://isene.com/'
  s.metadata    = { "source_code_uri" => "https://github.com/isene/t-rex" }
end
