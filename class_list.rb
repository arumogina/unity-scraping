require "net/http"

class ClassList

  def get
    return extract_class(read_base_text);
  end

  #クラス名をjsonに書き込み（実際にはクラス以外も混じってる。".class"以降のもののみ取得すればクラスだけ取得できる)
  def write_class(class_list)
    wcl = []
    class_list.each { |cl|
      wcl.concat(cl.split("."))
    }
    wcl.uniq!
    File.open("./output/dic.json","w") do |file|
      hash = {class:wcl}
      JSON.dump(hash,file)
    end
  end

  private

  def read_base_text
    ret = nil
    File.open("base.txt") do |f|
      ret = f.read
    end
    return ret
  end

  def extract_class(text)
    text.scan(/<a href="(.+?)\.html"/).flatten;
  end
end
