require "json"

path = File.expand_path("../../output",__FILE__)

hash = JSON.load(File.read(path+"/dic_short.json"));
hash.each do |key,_|
  hash[key].sort!
end

File.open(path+"/dic_sort.json","w") do |file|
  JSON.dump(hash,file)
end
