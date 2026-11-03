# -- PATH -- #
# typeset -U で重複を自動的に除去する
typeset -U path PATH
path=(
    $HOME/.local/bin
    $HOME/local/bin
    $HOME/.scripts
    $HOME/.cargo/bin
    $HOME/.deno/bin
    /usr/local/sbin
    $path
)
export PATH

# -- C and C++ -- #
export LD_LIBRARY_PATH=$HOME/local/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export C_INCLUDE_PATH=$HOME/local/include${C_INCLUDE_PATH:+:$C_INCLUDE_PATH}
export CPLUS_INCLUDE_PATH=$HOME/local/include${CPLUS_INCLUDE_PATH:+:$CPLUS_INCLUDE_PATH}
