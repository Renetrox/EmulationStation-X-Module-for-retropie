#!/usr/bin/env bash

# ============================================================
#  EmulationStation-X (ES-X) for RetroPie
#  Experimental fork with .ini language support + theme system
#  by Renetrox
#
#  This module REPLACES the standard EmulationStation.
#  Installs ES-X + its language files + default ES-X themes.
# ============================================================

rp_module_id="emulationstation-es-x"
rp_module_desc="EmulationStation-X (ES-X) - Experimental fork with .ini language and theme enhancements (replaces standard EmulationStation)"
rp_module_help="After installing, ES-X becomes the main frontend. Includes automatic language .ini installation and default ES-X themes."
rp_module_section="exp"
rp_module_flags="frontend"

# License (same as upstream ES unless modified)
rp_module_licence="MIT https://github.com/Aloshi/EmulationStation/blob/master/LICENSE"

# ES-X repository
rp_module_repo="git https://github.com/Renetrox/EmulationStation-X main"

# -- Link to base EmulationStation build system ---------------------

function _update_hook_emulationstation-es-x() { _update_hook_emulationstation; }
function depends_emulationstation-es-x()      { depends_emulationstation; }
function sources_emulationstation-es-x()      { sources_emulationstation; }
function build_emulationstation-es-x()        { build_emulationstation; }
function install_emulationstation-es-x()      { install_emulationstation; }

# -------------------------------------------------------------------

function configure_emulationstation-es-x() {
    # ============================================================
    # 1) Remove the standard EmulationStation to avoid conflicts
    # ============================================================
    echo "Removing original EmulationStation..."
    rp_callModule "emulationstation" remove

    # ============================================================
    # 2) Configure ES-X using standard ES logic
    # ============================================================
    echo "Configuring ES-X..."
    configure_emulationstation

    # ============================================================
    # 3) Install .ini language files
    # ============================================================
    echo "Installing ES-X language files..."

    local lang_src=""
    local lang_dst="$home/.emulationstation/lang"

    if [[ -d "$md_build/lang" ]]; then
        lang_src="$md_build/lang"
    elif [[ -d "$md_inst/lang" ]]; then
        lang_src="$md_inst/lang"
    elif [[ -d "$md_inst/resources/lang" ]]; then
        lang_src="$md_inst/resources/lang"
    fi

    if [[ -n "$lang_src" ]]; then
        mkUserDir "$lang_dst"
        cp -v "$lang_src"/* "$lang_dst"/ 2>/dev/null
        chown -R "$user:$user" "$lang_dst"
        echo "Language files installed at $lang_dst"
    else
        echo "WARNING: No 'lang' folder found for ES-X."
    fi

    # ============================================================
    # 4) Install ES-X themes (ArtBook, Mini, Alekfull NX)
    # ============================================================
    echo "Installing ES-X themes..."
    local themes_dir="$home/.emulationstation/themes"
    mkUserDir "$themes_dir"

    install_esx_theme() {
        local repo="$1"
        local folder="$2"
        local target="$themes_dir/$folder"

        if [[ -d "$target/.git" ]]; then
            echo "Updating theme: $folder"
            git -C "$target" pull --ff-only
        elif [[ -d "$target" ]]; then
            echo "Folder exists but is not a git repo: $folder — skipping."
        else
            echo "Cloning theme: $folder"
            git clone "$repo" "$target"
            chown -R "$user:$user" "$target"
        fi
    }

    install_esx_theme "https://github.com/Renetrox/art-book-next-ESX" "art-book-next-ESX"
    install_esx_theme "https://github.com/Renetrox/Alekfull-nx-retropie" "Alekfull-nx-retropie"
    install_esx_theme "https://github.com/Renetrox/Mini" "Mini"

    echo "Themes installed."

    # ============================================================
    # 5) Apply a default theme ON FIRST INSTALL ONLY
    #    Default: Alekfull-nx-retropie (simple + theme.ini)
    # ============================================================
    local es_settings="$home/.emulationstation/es_settings.cfg"

    if [[ ! -f "$es_settings" ]] || ! grep -q "<string name=\"ThemeSet\"" "$es_settings"; then
        echo "Applying default ES-X sample theme: Alekfull-nx-retropie"
        
        mkUserDir "$(dirname "$es_settings")"
        touch "$es_settings"

        if grep -q "<string name=\"ThemeSet\"" "$es_settings"; then
            sed -i 's|<string name="ThemeSet".*|<string name="ThemeSet" value="Alekfull-nx-retropie" />|' "$es_settings"
        else
            echo '<string name="ThemeSet" value="Alekfull-nx-retropie" />' >> "$es_settings"
        fi
        
        chown "$user:$user" "$es_settings"
    else
        echo "Theme already configured by user — not changing."
    fi

    echo "ES-X configuration complete."
}

function remove_emulationstation-es-x() { remove_emulationstation; }
function gui_emulationstation-es-x()    { gui_emulationstation; }
