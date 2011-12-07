require "pp"

def fallback(str)
  reg = /
  (?:(\[font[^\[]+\] .*?  \[\/font\]) .*?\n|\r)?
  \[code\] (?>(?:\[[^\]]+\])*)
  (.*?) \[\/code\]
  /mix

  reg2 = /(?:^<br[^>]*>$)|(?: (.*?)(https?:\/\/.*)(?:<br[^>]*>.*) )/ix

  reg3 = /\]([^\[]+)\[/ix

  res = str.scan reg

  res.each do |r|
    if not r[0].nil? and r[0] =~ reg3
     puts "########## #{$1} ###############" 
    else
      puts "##############################"
    end
    r[1].scan(reg2).each do |l|
      next if l[0].nil? and l[1].nil?
      if not l[0].nil? and not l[0].empty? and l[0] =~ reg3
        print "(#{$1}) - "
      end
      pp l
    end
  end
end


str = File.open('spec/remote_data/tehparadox/game2.html') do |f|
  f.read()
end

fallback(str)
