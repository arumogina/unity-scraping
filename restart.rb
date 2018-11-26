#for restart 途中で止まったときにlast_pathから再開する
#作ったはいいが、これを作った後に限って一度も止まらず動いたので、これの動作テストが出来てない
require_relative "class_list"
require_relative "method_list"
require "json"

op_path = File.expand_path("../output",__FILE__)
last_path = File.read(op_path);

class_list = ClassList.new.get

last_idx = class_list.index(last_path)
#temp_methodsに含まれる分=取得済みの分を除去
class_list.slice!(0..last_idx - 1)
ml = MethodList.new
method_list = ml.get(class_list)
b_method_text = File.read("#{op_path}/temp_methods.json")
b_method_list = JSON.load(b_method_text)

ml.write_method(method_list + b_method_list[:methods])

path = File.expand_path("../process_dic",__FILE__)
system("ruby #{path}/remove_short_word.rb")
system("ruby #{path}/sort_dic.rb")

print "finished! use output/dic_sort.json"
