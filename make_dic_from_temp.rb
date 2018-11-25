#メソッドの取得が途中で止まった場合など、tem_methodsから辞書を生成するときに使用
require "json"
require "./method_list"
require "./class_list"
require "json"

mlfb = ClassList.new
class_list = mlfb.get
mlfb.write_class(class_list)

method_hash = JSON.load(File.read("./output/temp_methods.json"))
class_hash = JSON.load(File.read("./output/dic.json"))
File.open("./output/dic.json","w") do |file|
  complete_hash = class_hash.merge(method_hash)
  JSON.dump(complete_hash,file)
end
