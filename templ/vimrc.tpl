""" vimrc示例


"""-----------------------------
""" 关闭兼容模式
"""-----------------------------
set nocompatible


"""-----------------------------
""" 外观
"""-----------------------------
set number				" 显示行号
set ruler				" 显示状态栏标尺
set showcmd				" 显示输入的命令
set showmode			" 显示当前模式
set t_Co=256			" 启用256色
set hlsearch			" 高亮查找
syntax on				" 语法高亮
"set cursorline			" 高亮当前行
set showmatch			" 高亮匹配括号
"color ron				" 颜色主题
set cmdheight=2			" 命令行高度
set signcolumn=yes	" 总是显示标记列，否则语义检测符号会左右移动整个UI


"""-----------------------------
""" 缩进与行列
"""-----------------------------
set tabstop=4			" tab占用4个空格
set shiftwidth=4		" 缩进使用4个空格
"set textwidth=80		" 行宽
"set nowrap				" 不折行
set linebreak			" 不在单词内部折行
"set scrolloff=5		" 垂直滚动偏离行
"set sidescrolloff=15	" 水平滚动偏离字符
"set whichwrap+=,<,>,[,]	" 允许光标跨行的操作


"""-----------------------------
""" 编码
"""-----------------------------
set encoding=utf-8
"set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set ambiwidth=double	" 防止Unicode特殊符号无法显示


"""-----------------------------
""" 功能
"""-----------------------------
set history=50			" 命令历史数
set updatetime=300 		" 刷新时间300ms
set incsearch			" 启用增量查找
set tags=./tags;,tags	" tags文件位置
set backspace=indent,eol,start		" 智能回退
set nobackup			" 不备份
set wildmenu			" 操作指令tab自动补全
"set wildmode=longest:list,full

" 自动打开上次编辑位置
augroup set_cursor_to_last_pos
	au!
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
augroup END


"""-----------------------------
""" 文件类型操作
"""-----------------------------
" 开启文件类型检测
filetype plugin indent on

" 额外文件类型映射
augroup map_filetype_by_ext
	au!
	au BufNewFile,BufRead *.hrp set filetype=cpp
augroup END


"""-----------------------------
""" 自定义映射
"""-----------------------------
" 转义tab以允许自定义tab相关的映射
exe 'set t_kB=' . nr2char(27) . '[Z'

" 自定义mapleader
let mapleader = "\<Space>"

function! SwitchBuffer(i)
	exe 'bfirst'
	if a:i > 1
		exe printf("bnext %d", a:i - 1)
	endif
endfunction

" 按<leader> + [1-9]来切换buffer
for i in range(1, 9)
	exe 'nnoremap <leader>' . i . ' :call SwitchBuffer(' . i . ')<CR>'
endfor

" 按<leader> + [和]来左右切换buffer
nnoremap <leader>[ :bprevious<CR>
nnoremap <leader>] :bnext<CR>

" 按<leader> + x关闭当前buffer
nnoremap <leader>x :bdelete<CR>


"""=============================
""" 以下为插件设置
"""=============================


"""-----------------------------
""" gruvbox
"""-----------------------------
colorscheme %SET_COLORSCHEME%		" 启用该颜色主题
set background=dark		" 深色模式


"""-----------------------------
""" NERDTree
"""-----------------------------
augroup nerdtree_auto_cmd
	au!
	" 当打开vim且没有文件时自动打开NERDTree
	"autocmd StdinReadPre * let s:std_in=1
	"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
	" 只剩 NERDTree时自动关闭
	autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" 按F3自动显示或隐藏NERDTree区域
nnoremap <F3> :NERDTreeToggle<CR>


"""-----------------------------
""" airline
"""-----------------------------
let g:airline#extensions#tabline#enabled = 1			" 启用tabline
"let g:airline#extensions#tabline#buffer_nr_show = 1	" tabline显示编号
let g:airline#extensions#whitespace#enabled = 0 		" 禁用空格检查
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#show_coc_status = 1


