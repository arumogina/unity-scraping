#別にtemp_methodsから辞書を生成するときに使用
require "json"
require_relative "method_list"
require_relative "class_list"

cl = ClassList.new
class_list = cl.get
cl.write_class(class_list)

op_path = File.expand_path("../output",__FILE__)

method_hash = JSON.load(File.read("#{op_path}/temp_methods.json"))
method_hash["methods"].uniq!

class_hash = JSON.load(File.read("#{op_path}/dic.json"))
class_hash["class"].uniq!

File.open("#{op_path}/dic.json","w") do |file|
  complete_hash = class_hash.merge(method_hash)
  JSON.dump(complete_hash,file)
end

pd_path = File.expand_path("../process_dic",__FILE__)
system("ruby #{pd_path}/remove_short_word.rb")
system("ruby #{pd_path}/sort_dic.rb")

puts "finished!"
