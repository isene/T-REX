Gem::Specification.new do |s|
  s.name        = 't-rex'
  s.version     = '2.2'
  s.licenses    = ['Unlicense']
  s.summary     = "T-REX - Terminal Rpn calculator EXperiment"
  s.description = "This is a terminal curses RPN calculator similar to the traditional calculators from Hewlett Packard. See https://www.hpmuseum.org/rpn.htm for info on RPN (Reverse Polish Notation). New in 2.1: Added 'e' for entering exponents directly into X. 2.2: Allowing for negative exponents (use 'H' to enter a minus sign)."
  s.authors     = ["Geir Isene"]
  s.email       = 'g@isene.com'
  s.files       = ["bin/t-rex"]
  s.add_runtime_dependency 'rcurses', '>= 2.4'
  s.executables << 't-rex'
  s.homepage    = 'https://isene.com/'
  s.metadata    = { "source_code_uri" => "https://github.com/isene/t-rex" }
end
