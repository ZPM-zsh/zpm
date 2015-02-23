#!/usr/bin/env zsh

if [[ -z $plugins ]]; then
    plugins=( );
fi

function ZPM_init(){

    if [[ -z $COLORS ]]; then
        export COLORS=true
    fi
    
    if [[ -z $MANPATH ]]; then
        export MANPATH=$(manpath)
    fi
    
    
    if [[ -z $ZPM ]]; then
        ZPM=true
    
        if [[ -z $MANPATH ]]; then
            export ZSH_COMPDUMP=$HOME/.zcompdump
        fi
    
        if [[ -z $ZPM_DIR ]]; then
            export ZPM_DIR=$HOME/.zpm
        fi
    
        if [ -z "$HISTFILE" ]; then
            HISTFILE=$HOME/.zsh_history
        fi
    
        HISTSIZE=999
        SAVEHIST=999
    
        if [[ "$COLORS" == "true" ]]; then
            autoload -U colors && colors
        fi
    
        # Some modules
        setopt prompt_subst
        zstyle ':completion::complete:*' use-cache 1
        zstyle ':completion::complete:*' cache-path ~/.cache/zsh
        autoload -U compinit && compinit
    
    
    
    
        for plugin ($plugins); do
            if [[ $plugin == */* ]]; then
                if [[ ! -d $ZPM_DIR/custom/${plugin##*\/} ]]; then
                    echo "Installing plugin from github"
                    git clone --recursive "https://github.com/"$plugin".git" $ZPM_DIR/custom/${plugin##*\/}
                fi
            fi
        done
    
    
    
        for plugin ($plugins); do
            if [[ -d $ZPM_DIR/plugins/$plugin ]]; then
                fpath=( $ZPM_DIR/plugins/$plugin $fpath )
            else
                if [[ $plugin == */* ]] && [[ -d $ZPM_DIR/custom/${plugin##*\/} ]]; then
                    fpath=( $ZPM_DIR/custom/${plugin##*\/} $fpath )
                fi
            fi
        done
    
    
        for plugin ($plugins); do
            if [[ -d $ZPM_DIR/plugins/$plugin/bin ]]; then
                path=( $ZPM_DIR/plugins/$plugin/bin $path )
            else
                if [[ $plugin == */* ]] && [[ -d $ZPM_DIR/custom/${plugin##*\/}/bin ]]; then
                    path=( $ZPM_DIR/custom/${plugin##*\/}/bin $path )
                fi
            fi
        done
    
        for plugin ($plugins); do
            if [[ -d $ZPM_DIR/plugins/$plugin/man ]]; then
                manpath=( $ZPM_DIR/plugins/$plugin/man $manpath )
            else
                if [[ $plugin == */* ]] && [[ -d $ZPM_DIR/custom/${plugin##*\/}/man ]]; then
                    manpath=( $ZPM_DIR/custom/${plugin##*\/}/man $manpath )
                fi
            fi
        done
    
        for plugin ($plugins); do
            if [[ -f $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh ]]; then
                source $ZPM_DIR/plugins/$plugin/$plugin.plugin.zsh 
            else
                if [[ $plugin == */* ]] && [[ -f $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/}.plugin.zsh ]]; then
                    source $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/}.plugin.zsh
                fi
            fi
        done
    
        for plugin ($plugins); do
            if [[ $plugin == *.plugin.zsh ]]; then
                if [[ -f $ZPM_DIR/plugins/$plugin/$plugin ]]; then
                    source $ZPM_DIR/plugins/$plugin/$plugin 
                else
                    if [[ $plugin == */* ]] && [[ -f $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/} ]]; then
                        source $ZPM_DIR/custom/${plugin##*\/}/${plugin##*\/}
                    fi
                fi
            fi
        done



        unset plugin
        compinit
    
    fi

}

function Plug(){
    plugins+=( $@ )
}


function zshrc-install(){
    scp ~/.zshrc $1:.zshrc 
}

