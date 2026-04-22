function zellij_edit_clipboard
    open -a "Alacritty"

    set -l query $argv[1]

    if test -z "$query"
        set query "txt"
    end

    # 3. Determine filename logic
    set -l f
    if string match -q "*.*" -- "$query"
        set f "/tmp/$query"
    else
        set f "/tmp/tmp.$query"
    end

    rm -f $f
    xclip -selection clipboard -o > $f

    echo "
layout {
   pane size=1 borderless=true {
       plugin location=\"zellij:compact-bar\"
   }
   pane {
        cwd \"/tmp/\"
        command \"nvim\"
        args \"$f\"
        close_on_exit true
    }
}
" > $HOME/.config/zellij/layouts/tmp-layout.kdl

    set -x ZELLIJ_SESSION_NAME (cat ~/.zellij_session_name)
    zellij action new-tab -l tmp-layout
end

