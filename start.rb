require "json"
require_relative "class_list"
require_relative "method_list"

op_path = File.expand_path("../output",__FILE__)
#初期化
File.open("#{op_path}/temp_methods.json","w"){}

mlfb = ClassList.new
class_list = mlfb.get
mlfb.write_class(class_list)

gfw = MethodList.new
method_list = gfw.get(class_list)
gfw.write_method(method_list)

pd_path = File.expand_path("../process_dic",__FILE__)
system("ruby #{pd_path}/remove_short_word.rb")
system("ruby #{pd_path}/sort_dic.rb")

print "finished! use output/dic_sort.json"
