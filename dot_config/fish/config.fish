# vi keymap trick:
# e.g. rlwrap -a -t dumb redis-cli


source ~/.config/fish/env.fish
source ~/.config/fish/option.fish
set fish_vi_force_cursor true
set fish_cursor_visual      block
set fish_cursor_replace_one underscore
set fish_cursor_insert      line
set fish_cursor_default     block
set fish_greeting ""
fish_vi_key_bindings

function z
   set x (zoxide query -i "")
   if test -n "$x"
     commandline -r -- "$x"
   end
end

bind -M insert \cf forward-char
bind -M insert \cb backward-char
bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
fzf_configure_bindings --git_log="" --git_status="" --variables="" --directory="" --processes="" --history=""
# for mode in default insert visual
#   bind -M $mode \r -m default execute
# end
bind -M default sz zoxide-history-widget-accept
alias cdr=zoxide-history-widget-accept
bind -M insert \cr '_fzf_search_history'
# bind -M insert \csh zoxide-history-widget-accept
# bind -M insert \csv '_fzf_search_variables'
# bind -M insert \csd '_fzf_search_directory'
# bind -M insert \csp '_fzf_search_processes'

function zoxide_copy_path
    zoxide query --interactive | tr -d '\n' | pbcopy
    commandline -f repaint
end

bind -M default sh _fzf_search_history
bind -M default sv _fzf_search_variables
bind -M default sz zoxide_copy_path
bind -M default sd _fzf_search_directory
bind -M default sp _fzf_search_processes
bind -M default gk 'zj kill-session auto'
bind -M default ga 'zj a -c auto'
bind -M default Y fish_clipboard_copy


alias whisper="/Users/haoyuan/Projects/cpp/whisper.cpp/build/bin/whisper-cli -m /Users/haoyuan/Projects/cpp/whisper.cpp/models/ggml-base.en.bin"
alias c="cursor-agent"
alias ai="gh copilot suggest -t shell"
alias aie="gh copilot explain"
alias ports="lsof -i -P -n"
alias myip='ifconfig en0 | grep inet | grep -v inet6 | cut -d" " -f2'
alias mkdir="mkdir -p";
alias reload="source ~/.config/fish/config.fish"
# alias da="direnv allow";
alias zj="zellij";
alias k="kubectl";
alias kn="kubens";
alias kx="kubectx";
alias cg="cargo";
alias wtc="wt step commit";
alias tf="terraform";
alias ec="emacsclient --create-frame --alternate-editor=''";
alias v="nvim";
alias lg="lazygit";
alias ld="lazydocker";
alias l="eza --icons";
alias ls="eza --icons";
alias ll="eza --icons -l";
alias lll="eza --icons -la";
alias yz="yazi"
alias du="dust";
alias cat="bat";
alias vs="code-fb";
alias idris2="rlwrap idris2";
alias x="xargs ";
alias evcxr="evcxr --edit-mode vi";
# alias j='just --shell fish --shell-arg -c'
alias j='just'
alias mp=mprocs
alias sound-bulu="afplay /System/Library/Sounds/Funk.aiff"
alias sound-ding="afplay /System/Library/Sounds/Ping.aiff"
alias sound-jing="afplay /System/Library/Sounds/Glass.aiff"

alias jupkill='ssh spark "pkill -f jupyter"'
alias jupstart='ssh -L 8888:127.0.0.1:8888 spark "pkill -f jupyter; cd /home/haoyuan/Projects/python && uv run jupyter lab --no-browser --ip=127.0.0.1 --port=8888 --no-daemon"'


abbr -a ce "gh copilot explain"
abbr -a cs "gh copilot suggest"
abbr -a fda "fd --hidden --no-ignore"
abbr -a rga "rg --no-ignore --hidden"
abbr -a lt "l --tree"
abbr -a llt "ll --tree"
abbr -a lllt "lll --tree"
abbr -a zja "zj a -c do-it";
abbr -a kaf "k apply -f"
abbr -a kdf "k delete -f"
abbr -a nb "jupyter notebook"
abbr -a cgt "cg t -- --nocapture"


if set -q ZELLIJ
  source ~/.config/fish/hao-zellij.fish
end

# https://github.com/mozilla/sccache/issues/342
ulimit -n 10240


source ~/.config/fish/keys.fish
source ~/.config/fish/hao-linux.fish

starship init fish | source
zoxide init fish --cmd cd | source
source ~/.config/fish/hao-misc.fish

# function condaconda
#   source /opt/homebrew/Caskroom/miniforge/base/etc/fish/conf.d/conda.fish
#   fish_add_path "/opt/homebrew/Caskroom/miniforge/base/bin"
# end

# # set -x https_proxy "http://user:pwd@127.0.0.1:1087"

# set -gx WASMTIME_HOME "$HOME/.wasmtime"

# string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH

# if not pgrep -x kanata > /dev/null
#     nohup sudo kanata -c $HOME/.config/kanata.kbd >/tmp/kanata.log 2>&1 &
# end


# fish_add_path /opt/homebrew/opt/openjdk/bin

# set -gx CPPFLAGS "-I/opt/homebrew/opt/openjdk/include"
# Added by Antigravity
fish_add_path /usr/local/cuda/bin/


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
