require "./method_list"
require "./class_list"
require "json"

mlfb = ClassList.new
class_list = mlfb.get
mlfb.write_class(class_list)

puts "comment out exit!"
exit

gfw = MethodList.new
method_list = gfw.get(class_list)
gfw.write_method(method_list)
