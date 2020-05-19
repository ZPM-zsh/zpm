#!/usr/bin/env zsh

typeset -g _ZPM_PATH=""
typeset -g _ZPM_fpath=()

typeset -ag _ZPM_plugins_for_source
typeset -ag _ZPM_plugins_for_async_source
typeset -ag _ZPM_plugins_no_source

typeset -Ag _ZPM_file_for_source
typeset -Ag _ZPM_file_for_async_source

fpath+=("${_ZPM_DIR}/functions")

autoload -Uz                     \
  _ZPM_addfpath                  \
  _ZPM_addpath                   \
  _ZPM_async_source              \
  _ZPM_Background_Initialization \
  _ZPM_clean                     \
  _ZPM_compile                   \
  _ZPM_get_plugin_basename       \
  _ZPM_get_plugin_file_path      \
  _ZPM_get_plugin_name           \
  _ZPM_get_plugin_path           \
  _ZPM_initialize_plugins        \
  _ZPM_load_plugin               \
  _ZPM_log                       \
  _ZPM_no_source                 \
  _ZPM_source                    \
  _ZPM_upgrade

function zpm() {
  if [[ "$1" == 'load' ]]; then
    shift
    _ZPM_initialize_plugins "$@"
    return 0
  fi

  if [[ "$1" == 'if' ]]; then
    if check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi

  if [[ "$1" == 'if-not' ]]; then
    if ! check-if "$2"; then
      shift 2
      zpm "$@"
    fi
    return 0
  fi

  if [[ "$1" == 'u' || "$1" == 'up' || "$1" == 'upgrade' ]]; then
    shift
    _ZPM_upgrade "$@"
    return 0
  fi

  if [[ "$1" == 'c' || "$1" == 'cl' || "$1" == 'clean' ]]; then
    shift
    _ZPM_clean
    return 0
  fi

  if is-callable "zpm-$1"; then
    local call_fn=$1
    shift
    "zpm-${call_fn}" $@
    return 0
  fi

  echo 'Unknown command `'"$@"'`, treat as `zpm load '"$@"'`'
  _ZPM_initialize_plugins "$@"
}
