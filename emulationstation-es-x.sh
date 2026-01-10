#!/usr/bin/env bash

# ============================================================
#  EmulationStation-X (ES-X) for RetroPie
#  Experimental fork with .ini language support + theme system
#  by Renetrox
#
#  This module REPLACES the standard EmulationStation.
#  Installs ES-X + its language files + default ES-X themes.
#  Also installs ES-X theme browser previews (esx/theme-previews).
# ============================================================

rp_module_id="emulationstation-es-x"
rp_module_desc="EmulationStation-X (ES-X) - Experimental fork with .ini language and theme enhancements (replaces standard EmulationStation)"
rp_module_help="After installing, ES-X becomes the main frontend. Includes automatic language .ini installation, Theme Browser previews, and default ES-X themes."
rp_module_section="exp"
rp_module_flags="frontend"

rp_module_licence="MIT https://github.com/Aloshi/EmulationStation/blob/master/LICENSE"

# ES-X repository
rp_module_repo="git https://github.com/Renetrox/EmulationStation-X main"

# ------------------------------------------------------------
# Link to base EmulationStation build system
# ------------------------------------------------------------
function _update_hook_emulationstation-es-x() { _update_hook_emulationstation; }
function depends_emulationstation-es-x()      { depends_emulationstation; }
function sources_emulationstation-es-x()      { sources_emulationstation; }
function build_emulationstation-es-x()        { build_emulationstation; }
function install_emulationstation-es-x()      { install_emulationstation; }

# ------------------------------------------------------------

function configure_emulationstation-es-x() {

    # ============================================================
    # 1) Remove standard EmulationStation
    # ============================================================
    echo "Removing original EmulationStation..."
    rp_callModule "emulationstation" remove

    # ============================================================
    # 2) Configure ES-X using upstream logic
    # ============================================================
    echo "Configuring ES-X..."
    configure_emulationstation

    # ============================================================
    # Helper: resolve first existing directory
    # ============================================================
    resolve_dir() {
        local p
        for p in "$@"; do
            [[ -d "$p" ]] && { echo "$p"; return 0; }
        done
        return 1
    }

    # ============================================================
    # 3) Install language files (.ini)
    # ============================================================
    echo "Installing ES-X language files..."

    local lang_dst="$home/.emulationstation/lang"
    local lang_src=""
    lang_src="$(resolve_dir \
        "$md_build/lang" \
        "$md_inst/lang" \
        "$md_inst/resources/lang" \
    )"

    if [[ -n "$lang_src" && -d "$lang_src" ]]; then
        mkUserDir "$lang_dst"
        # copy/overwrite (keep it current)
        cp -uv "$lang_src"/*.ini "$lang_dst"/ 2>/dev/null
        chown -R "$user:$user" "$lang_dst"
        echo "Language files installed at $lang_dst"
    else
        echo "WARNING: No 'lang' folder found for ES-X."
    fi

    # ============================================================
    # 3.25) Install ES-X Theme Browser previews (PNG + INI)
    #      Copies to: ~/.emulationstation/esx/theme-previews
    #      - INI files: overwrite/update to keep catalog current
    #      - Other files (png, folders): merge without deleting user extras
    # ============================================================
    echo "Installing ES-X theme previews (Theme Browser)..."

    local esx_root="$home/.emulationstation/esx"
    local previews_dst="$esx_root/theme-previews"
    local previews_src=""
    previews_src="$(resolve_dir \
        "$md_build/esx/theme-previews" \
        "$md_inst/esx/theme-previews" \
        "$md_inst/resources/esx/theme-previews" \
    )"

    if [[ -n "$previews_src" && -d "$previews_src" ]]; then
        mkUserDir "$previews_dst"

        # 1) Update catalog INI(s) (overwrite/update)
        if compgen -G "$previews_src"/*.ini > /dev/null; then
            cp -uv "$previews_src"/*.ini "$previews_dst"/ 2>/dev/null
        fi

        # 2) Merge everything else without deleting user extras
        # Prefer rsync if present; fallback to cp
        if command -v rsync >/dev/null 2>&1; then
            rsync -a --ignore-existing --exclude="*.ini" "$previews_src"/ "$previews_dst"/ 2>/dev/null
        else
            # Merge (won't delete extras; may overwrite less predictably)
            cp -ruv "$previews_src"/. "$previews_dst"/ 2>/dev/null
        fi

        # Normalize perms (optional but safe)
        find "$previews_dst" -type f -exec chmod 644 {} \; 2>/dev/null
        find "$previews_dst" -type d -exec chmod 755 {} \; 2>/dev/null

        chown -R "$user:$user" "$esx_root"
        echo "Theme previews installed/updated at $previews_dst"
    else
        echo "WARNING: No 'esx/theme-previews' folder found in ES-X source."
    fi

    # ============================================================
    # 3.5) Ensure RetroPie music folder exists
    #      If repo has default music, copy ONLY if destination is empty
    # ============================================================
    echo "Ensuring RetroPie music folder exists..."
    local music_dir="$home/RetroPie/music"
    mkUserDir "$music_dir"

    local music_src=""
    music_src="$(resolve_dir \
        "$md_build/music" \
        "$md_inst/music" \
        "$md_inst/resources/music" \
    )"

    if [[ -n "$music_src" && -d "$music_src" ]]; then
        if [[ -z "$(ls -A "$music_dir" 2>/dev/null)" ]]; then
            echo "Copying default music (destination was empty)..."
            cp -ruv "$music_src"/. "$music_dir"/ 2>/dev/null
        else
            echo "Music folder already has files — leaving untouched."
        fi
    else
        echo "Music folder ready at $music_dir (no bundled music found)"
    fi

    chown -R "$user:$user" "$music_dir"

    # ============================================================
    # 4) Install / update ES-X themes
    # ============================================================
    echo "Installing ES-X themes..."
    local themes_dir="$home/.emulationstation/themes"
    mkUserDir "$themes_dir"

    install_esx_theme() {
        local repo="$1"
        local folder="$2"
        local target="$themes_dir/$folder"

        if [[ -d "$target/.git" ]]; then
            echo "Checking updates for theme: $folder"
            git -C "$target" fetch --quiet

            if [[ -n "$(git -C "$target" status -uno | grep 'behind')" ]]; then
                echo "Updating theme: $folder"
                git -C "$target" pull --ff-only
            else
                echo "Theme already up to date: $folder"
            fi

        elif [[ -d "$target" ]]; then
            echo "Theme folder exists but is not a git repository: $folder — leaving untouched."

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
    # 5) Apply default theme ONLY on first install
    # ============================================================
    local es_settings="$home/.emulationstation/es_settings.cfg"

    if [[ ! -f "$es_settings" ]] || ! grep -q "<string name=\"ThemeSet\"" "$es_settings"; then
        echo "Applying default ES-X theme: Alekfull-nx-retropie"

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
