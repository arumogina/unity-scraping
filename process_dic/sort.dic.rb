require "json"

hash = JSON.load(File.read("./output/dic-short.json"));
hash.each do |key,_|
  hash[key].sort!
end

File.open("./output/dic-sort.json","w") do |file|
  JSON.dump(hash,file)
end
