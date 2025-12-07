# EmulationStation-X (ES-X) – RetroPie module

This repository provides a **RetroPie-Setup module** for [EmulationStation-X (ES-X)](https://github.com/Renetrox/EmulationStation-X), an experimental fork of EmulationStation with:

- `.ini`-based language files
- Extended theming features
- Theme layouts via `theme.ini`
- Extra support for modern themes

> **Note:** This module **replaces** the standard `emulationstation` frontend in RetroPie.

---

## Features

- Builds ES-X from: `https://github.com/Renetrox/EmulationStation-X (main)`
- Removes the default `emulationstation` module to avoid conflicts
- Installs ES-X as the main frontend
- Copies ES-X `.ini` language files to `~/.emulationstation/lang`
- Installs the following themes:
  - [`art-book-next-ESX`](https://github.com/Renetrox/art-book-next-ESX)
  - [`Alekfull-nx-retropie`](https://github.com/Renetrox/Alekfull-nx-retropie)
  - [`Mini`](https://github.com/Renetrox/Mini)
- Applies **Alekfull-nx-retropie** as the default theme **on first install only**

---

## Installation

1. Ensure you have a working `RetroPie-Setup` folder:

   ```bash
   cd ~/RetroPie-Setup
   ```

2. Copy the module file into the supplementary `scriptmodules` folder:

   ```bash
   mkdir -p scriptmodules/supplementary
   cd scriptmodules/supplementary

   # download the module
   wget https://raw.githubusercontent.com/Renetrox/EmulationStation-X-RetroPie-Module/main/emulationstation-es-x.sh

   # make sure it's executable (usually not required, but safe)
   chmod +x emulationstation-es-x.sh
   ```

3. Run RetroPie-Setup:

   ```bash
   cd ~/RetroPie-Setup
   sudo ./retropie_setup.sh
   ```

4. In the menu, navigate to **Experimental packages → emulationstation-es-x** and choose **Install from source**.

After installation, ES-X will:

- Replace the standard `emulationstation` frontend
- Install its `.ini` language files
- Install the three ES-X themes
- Set **Alekfull-nx-retropie** as the default theme if no theme was previously configured

### Uninstall

To remove ES-X using RetroPie-Setup:

1. Run:

   ```bash
   cd ~/RetroPie-Setup
   sudo ./retropie_setup.sh
   ```

2. Go to **Experimental packages → emulationstation-es-x → Remove**. This uses the same removal logic as the original `emulationstation` module.

### Notes

- This module is intended for advanced users who want to experiment with ES-X.
- ES-X is an experimental fork and may contain bugs or unfinished features.

### Credits

- ES-X: Renetrox
- Original EmulationStation: Aloshi and the EmulationStation team
- RetroPie-Setup framework: RetroPie team
- Themes:
  - art-book-next-ESX
  - Alekfull-nx-retropie
  - Mini

## Nota en español

Este módulo instala ES-X como frontend principal en RetroPie, copia los archivos de idioma `.ini` y añade tres temas (ArtBook Next ESX, Alekfull NX, Mini). Por defecto, aplica **Alekfull-nx-retropie** la primera vez que se instala.
