# -- git completion -- #
# _git (zsh 用ラッパー) と git-completion.bash を ~/.zsh から読み込む。
# compinit は .zshrc の最後で一度だけ実行する。
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# プロンプトは sheldon で読み込む pure が git の状態を表示する
