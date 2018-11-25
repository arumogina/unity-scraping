require "net/https"
require "uri"
class MethodList
  REF_HOST = "https://docs.unity3d.com/"
  REF_PATH = "/2018.1/Documentation/ScriptReference/"

  #path_listはclass名の配列
  def get(path_list)
    method_list = []

    begin
      path_list.each do |path|
        method_list.concat(extract_methods(get_web_page(path),path))
        sleep 2
      end
    ensure
      method_list.uniq!
      File.write("./output/last_class.txt",path)
      File.open("./output/temp_methods.json","w") do |file|
        hash = {methods:method_list}
        JSON.dump(hash,file)
      end
    end
    return method_list.uniq
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

  def extract_methods(page_text,path)
    #メソッド名のみ取得したい
    #メソッド名はPublic Methods,Static Methodsのワードより下にあるので、Methodsで分割しその後半を取得している
    tar_text = page_text.split("Methods")[1] || ""
    return tar_text.scan(/<a href="#{path}\.(.+?)\.html"/).flatten
  end
end
