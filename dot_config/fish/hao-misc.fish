function zoxide-history-widget-accept
   set -l res (zoxide query -i) # interactive zoxide query
   set -U LBUFFER (echo $res | sed 's/"/\\"/g') # push the result to the input buffer
   commandline --current-token --replace -- (string escape -- $res | string join ' ')
   commandline --function repaint
end

function fdf
    set path $argv[1]
    set dir (fd -td $path | fzf)

    if test -n "$dir"
        commandline -r -- "$dir"
    end
end


# function fill-last-output
#   commandline --replace (echo (eval $history[1]))
#   history delete --exact --case-sensitive rr
# end

# function mise-pyenv
#   echo "\
# [tools]
# python = \"3.12\" # [optional] will be used for the venv
#
# [env]
# _.python.venv = { path = \".venv\", create = true }
# " > .mise.toml
# end

function mise-pyenv
  set python_version $argv[1]

  if test -z "$python_version"
    echo "Please provide a Python version."
    return 1
  end

  echo "\
[tools]
python = \"$python_version\" # [optional] will be used for the venv

[env]
_.python.venv = { path = \".venv\", create = true }
" > .mise.toml

  mise trust
end


function pq
  psql $DATABASE_URL -c "$argv[1]" $argv[2] $argv[3] $argv[4] $argv[5]
end


# function set_socks_proxy
#   set -gx http_proxy socks5://127.0.0.1:1086
#   set -gx https_proxy socks5://127.0.0.1:1086
# end
#
# function set_http_proxy
#   set -gx http_proxy http://127.0.0.1:1087
#   set -gx https_proxy http://127.0.0.1:1087
# end
#
# function unset_proxy
#   set -e http_proxy
#   set -e https_proxy
# end

function open-ai
    set -l target $argv[1]
    
    # Validate argument
    if test -z "$target"
        echo "Usage: open-ai [claude|chatgpt|google|excalidraw]"
        return 1
    end
    
    # Set URL and domain based on argument
    switch $target
        case excalidraw
            set url "https://excalidraw.com"
            set domain "excalidraw.com"
        case google
            set url "https://aistudio.google.com"
            set domain "aistudio.google.com"
        case claude
            set url "https://claude.ai"
            set domain "claude.ai"
        case chatgpt
            set url "https://chat.openai.com"
            set domain1 "chat.openai.com"
            set domain2 "chatgpt.com"
        case '*'
            echo "Invalid argument. Use 'claude' or 'chatgpt' or 'google'."
            return 1
    end
    
    # Build AppleScript
    set -l script '
tell application "Google Chrome"
  set found to false
  set winCount to count of windows
  repeat with wi from 1 to winCount
    set tabCount to number of tabs in window wi
    repeat with ti from 1 to tabCount
      set theURL to URL of tab ti of window wi'
    
    if test "$target" = "chatgpt"
        set script "$script"'
      if theURL contains "chat.openai.com" or theURL contains "chatgpt.com" then'
    else
        set script "$script"'
      if theURL contains "'$domain'" then'
    end
    
    set script "$script"'
        set active tab index of window wi to ti
        set index of window wi to 1
        activate
        set found to true
        exit repeat
      end if
    end repeat
    if found then exit repeat
  end repeat
  if not found then
    if winCount = 0 then make new window
    set newTab to make new tab at end of tabs of front window with properties {URL:"'$url'"}
    set active tab index of front window to (index of newTab)
    activate
  end if
end tell
'
    
    printf "%s\n" $script | osascript -
end

function open-daily-note
  open -a Alacritty
  set offset (math "$argv[1]" 2>/dev/null; or echo 0)
  echo $offset
  if test $offset -ge 0
       set offset (echo +$offset)
  end
  set date (date -v{$offset}d +%F)
  set -x ZELLIJ_SESSION_NAME (cat ~/.zellij_session_name)
  zellij edit -f "/Users/haoyuan/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/Journal/$date.md"
end

function open-todo-note
  open -a Alacritty
  zellij edit -f "/Users/haoyuan/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/todo.md"
end

function open-main-note
  open -a Alacritty
  zellij edit -f "/Users/haoyuan/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/main.md"
end


function zellij-edit-cursor
    # Create a temporary file
    set tmpfile (mktemp)
    
    # Open the temp file in a new Zellij pane
    zellij run --floating -- $EDITOR $tmpfile
    
    # After editing, pipe the content to cursor-agent
    cat $tmpfile | cursor-agent
    
    # Clean up the temporary file
    rm $tmpfile
end

function s3upload
    if test (count $argv) -ne 1
        echo "Usage: s3upload <local-file>"
        return 1
    end

    set file $argv[1]
    set base (basename $file)

    echo "📤 Uploading $file to s3://hao-tmp80/$base ..."
    aws s3 cp $file s3://hao-tmp80/$base

    echo "🔗 Generating presigned URL (1 day)..."
    aws s3 presign s3://hao-tmp80/$base --region us-east-1 --expires-in 86400
end

function v-spark --description 'Open Neovide on spark server'
    env REMOTE_DIR=$argv[1] SERVER_NAME=$argv[2] neovide --wsl --neovim-bin spark-nvim.sh
end

function mytab --argument site
    # Search for the site name provided as an argument
    set -l tab_id (brotab list | grep "$site" | cut -f1 | head -n1)

    if test -n "$tab_id"
        brotab activate $tab_id
    else
        # Construct the URL (assumes .com, but you can adjust)
        firefox "$site"
    end
end

function pastepng
    set path "$HOME/notes/attachments/$(date +%Y%m%d_%H%M%S).png"
    mkdir -p (dirname "$path")

    if not pngpaste "$path"
        echo "❌ No image found in clipboard, or pngpaste failed."
        rm -f "$path"
        afplay /System/Library/Sounds/Basso.aiff &
        return 1
    end

    if not test -s "$path"
        echo "❌ pngpaste created an empty file."
        rm -f "$path"
        afplay /System/Library/Sounds/Basso.aiff &
        return 1
    end

    printf "%s" "$path" | pbcopy

    afplay /System/Library/Sounds/Glass.aiff &
    echo "$path"
end
