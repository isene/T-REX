#!/usr/bin/env ruby
# encoding: utf-8

require 'io/console'
require 'curses'
include  Curses

# CLASSES
class Curses::Window # CLASS EXTENSION 
  attr_accessor :color, :attr
  # General extensions (see https://github.com/isene/Ruby-Curses-Class-Extension)
  def clr
    self.setpos(0, 0)
    self.maxy.times {self.deleteln()}
    self.refresh
    self.setpos(0, 0)
  end
  def fill # Fill window with color as set by :bg
    self.setpos(0, 0)
    blank = " " * self.maxx
    self.maxy.times {self.attron(color_pair(self.color)) {self << blank}}
    self.refresh
    self.setpos(0, 0)
  end
  def p(text)
    self.attron(color_pair(self.color)) { self << text }
    self.refresh
  end
  def pa(text)
    self.attron(color_pair(self.color) | self.attr) { self << text }
    self.refresh
  end
end
class Stack
  attr_accessor :x, :y, :z, :t, :l, :deg

  def initialize(x, y, z, t, l)
    self.x = x.to_f
    self.y = y.to_f
    self.z = z.to_f
    self.t = t.to_f
    self.l = l.to_f
  end
  def lift
    self.y, self.z, self.t = self.x, self.y, self.z
  end
  def drop
    self.y, self.z = self.z, self.t
  end
  def rdn
    self.x, self.y, self.z, self.t = self.y, self.z, self.t, self.x
  end
  def rup
    self.x, self.y, self.z, self.t = self.t, self.x, self.y, self.z
  end
  def xy
    self.x, self.y = self.y, self.x
  end
  def add
    self.l = self.x
    self.x = self.y + self.x
    self.drop
  end
  def subtract
    self.l = self.x
    self.x = self.y - self.x
    self.drop
  end
  def multiply
    self.l = self.x
    self.x = self.y * self.x
    self.drop
  end
  def divide
    begin
      throw if self.x == 0
      self.l = self.x
      self.x = self.y / self.x
      self.drop
    rescue
      return "Error"
    end
  end
  def mod
    begin
      throw if self.x == 0
      self.l = self.x
      self.x = self.y % self.x
      self.drop
    rescue
      return "Error"
    end
  end
  def percent
    begin
      throw if self.y == 0
      self.l = self.x
      self.x = 100*(self.x / self.y)
      self.drop
    rescue
      return "Error"
    end
  end
  def chs
    self.x = -self.x
  end
  def pi
    self.l = self.x
    self.lift
    self.x = Math::PI
  end
  def pow
    self.l = self.x
    self.x = self.y ** self.x
    self.drop
  end
  def root
    begin
      self.l = self.x
      self.x = self.y ** (1 / self.x)
      self.drop
    rescue
      return "Error"
    end
  end
  def recip
    begin
      throw if self.x == 0
      self.l = self.x
      self.x = 1 / self.x
    rescue
      return "Error"
    end
  end
  def sqr
    self.l = self.x
    self.x = self.x ** 2
  end
  def sqrt
    self.l = self.x
    begin
      self.x = Math::sqrt(self.x)
    rescue
      return "Error"
    end
  end
  def cube
    self.l = self.x
    self.x = self.x ** 3
  end
  def ln
    self.l = self.x
    begin
      self.x = Math::log(self.x)
    rescue
      return "Error"
    end
  end
  def ex
    self.l = self.x
    self.x = Math::exp(self.x)
  end
  def log
    self.l = self.x
    begin
      self.x = Math::log10(self.x)
    rescue
      return "Error"
    end
  end
  def tenx
    self.l = self.x
    self.x = 10 ** self.x
  end
  def sin
    self.l = self.x
    self.x = self.x * Math::PI / 180 if self.deg
    self.x = Math::sin(self.x)
  end
  def cos
    self.l = self.x
    self.x = self.x * Math::PI / 180 if self.deg
    self.x = Math::cos(self.x)
  end
  def tan
    self.l = self.x
    self.x = self.x * Math::PI / 180 if self.deg
    self.x = Math::tan(self.x)
  end
  def asin
    self.l = self.x
    self.x = Math::asin(self.x)
    self.x = self.x * 180 / Math::PI if self.deg 
  end
  def acos
    self.l = self.x
    self.x = Math::acos(self.x)
    self.x = self.x * 180 / Math::PI if self.deg 
  end
  def atan
    self.l = self.x
    self.x = Math::atan(self.x)
    self.x = self.x * 180 / Math::PI if self.deg 
  end
  def rp
    begin
      throw if self.x == 0
      self.l = self.x
      x = self.x
      y = self.y
      self.x = Math::sqrt(x*x + y*y)
      self.y = Math::atan(y/x)
      if x < 0  # Q2 & Q3
        self.y += Math::PI
      elsif x >= 0 and y < 0 # Q4
        self.y += 2 * Math::PI
      end
      self.y = self.y * 180 / Math::PI if self.deg
    rescue
      return "Error"
    end
  end
  def pr
    self.l = self.x
    r = self.x
    t = self.y
    t = t * Math::PI / 180 if self.deg
    self.x = r * Math::cos(t)
    self.y = r * Math::sin(t)
  end
