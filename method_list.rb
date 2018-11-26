require "net/https"
require "uri"
require "json"

class MethodList
  REF_HOST = "https://docs.unity3d.com/"
  REF_PATH = "/2018.2/Documentation/ScriptReference/"

  #path_listはclass名の配列
  def get(path_list)
    method_list = []
    last_path = nil
    retry_cnt = 0
    begin
      path_list.each do |path|
        puts "current-path:#{path}"
        method_list.concat(extract_methods(get_web_page(path),path))
        last_path = path
        retry_cnt = 0
        sleep 2
      end
    rescue => e
      puts e
      if retry_cnt <= 3
        retry_cnt += 1
        retry
      else
        File.write("./output/last_class.txt",last_path)
        write_temp_method(method_list)
        puts "stop working by above error"
        exit
      end
    end
    write_temp_method(method_list)
    return method_list
  end

  def write_method(method_list)
    method_list.uniq!
    hash_text = File.read("./output/dic.json")
    File.open("./output/dic.json","w") do |file|
      hash = JSON.load(hash_text) || {}
      hash[:methods] = method_list
      JSON.dump(hash,file)
    end
  end

  private

  def write_temp_method(method_list)
    #ファイルがなければ作成,File.readはファイルがなければエラーになるので
    File.open("./output/temp_methods.json","a"){}
    tm = File.read("./output/temp_methods.json")
    #前回の中断分を考慮
    tm = JSON.load(tm) || {}
    sum_ml = method_list + (tm["methods"] || [])
    sum_ml.uniq!
    File.open("./output/temp_methods.json","w") do |file|
      hash = {methods:sum_ml}
      JSON.dump(hash,file)
    end
  end

  def get_web_page(path)
    url = URI.parse(REF_HOST)
    res = Net::HTTP.start(url.host,url.port,use_ssl:true) { |hp|
      hp.get("#{REF_PATH}#{path}.html")
    }
    return res.body
  end

  #extract_methodsとあるが、メソッド以外も抽出してる
  def extract_methods(page_text,path)
    return page_text.scan(/<a href="#{path}\.(.[^<>]+?)\.html"/).flatten
  end
end
