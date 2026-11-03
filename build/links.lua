-- 教材内の .md へのリンクを、生成する .html へのリンクに置き換える。
-- README.md は index.html として出力するので、リンク先もそれに合わせる。
function Link(el)
  local path, anchor = el.target:match("^([^#]*)(#?.*)$")
  if path:match("^%a[%w+.-]*:") or not path:match("%.md$") then
    return nil
  end
  path = path:gsub("README%.md$", "index.md"):gsub("%.md$", ".html")
  el.target = path .. anchor
  return el
end
