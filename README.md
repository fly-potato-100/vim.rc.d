自用VIM插件环境
-----------------

*插件管理使用VIM8自带的packages管理模式，无需第三方插件管理器。*

## 环境要求

* vim >= 8.2(feature +python3): 异步比较完善，支持更新的插件。
* python >= 3.6: 供插件使用。
* node >= v12.18.3: 供插件使用

## 安装依赖

* ripgrep: 实现模糊查找。
* universal-ctags: tagbar、LeaderF都会用到。
* gnu-global: 包含的gtags用来在LeaderF中查找引用。
* pygments: 供gtags使用。
* clangd: 作为lsp使用。

## 安装步骤

1. 安装上述的依赖环境。
2. 使用`git clone --recursive`完整克隆本库。
3. 执行`./setup.sh`，根据提示完成安装。
4. 将完整目录置于`~/.vim`，删掉`~/.vimrc`。
