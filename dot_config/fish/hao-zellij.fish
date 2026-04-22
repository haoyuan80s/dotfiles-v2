set -x zellij_fisrt_prompt_flag 1

function zellij_tab_name_update -v PWD
    if set -q ZELLIJ
        set -l pane_name (prompt_pwd)
        zellij action rename-tab "$pane_name"
        set -gx ZELLIJ_PANE_NAME "$pane_name"
        update_zellij_session_name
    end
end

function zellij_tab_name_update0 -e fish_prompt
  if set -q ZELLIJ && test $zellij_fisrt_prompt_flag -eq 1
    set zellij_fisrt_prompt_flag 0
    set -l pane_name (prompt_pwd)
    zellij action rename-tab "$pane_name"
    set -gx ZELLIJ_PANE_NAME "$pane_name"
    update_zellij_session_name
  end
end

function zillij_jump_to --argument subname
  for name in (zellij action query-tab-names)
    if string match -q -r "$subname" $name
      zellij action go-to-tab-name $name
      return
    end
  end
end


set -x last_zellij_session_name ""
function update_zellij_session_name
  if set -q ZELLIJ_SESSION_NAME
    if not string match -q $ZELLIJ_SESSION_NAME $last_zellij_session_name
      echo $ZELLIJ_SESSION_NAME > ~/.zellij_session_name
      set -x last_zellij_session_name $ZELLIJ_SESSION_NAME
    end
  end
end

if test "$TERM_PROGRAM" != "vscode" && not set -q ZELLIJ
    zellij attach -c auto
    set -gx ZELLIJ 1
end
