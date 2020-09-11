#! /bin/bash

SCRIPT_DIR=$(cd `dirname $0` && pwd)
cd $SCRIPT_DIR

### 定义辅助函数
function ask_continue_or_not()
{
	while true
	do
		echo "==> 是否继续？ [yn]: "
		read line leftover
		case ${line} in
			y* | Y*)
				break;;
			n* | N* | q* | Q* | e* | E*)
				echo "==> 已终止。"
				exit 1;;
		esac
	done
}

function ask_input_path()
{
	while true
	do
		retval=""
		echo "==> 请输入，如果为空表示不使用，将跳过该设置: "
		read line leftover
		local input_read=${line}

		if [ ! -n "$input_read" ]
		then
			echo "==> 已跳过。"
			break
		elif [ ! -f "$input_read" ]
		then
			echo "==> 路径未找到。"
		else
			retval=$input_read
			break
		fi
	done
}

function render_template()
{
	local target_file=$1
	local word_key=$2
	local word_value=$3
	local cmd="sed -i 's#${word_key}#${word_value}#g' ${target_file}"
	eval $cmd
}

### 检查一些工具命令是否存在
if ! type rg >/dev/null 2>&1
then
	echo "==> 未找到rg，LeaderF模糊搜索字符串功能将无法使用。"
	ask_continue_or_not
fi

if ! type ctags >/dev/null 2>&1
then
	echo "==> 未找到ctags，tagbar将无法使用。"
	ask_continue_or_not
fi

if ! type gtags >/dev/null 2>&1
then
	echo "==> 未找到gtags，LeaderF跳转tag将无法使用。"
	ask_continue_or_not
fi

USE_PYGMENTS=true
if ! python3 -c "import pygments" >/dev/null 2>&1
then
	echo "==> python3未找到pygments模块，LeaderF跳转tag将无法使用。"
	ask_continue_or_not
	USE_PYGMENTS=false
fi

### 询问设置变量
echo "==> 正在设置gtags.conf的路径（用于实现LeaderF跳转tag） ..."
ask_input_path
VAR_GTAGSCONF_PATH=$retval
if [ -n "$VAR_GTAGSCONF_PATH" ] && [ "$USE_PYGMENTS" == "true" ]
then
	VAR_GTAGSLABEL_STR=pygments
else
	VAR_GTAGSLABEL_STR=default
fi

echo "==> 正在设置clangd的路径（用于lsp，推荐9.0之后的版本） ..."
ask_input_path
VAR_CLANGD_PATH=$retval
if [ -n "$VAR_CLANGD_PATH" ]
then
	# 配了路径，启用clangd
	VAR_CLANGD_ENABLED=true
	# 启用了clangd的话，也启用vista的coc
	VAR_VISTA_EXE=coc
else
	VAR_CLANGD_ENABLED=false
	VAR_VISTA_EXE=ctags
fi

### 设置vimrc
if [ -f "vimrc" ]
then
	mv vimrc vimrc.old
	echo "==> 备份原有的vimrc。"
fi

cp templ/vimrc.tpl vimrc
render_template vimrc %GTAGSCONF_PATH% $VAR_GTAGSCONF_PATH
render_template vimrc %GTAGSLABEL_STR% $VAR_GTAGSLABEL_STR
render_template vimrc %VISTA_EXE% $VAR_VISTA_EXE
echo "==> 生成vimrc。"

### 设置coc.nvim
mkdir -p plug_home/coc.nvim/config
cp templ/coc-settings.json.tpl plug_home/coc.nvim/config/coc-settings.json
render_template plug_home/coc.nvim/config/coc-settings.json %COC_CLANGD_ENABLED% $VAR_CLANGD_ENABLED
render_template plug_home/coc.nvim/config/coc-settings.json %COC_CLANGD_PATH% $VAR_CLANGD_PATH
echo "==> 生成coc-settings.json。"

### 执行部分插件的额外安装
echo "==> 安装LeaderF ..."
cd $SCRIPT_DIR/pack/default/start/LeaderF/ && sh install.sh
if [ $? -ne 0 ]
then
	echo "==> 安装LeaderF失败"
	exit 1
fi

echo "==> 安装coc.nvim ..."
cd $SCRIPT_DIR/pack/default/start && tar xzvf ../../../archives/coc.nvim.tgz
if [ $? -ne 0 ]
then
	echo "==> 安装coc.nvim失败"
	exit 1
fi

echo "==> 安装成功。"
echo "==> 进入vim执行':helptags ALL'以刷新帮助文档。"