end

begin # BASIC SETUP
  @s     = Stack.new(0, 0, 0, 0, 0)
  @r     = %w[0 0 0 0 0 0 0 0 0 0] 
  @f     = 4
  @g     = 6
  @d     = true
  @m     = "Deg"

  load(Dir.home+'/.t-rex.conf') if File.exist?(Dir.home+'/.t-rex.conf')
  @m == "Deg" ? @s.deg = true : @s.deg = false

  Curses.init_screen
  Curses.start_color
  Curses.curs_set(0)
  Curses.noecho
  Curses.cbreak
  Curses.stdscr.keypad = true
end

# FUNCTIONS
def getchr # PROCESS KEY PRESSES
  c = STDIN.getch
  case c
  when "\e"    # ANSI escape sequences
    case $stdin.getc
    when '['   # CSI
      case $stdin.getc
      when 'A' then chr = "UP"
      when 'B' then chr = "DOWN"
      when 'C' then chr = "RIGHT"
      when 'D' then chr = "LEFT"
      when 'Z' then chr = "S-TAB"
      when '2' then chr = "INS"    ; STDIN.getc
      when '3' then chr = "DEL"    ; STDIN.getc
      when '5' then chr = "PgUP"   ; STDIN.getc
      when '6' then chr = "PgDOWN" ; STDIN.getc
      when '7' then chr = "HOME"   ; STDIN.getc
      when '8' then chr = "END"    ; STDIN.getc
      end
    end
  when "", "" then chr = "BACK"
  when "" then chr = "WBACK"
  when "" then chr = "LDEL"
  when "" then chr = "C-X"
  when "" then chr = "C-Q"
  when "" then chr = "C-N"
  when "" then chr = "C-G"
  when "" then chr = "C-L"
  when "	" then chr = "C-I"
  when "" then chr = "C-O"
  when "" then chr = "C-A"
  when "" then chr = "C-R"
  when "" then chr = "C-D"
  when "" then chr = "C-C"
  when "" then chr = "C-M"
  when "" then chr = "C-T"
  when "" then chr = "C-^"
  when "\r" then chr = "ENTER"
  when "\t" then chr = "TAB"
  when /./  then chr = c
  end
  return chr
