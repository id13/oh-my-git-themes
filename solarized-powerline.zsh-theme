# background color
BG_COLOR_BASE03=%K{8}
BG_COLOR_BASE02=%K{0}
BG_COLOR_BASE01=%K{10}
BG_COLOR_BASE00=%K{11}
BG_COLOR_BASE0=%K{12}
BG_COLOR_BASE1=%K{14}
BG_COLOR_BASE2=%K{7}
BG_COLOR_BASE3=%K{15}
BG_COLOR_YELLOW=%K{3}
BG_COLOR_ORANGE=%K{1}
BG_COLOR_RED=%K{9}
BG_COLOR_MAGENTA=%K{5}
BG_COLOR_VIOLET=%K{13}
BG_COLOR_BLUE=%K{4}
BG_COLOR_CYAN=%K{6}
BG_COLOR_GREEN=%K{2}

# foreground color
FG_COLOR_BASE03=%F{8}
FG_COLOR_BASE02=%F{0}
FG_COLOR_BASE01=%F{10}
FG_COLOR_BASE00=%F{11}
FG_COLOR_BASE0=%F{12}
FG_COLOR_BASE1=%F{14}
FG_COLOR_BASE2=%F{7}
FG_COLOR_BASE3=%F{15}
FG_COLOR_YELLOW=%F{3}
FG_COLOR_ORANGE=%F{9}
FG_COLOR_RED=%F{1}
FG_COLOR_MAGENTA=%F{5}
FG_COLOR_VIOLET=%F{13}
FG_COLOR_BLUE=%F{4}
FG_COLOR_CYAN=%F{6}
FG_COLOR_GREEN=%F{2}

: ${omg_ungit_prompt:=$PS1}
: ${omg_is_a_git_repo_symbol:='❤'}
: ${omg_has_untracked_files_symbol:='●'}
: ${omg_has_adds_symbol:='+'}
: ${omg_has_deletions_symbol:='-'}
: ${omg_has_cached_deletions_symbol:='(-)'}
: ${omg_has_modifications_symbol:='✎'}
: ${omg_has_cached_modifications_symbol:='(✎)'}
: ${omg_ready_to_commit_symbol:='→'}           
: ${omg_is_on_a_tag_symbol:='⌫'}                
: ${omg_detached_symbol:='∤'}
: ${omg_can_fast_forward_symbol:='»'}
: ${omg_has_diverged_symbol:='Ⴤ'}              
: ${omg_not_tracked_branch_symbol:='X'}
: ${omg_rebase_tracking_branch_symbol:='↶'}    
: ${omg_merge_tracking_branch_symbol:='>'}     
: ${omg_should_push_symbol:='↑'}               
: ${omg_has_stashes_symbol:='≣'}
: ${omg_has_action_in_progress_symbol:='⚡'}    

autoload -U colors && colors


PROMPT='$(build_prompt)'
RPROMPT='${RETURN_CODE}'

function enrich_append {
    local flag=$1
    local symbol=$2
    local color=${3:-$omg_default_color_on}
    if [[ $flag == false ]]; then symbol=' '; fi

    echo -n "${color}${symbol}  "
}

