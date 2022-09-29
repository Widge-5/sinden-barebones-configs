#!/usr/bin/env bash

# This file is not part of The RetroPie Project
#

rp_module_id="lr-mess-StormedBubbles"
rp_module_desc="MESS emulator - MESS Port for libretro"
rp_module_help="see wiki for detailed explanation"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/mame/master/COPYING"
rp_module_repo="git https://github.com/StormedBubbles/mame.git hacks"
rp_module_section="exp"
rp_module_flags=""

function _get_params_lr-mess-StormedBubbles() {
    local params=(OSD=retro RETRO=1 NOWERROR=1 OS=linux TARGETOS=linux CONFIG=libretro NO_USE_MIDI=1 TARGET=mame PYTHON_EXECUTABLE=python3)
    isPlatform "64bit" && params+=(PTR64=1)
    echo "${params[@]}"
}


function depends_lr-mess-StormedBubbles() {
    depends_lr-mame
}

function sources_lr-mess-StormedBubbles() {
    gitPullOrClone
}

function build_lr-mess-StormedBubbles() {
    rpSwap on 4096
    local params=($(_get_params_lr-mess-StormedBubbles) SUBTARGET=mess)
    make clean
    make "${params[@]}"
    rpSwap off
    md_ret_require="$md_build/mamemess_libretro.so"
}

function install_lr-mess-StormedBubbles() {
    md_ret_files=(
        'COPYING'
        'mamemess_libretro.so'
        'README.md'
        'hash'
    )
}

function configure_lr-mess-StormedBubbles() {
    local module="$1"
    [[ -z "$module" ]] && module="mamemess_libretro.so"

    local system
    for system in arcade mame mame-libretro nes gb coleco arcadia crvision; do
        mkRomDir "$system"
        defaultRAConfig "$system"
        addEmulator 0 "$md_id" "$system" "$md_inst/$module"
        addSystem "$system"
    done

    [[ "$md_mode" == "remove" ]] && return

    setRetroArchCoreOption "mame_softlists_enable" "enabled"
    setRetroArchCoreOption "mame_softlists_auto_media" "enabled"
    setRetroArchCoreOption "mame_boot_from_cli" "enabled"

    mkUserDir "$biosdir/mame"
    cp -rv "$md_inst/hash" "$biosdir/mame/"
    chown -R $user:$user "$biosdir/mame"
}