end
def main_getkey(c) # GET KEY FROM USER
  c == "" ? chr = getchr : chr = c
  case chr
  when 'ENTER'
    @s.l = @s.x
    @s.y, @s.z, @s.t = @s.x, @s.y, @s.z
  when "'"
    @d = !@d
  when 'UP'   # Roll stack up
    @s.rup
  when 'DOWN' # Roll stack down
    @s.rdn
  when '<'    # x<>y
    @s.xy
  when '+'
    @s.add
  when '-'
    @s.subtract
  when '*'
    @s.multiply
  when '/'
    e = @s.divide
    error ("Error: Divide by zero") if e == "Error"
  when '\\'   # \ (modulo)
    @s.mod
  when '%'    # 100*x/y
    e = @s.percent
    error ("Error: Divide by zero") if e == "Error"
  when 'h'    # Change sign
    @s.chs
  when 'p'    # pi
    @s.l = @s.x
    @s.pi
  when '^'    # y^x
    @s.pow
  when 'C-^'  # y^(1/x)
    e = @s.root 
    error ("Error: Divide by zero") if e == "Error"
  when 'x'    # 1/x
    e = @s.recip
    error ("Error: Divide by zero") if e == "Error"
  when 'C-X'  # x^2
    @s.sqr  
  when 'q'    # Square root
    e = @s.sqrt
    error ("Error: Imaginary number") if e == "Error"
  when 'C-Q'  # x^3
    @s.cube
  when 'n'    # ln(x)
    e = @s.ln
    error ("Error: Negative x") if e == "Error"
  when 'C-N'  # e^x
    @s.ex
  when 'g'    # log(x)
    e = @s.log
    error ("Error: Negative x") if e == "Error"
  when 'C-G'  # 10^x
    @s.tenx
  when 'l'    # Recall Lastx (l) to x
    @s.lift
    @s.x = @s.l
  when 'C-L'  # Break/redraw
    @break = true
  when 'i'
    @s.sin
  when 'C-I'
    @s.asin
  when 'o'
    @s.cos
  when 'C-O'
    @s.acos
  when 'a'
    @s.tan
  when 'C-A'
    @s.atan
  when 'r'     # Rad mode
    @m     = "Rad"
    @s.deg = false
  when 'C-R'   # R->P
    e = @s.rp
    error ("Error: Divide by zero") if e == "Error"
  when 'd'     # Deg mode
    @m     = "Deg"
    @s.deg = true
  when 'C-D'   # P->R
    @s.pr
  when 'c'
    @s.x = 0
  when 'C-C'   # Clear stack
    @s.x = 0
    @s.y = 0
    @s.z = 0
    @s.t = 0
    @s.l = 0
  when 'C-M'
    @r = %w[0 0 0 0 0 0 0 0 0 0] 
  when 'RIGHT' # Store to Reg
    @w_x.clr
    @w_x.p(" Store x in Reg #(0-9)")
    r = getchr
    if r =~ /[0-9]/
      @r[r.to_i] = @s.x
    end
  when 'LEFT'  # Recall from Reg
    @w_x.clr
    @w_x.p(" Recall from Reg #(0-9)")
    r = getchr
    if r =~ /[0-9]/
      @s.lift
      @s.x = @r[r.to_i].to_f
    end
  when 's'     # Set Sci size/limit
    @w_x.clr
    @w_x.p(" Sci notation limit (2-9)")
    r = getchr
    if r =~ /[2-9]/
      @g = r.to_i
    end
  when 'f'     # Set Fix size
    @w_x.clr
    @w_x.p(" Fixed decimals (0-9)")
    r = getchr
    if r =~ /[0-9]/
      @f = r.to_i
    end
  when 'u'     # Undo
    unless @u.empty?
      @s = @u.last.dup
      @u.pop
      @undo = true
    end
  when 'Q'     # Exit 
    exit 0
  when /[0-9.,-]/ # Go to entry mode for x
    number, c = entry(chr)
    if number != ""
      @s.l = @s.x
      @s.lift unless @s.x == 0
      @s.x = number
    end
    main_getkey(c) if %w[< + - * / \ % ^ x C-X q C-Q n C-N g C-G i C-I o C-O a C-A c C-C].include?(c)
  end
end
def entry(chr)
  Curses.curs_set(1)
  Curses.echo
  num = chr
  pos = 1
  @w_x.color = 7
  while %w[0 1 2 3 4 5 6 7 8 9 . , h RIGHT LEFT HOME END DEL BACK WBACK LDEL].include?(chr)
    @w_x.clr
    @w_x.setpos(0,0)
    @w_x.pa(num)
    @w_x.setpos(0,pos)
    @w_x.refresh
    chr = getchr
    case chr
    when 'RIGHT'
      pos += 1 unless pos >= num.length
    when 'LEFT'
      pos -= 1 unless pos == 0
    when 'HOME'
      pos = 0
    when 'END'
      pos = num.length
    when 'DEL'
      num[pos] = ""
    when 'BACK'
      unless pos == 0
        pos -= 1
        num[pos] = ""
      end
    when 'WBACK'
      unless pos == 0
        until num[pos - 1] == " " or pos == 0
          pos -= 1
          num[pos] = ""
        end
        if num[pos - 1] == " "
          pos -= 1
          num[pos] = ""
        end
      end
    when 'LDEL'
      num = ""
      pos = 0
    when 'h'
      if num[0] == "-"
        num[0] = "" 
        pos -= 1
      else
        num.insert(0, "-")
        pos += 1
      end
    when /[0-9.,]/
      num.insert(pos,chr)
      pos += 1
    end
  end
  num = "" if %w[DOWN UP].include?(chr)
  num.gsub!(/,/, '.')
  num != "" ? number = num.to_f : number = ""
  Curses.curs_set(0)
  Curses.noecho
  @w_x.color = 6
  return number, chr
