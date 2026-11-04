# ==========================================
# latexmk 設定（ローカル・CI・エディター共通）
# ==========================================

# LuaLaTeX で PDF を生成
$pdf_mode = 4;
$lualatex = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -halt-on-error %O %S';

# 生成物の出力先
$out_dir = 'output';

# 独自パッケージ（src/portfolio.sty）を探索パスに追加
ensure_path('TEXINPUTS', './src//');
