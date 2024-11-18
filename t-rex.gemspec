Gem::Specification.new do |s|
  s.name        = 't-rex'
  s.version     = '1.0.6'
  s.licenses    = ['Unlicense']
  s.summary     = "T-REX - Terminal Rpn calculator EXperiment"
  s.description = "This is a terminal curses RPN calculator similar to the traditional calculators from Hewlett Packard. See https://www.hpmuseum.org/rpn.htm for info on RPN (Reverse Polish Notation). New in 1.0.6: Dropped the '.rb' suffix, fixed looping bug"
  s.authors     = ["Geir Isene"]
  s.email       = 'g@isene.com'
  s.files       = ["bin/t-rex"]
  s.add_runtime_dependency 'curses', '~> 1.3', '>= 1.3.2'
  s.executables << 't-rex'
  s.homepage    = 'https://isene.com/'
  s.metadata    = { "source_code_uri" => "https://github.com/isene/t-rex" }
end
