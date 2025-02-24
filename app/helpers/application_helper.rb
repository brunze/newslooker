module ApplicationHelper
  def hyperscript_include_tag(filename)
    javascript_include_tag filename, type: "text/hyperscript", extname: "._hs"
  end
end
