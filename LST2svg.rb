#!/usr/bin/env ruby
data = Array.new
n=0
vars = 0

begin
File.open(ARGV[0]) do |file|
  vars = file.gets.chomp.split("\t")
  n = vars.length

  line = file.gets.chomp.split("\t")
  n.times do |i|
    data[i] = line[i]
  end
  
  file.each_line do |line|
    line = line.chomp.split("\t")
    n.times do |i|
      data[i] << line[i]
    end
  end
end

rescue SystemCallError => e
  puts %Q(#{e.class}: #{e.message})
  exit
rescue IOError => e
  puts %Q(#{e.class}: #{e.message})
  exit
end


File.open("#{ARGV[0].split(".")[0]}.svg","w") do |file|
  file.puts "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{((data.length/30)+1)*405.6}px\" height=\"#{n*27+10}px\" viewBox=\"-10 -10 312 90\" version=\"1.1\">\n<g>"
  
  vars.each_with_index do |v,i|
    file.puts "<text x=\"35\" y=\"#{i*20+8.5}\" text-anchor=\"end\" font-size=\"10\" fill=\"black\" font-family=\"Helvetica\">#{v}</text>"
    file.print '<path stroke-linecap="square" stroke-width="0.6" stroke="black" fill="none" d="'

    data[i].chars.each_with_index do |d,l|
       if d == "0" 
         if data[i][l-1] == "1"
           file.print "M#{42+l*10},#{10+i*20}L#{42+l*10},#{i*20}"
         end
         file.print "M#{42+l*10},#{10+i*20}H#{42+(l+1)*10}"
       elsif d == "1" 
         if data[i][l-1] == "0"
           file.print "M#{42+l*10},#{i*20}L#{42+l*10},#{10+i*20}"
         end
         file.print "M#{42+l*10},#{i*20}H#{42+(l+1)*10}"
       end
    end
    file.puts "\"\/>"
    file.puts ""
  end
  file.puts "<\/g>\n<\/svg>"
end