function custom_build_prompt {
    local enabled=${1}
    local current_commit_hash=${2}
    local is_a_git_repo=${3}
    local current_branch=$4
    local detached=${5}
    local just_init=${6}
    local has_upstream=${7}
    local has_modifications=${8}
    local has_modifications_cached=${9}
    local has_adds=${10}
    local has_deletions=${11}
    local has_deletions_cached=${12}
    local has_untracked_files=${13}
    local ready_to_commit=${14}
    local tag_at_current_commit=${15}
    local is_on_a_tag=${16}
    local has_upstream=${17}
    local commits_ahead=${18}
    local commits_behind=${19}
    local has_diverged=${20}
    local should_push=${21}
    local will_rebase=${22}
    local has_stashes=${23}
    local action=${24}

    local black_on_white="%K{white}%F{black}"
    local yellow_on_white="%K{white}%F{yellow}"
    local red_on_white="%K{white}%F{red}"
    local red_on_black="%K{black}%F{red}"
    local black_on_red="${FG_COLOR_ORANGE}${BG_COLOR_BASE02}"
    local white_on_red="%${FG_COLOR_BASE3}${BG_COLOR_BASE02}"
    local yellow_on_red="%K{red}%F{yellow}"
    # reset color
    local RESET_COLOR=%f%k%b
    local RESET_COLOR_FG=%f%k
    local RESET_FG=%{$RESET_COLOR_FG%}
    local RESET=%{$RESET_COLOR%}
    local RETURN_CODE="%(?..$FG_COLOR_RED%? ↵$RESET)"
    local ARROW_SYMBOL=''
    local ZSH_TIME=%D{%H:%M}
    local PADDING=''

    # Flags
    local omg_default_color_on="${black_on_white}"

    local current_path="%2~"

    # a new line before prompt
    local prompt="
    "
    # username@hostname

    prompt+="${FG_COLOR_BLUE}${BG_COLOR_BASE3}${PADDING}%n${FG_COLOR_GREEN}${BG_COLOR_BASE3}@${FG_COLOR_VIOLET}${BG_COLOR_BASE3}%m"

      PADDING=' '

    # time

      prompt="${prompt}${FG_COLOR_MAGENTA}${BG_COLOR_BASE3}${PADDING}[${ZSH_TIME}]"

    if [[ $is_a_git_repo == true ]]; then
        # on filesystem
        prompt="${prompt}${FG_COLOR_BASE3}${BG_COLOR_BASE01}${ARROW_SYMBOL}"
        prompt="${prompt}${FG_COLOR_BASE3}${BG_COLOR_BASE01}${current_path}"
        prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${FG_COLOR_BASE3}${BG_COLOR_BASE01}")
        prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${FG_COLOR_YELLOW}${BG_COLOR_BASE01}")

        prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${FG_COLOR_RED}${BG_COLOR_BASE01}")
        prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${FG_COLOR_RED}${BG_COLOR_BASE01}")
        prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${FG_COLOR_RED}${BG_COLOR_BASE01}")
        

        # ready
        prompt+=$(enrich_append $has_adds $omg_has_adds_symbol "${FG_COLOR_RED}${BG_COLOR_BASE01}")
        prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${FG_COLOR_BLUE}${BG_COLOR_BASE01}")
        prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${FG_COLOR_BLUE}${BG_COLOR_BASE01}")
        
        # next operation

        prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${FG_COLOR_RED}${BG_COLOR_BASE01}")
        prompt+=$(enrich_append $action "${omg_has_action_in_progress_symbol} $action" "${FG_COLOR_RED}${BG_COLOR_BASE01}")

        # where

        prompt="${prompt}${FG_COLOR_BASE1}${BG_COLOR_BASE02}  ${black_on_red}"
        if [[ $detached == true ]]; then
            prompt+=$(enrich_append $detached $omg_detached_symbol "${white_on_red}")
            prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${black_on_red}")
        else            
            if [[ $has_upstream == false ]]; then
                prompt+=$(enrich_append true "-- ${omg_not_tracked_branch_symbol}  --  (${current_branch})" "${black_on_red}")
            else
                if [[ $will_rebase == true ]]; then
                    local type_of_upstream=$omg_rebase_tracking_branch_symbol
                else
                    local type_of_upstream=$omg_merge_tracking_branch_symbol
                fi

                if [[ $has_diverged == true ]]; then
                    prompt+=$(enrich_append true "-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead}" "${white_on_red}")
                else
                    if [[ $commits_behind -gt 0 ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} %F{white}${omg_can_fast_forward_symbol}%F{white} --" "${black_on_red}")
                    fi
                    if [[ $commits_ahead -gt 0 ]]; then
                        prompt+=$(enrich_append true "-- %F{white}${omg_should_push_symbol}%F{white}  +${commits_ahead}" "${black_on_red}")
                    fi
                    if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                         prompt+=$(enrich_append true " --   -- " "${black_on_red}")
                    fi
                    
                fi
                prompt+=$(enrich_append true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})" "${black_on_red}")
            fi
        fi
        prompt+=$(enrich_append ${is_on_a_tag} "${omg_is_on_a_tag_symbol} ${tag_at_current_commit}" "${black_on_red}")
        prompt="${prompt} %E
        ${RESET}${FG_COLOR_BASE02}${ARROW_SYMBOL}"
    else
      prompt="${prompt}${FG_COLOR_BASE3}${BG_COLOR_BASE02}${ARROW_SYMBOL}"
      prompt="${prompt}${FG_COLOR_BASE3}${BG_COLOR_BASE02}${current_path}${FG_COLOR_BASE02}${ARROW_SYMBOL}"
        
    fi
    prompt+="${RESET}"
    echo "${prompt}"
}
