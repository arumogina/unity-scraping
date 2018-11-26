require "json"

path = File.expand_path("../../output",__FILE__)

hash = JSON.load(File.read(path+"/dic.json"));
hash.each do |key,_|
  hash[key].select! do |w|
    w.length > 5
  end
end

File.open(path+"/dic_short.json","w") do |file|
  JSON.dump(hash,file)
end
