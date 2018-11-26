require "./method_list"
require "./class_list"
require "json"

mlfb = ClassList.new
class_list = mlfb.get
mlfb.write_class(class_list)

gfw = MethodList.new
method_list = gfw.get(class_list)
gfw.write_method(method_list)

path = File.expand_path("../process_dic",__FILE__)
system("ruby #{path}/remove_short_word.rb")
system("ruby #{path}/sort_dic.rb")

print "finished! use output/dic_sort.json"