end
def num_format(n)
  if n.abs >= 10 ** @g.to_i
    n = "%.#{@g}g" % n
  elsif n.abs <= 10 ** (1 / @g.to_i) and n > 10
    n = "%.#{@g}g" % n
  else
    n = n.round(@f)
    n = "%.#{@f}f" % n
    m = n[/^-/]
    m = "" if m == nil
    n.sub!(/-/, '')
    i = n[/\d*/]
    i.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    f = n.sub(/\d*\.(\d*)/, '\1')
    n = m + i + "." + f
    if not @d
      n.gsub!(/,/, ' ')
      n.sub!(/\./, ',')
    end
  end
  return n
end
def pstack
  x = num_format(@s.x)
  y = num_format(@s.y)
  z = num_format(@s.z)
  t = num_format(@s.t)
  l = num_format(@s.l)
  @w_l.setpos(0,0)
  @w_l.p(l.rjust(30))
  @w_yzt.setpos(0,0)
  @w_yzt.p(t.rjust(30) + z.rjust(30) + y.rjust(30))
  @w_x.setpos(0,0)
  @w_x.pa(x.rjust(30))
end
def pregs
  @w_reg.setpos(1,0)
  10.times do |i| 
    r = num_format(@r[i].to_f)
    @w_reg.p(" R##{i}" + "#{r}".rjust(27) + "\n")
  end
end
def error(err)
  @w_x.clr
  @w_x.p(err.rjust(30))
  getchr
end
def cmd
text = <<CMDTEXT
 
 r|↓| r|↑| x|<|>y  |+| |-| |*| |/| |\\| |%| c|h|s |p|i
 y√x  x^2 x^3  e^x 10^x  redrw
 y|^|x  1/|x| s|q|rt l|n|  lo|g|   |l|astx
 asin acos atan  R→P P→R  cstk
  s|i|n  c|o|s  t|a|n  |r|ad |d|eg  |c|lx

 |→|sto  rcl|←|  |u|ndo  |Q|uit  
CMDTEXT
  text = text.split("\n")
  text.each_with_index do |t,i|
    if i.even?
      @w_cmd.color = 8
      @w_cmd.p(t)
    else
      t = t.split("|")
      t.each_with_index do |c,j|
        if j.even?
          @w_cmd.color = 9
          @w_cmd.p(c)
        else
          @w_cmd.color = 10
          @w_cmd.pa(c)
        end
      end
      @w_cmd.p("\n")
    end
    @w_cmd.p("\n")
  end
end
def help
help = <<HELPTEXT
  
  T-REX - Terminal Rpn calculator EXperiment
  Code on GitHub: https://github.com/isene/T-REX
  
  This is a Reverse Polish Notation calculator similar 
  to the traditional calculators from Hewlett Packard.
  See https://www.hpmuseum.org/rpn.htm for info on RPN.
 
  The stack is shown to the top left:
  L is the "Last X" register showing the previous value in X.
  T, Z, Y and X registers comprise the operating stack.
  Toggle US and European number formats by pressing '. 
 
  Functions available are shown under the stack registers.
  The orange symbol corresponds to the key to be pressed.
  For functions above each label (grey functions), press
  the Control key (Ctrl) and the orange key (asin = Ctrl+i).
  
  For Rectangular to Polar conversions:
  R-P: X value in x, Y in y - yields "θ" in y and "r" in x.
  P-R: "θ" in y and "r" in x - yeilds X in x and Y in y.

  Use the "f" key to set the fixed number of decimal places.
  Use the "s" key to set the limit for viewing numbers in
  the "scientific" notation (e.g. 5e+06 for 5000000).
 
  Content of registers #0-#9 are shown below the functions.
  Store/recall using Right/Left keys. Ctrl-M clears the regs.
 
  You can undo all the way to the beginning of the session.
  The stack, register contents and modes are saved on Quit.
 