"""-----------------------------
""" LeaderF
"""-----------------------------
let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_CacheDirectory = expand('~/.cache')
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_AutoResize = 1
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }

let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>fb'

function! InitLeaderFMap()
	nnoremap <leader>fc :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
	nnoremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
	nnoremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>

	nnoremap <leader>se :<C-U><C-R>=printf("Leaderf rg -s -w -e %s ", expand("<cword>"))<CR><CR>
	xnoremap <leader>ss :<C-U><C-R>=printf("Leaderf rg -s -F -e %s ", leaderf#Rg#visual())<CR><CR>
	nnoremap <leader>so :<C-U>Leaderf rg --recall<CR>
	nnoremap <leader>sa :<C-U>Leaderf rg -s<Space>
	nnoremap <leader>sA :<C-U>Leaderf rg<CR>
endfunction

let g:Lf_GtagsAutoGenerate = 0
"let $GTAGSFORCECPP = 1
let g:Lf_Gtagsconf = '%GTAGSCONF_PATH%'
let g:Lf_Gtagslabel = '%GTAGSLABEL_STR%'
"let $GTAGSCONF = '%GTAGSCONF_PATH%'
"let $GTAGSLABEL = '%GTAGSLABEL_STR%'
function! InitLeaderFGtagsMap()
	nnoremap <buffer> <leader>gg :<C-U><C-R>=printf("Leaderf! gtags --update")<CR><CR>
	nnoremap <buffer> <leader>gG :<C-U><C-R>=printf("Leaderf! gtags --remove")<CR><CR>
	nnoremap <buffer> <leader>gd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
	nnoremap <buffer> <leader>gr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
	nnoremap <buffer> <leader>ga :<C-U><C-R>=printf("Leaderf! gtags --by-context --auto-jump")<CR><CR>
	nnoremap <buffer> <leader>go :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
	nnoremap <buffer> <leader>gn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
	nnoremap <buffer> <leader>gp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
endfunction
augroup leaderf_auto_cmd
	au!
	autocmd FileType * call InitLeaderFMap()
	autocmd FileType * call InitLeaderFGtagsMap()
augroup END


"""-----------------------------
""" Vista
"""-----------------------------
let g:vista_default_executive = '%VISTA_EXE%'
nnoremap <F4> :Vista!!<CR>


"""-----------------------------
""" coc.nvim
"""-----------------------------
" 设置配置和data的主目录
let g:coc_config_home = '~/.vim/plug_home/coc.nvim/config'
let g:coc_data_home = '~/.vim/plug_home/coc.nvim/data'

" 设置片段跳转keymap
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<C-\>'

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction

"" 映射自动补全命令
function! InitCocAutoCompleteMap()
	" 按tab触发自动补全并选择下一项
	inoremap <silent><expr> <TAB>
				\ coc#pum#visible() ? coc#pum#next(1):
				\ <SID>check_back_space() ? "\<Tab>" :
				\ coc#refresh()

	" 触发补全后按ctrl-\选择上一项
	inoremap <expr><C-\> 
				\ coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" 按下回车后确认选中项
	inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
endfunction

"" 映射跳转命令
function! InitCocJumpToMap()
	nmap <silent> <leader>jd <Plug>(coc-definition)
	nmap <silent> <leader>jD <Plug>(coc-type-definition)
	nmap <silent> <leader>ji <Plug>(coc-implementation)
	nmap <silent> <leader>jr <Plug>(coc-references)
	nmap <silent> <leader>d] <Plug>(coc-diagnostic-next)
	nmap <silent> <leader>d[ <Plug>(coc-diagnostic-prev)
	nnoremap <leader>dd :CocDiagnostics<CR>
	nnoremap <leader>co :CocCommand clangd.switchSourceHeader<CR>
	nnoremap <leader>ca :CocCommand clangd.ast<CR>
	nnoremap <leader>cs :CocCommand clangd.symbolInfo<CR>
endfunction

augroup coc_auto_cmd
	au!
	autocmd FileType * call InitCocAutoCompleteMap()
	autocmd FileType * call InitCocJumpToMap()
augroup END


"""-----------------------------
""" c++ syntax highlighting
"""-----------------------------

let g:cpp_class_scope_highlight 			= 0
let g:cpp_member_variable_highlight 		= 0
let g:cpp_class_decl_highlight 				= 0
let g:cpp_experimental_template_highlight 	= 0


"""-----------------------------
""" vim-go
"""-----------------------------
 
let g:go_bin_path = expand('~/.vim/plug_home/vim-go/tools')
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"
 
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_methods = 1
let g:go_highlight_generate_tags = 1
