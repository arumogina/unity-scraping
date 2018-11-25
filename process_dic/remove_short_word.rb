require "json"

hash = JSON.load(File.read("./output/dic.json"));
hash.each do |key,_|
  hash[key].select! do |w|
    w.length > 5
  end
end

File.open("./output/dic-short.json","w") do |file|
  JSON.dump(hash,file)
end