HELPTEXT
 @w_hlp.p(help)
end
def conf_write # WRITE TO .t-rex.conf
  conf  = "@f = #{@f}\n"
  conf += "@g = #{@g}\n"
  @d ? d = "true" : d = "false"
  conf += "@d = #{d}\n"
  conf += "@m = \"#{@m}\"\n"
  conf += "@s = Stack.new(#{@s.x}, #{@s.y}, #{@s.z}, #{@s.t}, #{@s.l})\n"
  conf += "@r = %w[#{@r[0]} #{@r[1]} #{@r[2]} #{@r[3]} #{@r[4]} #{@r[5]} #{@r[6]} #{@r[7]} #{@r[8]} #{@r[9]}]\n" 
  File.write(Dir.home+'/.t-rex.conf', conf)
end

# MAIN PROGRAM
loop do # OUTER LOOP - (catching refreshes via 'b')
  @break = false # Initialize @break variable (set if user hits 'b')
  begin # Create the windows/panels
    maxx = Curses.cols
    maxy = Curses.lines
    Curses.stdscr.color = 1
    Curses.stdscr.fill
    # Curses::Window.new(h,w,y,x)
    @w_inf = Curses::Window.new( 1, 32, 1, 1)
    @w_lbl = Curses::Window.new( 5,  2, 2, 1)
    @w_l   = Curses::Window.new( 1, 30, 2, 3)
    @w_yzt = Curses::Window.new( 3, 30, 3, 3)
    @w_x   = Curses::Window.new( 1, 30, 6, 3)
    @w_cmd = Curses::Window.new(12, 32, 8, 1)
    @w_reg = Curses::Window.new(maxy - 22, 32, 21, 1)
    @w_hlp = Curses::Window.new(maxy -  2, maxx - 35, 1, 34)

    init_pair( 1, 234, 234) # stdscr
    init_pair( 2,  88, 238) # @w_inf
    init_pair( 3,  60, 238) # @w_lbl
    init_pair( 4, 246, 236) # @w_l
    init_pair( 5, 250, 234) # @w_yzt
    init_pair( 6,   7,   0) # @w_x
    init_pair( 7,   0, 250) # @w_xi
    init_pair( 8, 242, 233) # @w_cmd ctrl- & @w_reg
    init_pair( 9, 111, 233) # @w_cmd
    init_pair(10, 214, 233) # @w_cmd key
    init_pair(11, 238, 233) # @w_hlp

    @w_inf.color = 2
    @w_lbl.color = 3
    @w_l.color   = 4 
    @w_yzt.color = 5
    @w_x.color   = 6  
    @w_x.attr    = Curses::A_BOLD
    @w_cmd.color = 8
    @w_cmd.attr  = Curses::A_BOLD
    @w_reg.color = 8
    @w_hlp.color = 11

    @w_lbl.p(" L T Z Y X")
    @w_cmd.fill; cmd
    @w_reg.fill
    @w_hlp.fill; help

    @u = []
    @undo = false

    loop do # INNER, CORE LOOP 
      
      @w_inf.clr
      @w_inf.p("  #{@m} Sci=#{@g} Fix=#{@f}".ljust(32))
      pstack
      pregs
      @t = @s.dup
      main_getkey("")    # Get key from user 
      @u.push(@t.dup) if @t != @s and @undo == false
      @undo = false

      break if @break    # Break to outer loop, redrawing windows, if user hit 'r'
      break if Curses.cols != maxx or Curses.lines != maxy # break on terminal resize 
    end
  ensure # On exit: close curses, clear terminal 
    conf_write
    close_screen
  end
end

# vim: set sw=2 sts=2 et fdm=syntax fdn=2 fcs=fold\:\ :
