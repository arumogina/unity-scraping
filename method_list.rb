require "net/https"
require "uri"
class MethodList
  REF_HOST = "https://docs.unity3d.com/"
  REF_PATH = "/2018.2/Documentation/ScriptReference/"

  #path_listはclass名の配列
  def get(path_list)
    method_list = []
    last_path = nil
    begin
      path_list.each do |path|
        method_list.concat(extract_methods(get_web_page(path),path))
        last_path = path
        sleep 2
      end
    rescue => e
      puts e
    ensure
      method_list.uniq!
      File.write("./output/last_class.txt",last_path)
      File.open("./output/temp_methods.json","w") do |file|
        hash = {methods:method_list}
        JSON.dump(hash,file)
      end
    end
    return method_list
  end

  def write_method(method_list)
    hash_text = File.read("./output/dic.json")
    File.open("./output/dic.json","w") do |file|
      hash = JSON.load(hash_text) || {}
      hash[:methods] = method_list
      JSON.dump(hash,file)
    end
  end

  private

  def get_web_page(path)
    url = URI.parse(REF_HOST)
    res = Net::HTTP.start(url.host,url.port,use_ssl:true) { |hp|
      hp.get("#{REF_PATH}#{path}.html")
    }
    return res.body
  end

  #extract_methodsとあるが、メソッド以外も抽出してる
  def extract_methods(page_text,path)
    return page_text.scan(/<a href="#{path}\.(.+?)\.html"/).flatten
  end
end
