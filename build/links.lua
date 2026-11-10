-- 教材内の .md へのリンクを .html に置き換え、figures/ の図に srcset を付ける。
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

-- figures/ の PNG は bin/figures が2倍の解像度で撮っている。
-- srcset で 2x と伝え、図の HTML で決めた大きさで表示させる。
function Image(el)
  local src = el.src
  if src:match("^%a[%w+.-]*:") or not src:match("figures/[^/]+%.png$") then
    return nil
  end
  el.attributes["srcset"] = src .. " 2x"
  return el
end
