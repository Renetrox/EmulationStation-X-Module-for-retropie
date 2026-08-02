# EmulationStation-X (ES-X) – RetroPie module

This repository provides a **RetroPie-Setup module** for [EmulationStation-X (ES-X)](https://github.com/Renetrox/EmulationStation-X), an experimental fork of EmulationStation with:

- `.ini`-based language files
- Extended theming features
- Theme layouts through `theme.ini`
- Theme Browser support
- Skyscraper integration
- Background music support
- Extra support for modern themes

> **Important:** ES-X uses RetroPie's original EmulationStation module functions to build, install and configure the frontend. The module does **not** delete the original RetroPie module script during installation.

---

## Features

The module currently:

- Builds ES-X from `https://github.com/Renetrox/EmulationStation-X` (`main` branch)
- Installs ES-X as the active EmulationStation frontend
- Copies ES-X `.ini` language files to `~/.emulationstation/lang`
- Installs the `skyscraper-esx.sh` helper script
- Checks for Skyscraper and tries to install it through RetroPie-Setup when missing
- Installs or updates Skyscraper's `artwork.xml` and `config.ini`, preserving backups of existing files
- Installs Theme Browser preview files in `~/.emulationstation/esx/theme-previews`
- Creates the music folders:
  - `~/RetroPie/music`
  - `~/.emulationstation/music`
- Installs the [`Alekfull-nx-retropie`](https://github.com/Renetrox/Alekfull-nx-retropie) theme
- Applies Alekfull NX as the default theme only when the user has not already selected another theme
- Disables ES-X background music automatically when an IMP installation is detected, preventing both music systems from playing at the same time

---

## Before installing

ES-X replaces the currently installed EmulationStation executable with its own build.

It is strongly recommended to back up your EmulationStation configuration first:

```bash
cp -a ~/.emulationstation ~/.emulationstation.backup
```

---

## Installation

Two installation methods are available.

### Method 1: Terminal

Make sure that `RetroPie-Setup` is already installed.

```bash
cd ~/RetroPie-Setup
mkdir -p scriptmodules/supplementary
cd scriptmodules/supplementary

wget -O emulationstation-es-x.sh https://raw.githubusercontent.com/Renetrox/EmulationStation-X-Module-for-retropie/main/emulationstation-es-x.sh
chmod +x emulationstation-es-x.sh
```

Then launch RetroPie-Setup:

```bash
cd ~/RetroPie-Setup
sudo ./retropie_setup.sh
```

Navigate to:

**Manage packages → Experimental packages → emulationstation-es-x → Install from source**

---

### Method 2: Manual installation without terminal

This method is intended for users who prefer to use a graphical file manager.

1. Open this repository in a web browser.
2. Open the file [`emulationstation-es-x.sh`](https://github.com/Renetrox/EmulationStation-X-Module-for-retropie/blob/main/emulationstation-es-x.sh).
3. Press the **Download raw file** button, or open **Raw** and save the page as:

   `emulationstation-es-x.sh`

4. Open your home folder with the file manager.
5. Navigate to:

   `RetroPie-Setup/scriptmodules/supplementary`

6. If the `supplementary` folder does not exist, create it.
7. Copy `emulationstation-es-x.sh` into that folder.
8. Right-click the file and open **Properties → Permissions**.
9. Enable **Allow executing file as a program** or the equivalent executable permission option provided by your desktop.

The final location must be:

```text
~/RetroPie-Setup/scriptmodules/supplementary/emulationstation-es-x.sh
```

You can then open RetroPie-Setup from the **RetroPie** system inside EmulationStation:

**RetroPie → RetroPie Setup**

Navigate to:

**Manage packages → Experimental packages → emulationstation-es-x → Install from source**

> Menu names may vary slightly depending on the RetroPie-Setup version.

---

## After installation

ES-X will:

- Become the active EmulationStation frontend
- Preserve the existing user-selected theme when one is already configured
- Apply Alekfull NX only on a first installation without a configured theme
- Install or update its language files and Theme Browser previews
- Create the supported music folders
- Prepare the included Skyscraper integration

Restart EmulationStation after the installation finishes.

---

## Updating ES-X

Open RetroPie-Setup again and choose:

**Manage packages → Experimental packages → emulationstation-es-x → Update from source**

Depending on the RetroPie-Setup version, reinstalling from source may also rebuild ES-X from the latest `main` branch.

---

## Removal

To remove ES-X:

1. Open RetroPie-Setup.
2. Navigate to:

   **Manage packages → Experimental packages → emulationstation-es-x → Remove**

The module uses RetroPie's original EmulationStation removal logic. Because ES-X occupies the same frontend installation location, removing it also removes the installed EmulationStation executable.

To return to standard EmulationStation afterwards, reinstall the original `emulationstation` package from RetroPie-Setup.

User configuration folders, themes and media are not intentionally deleted by the ES-X module.

---

## Notes

- This module is intended for users who want to experiment with ES-X.
- ES-X is an experimental fork and may contain unfinished features or bugs.
- Existing Skyscraper configuration files are backed up before ES-X versions are installed.
- Existing user themes and music are preserved whenever possible.
- A theme folder that already exists but is not a Git repository is left untouched.

---

## Credits

- ES-X: Renetrox
- Original EmulationStation: Aloshi and the EmulationStation team
- RetroPie-Setup framework: RetroPie team
- Default theme: Alekfull NX

---

# Nota en español

Este repositorio contiene un módulo de RetroPie-Setup para instalar **EmulationStation-X (ES-X)** como frontend principal.

El módulo:

- Compila ES-X desde la rama `main`
- Reutiliza las funciones del módulo original de EmulationStation
- No elimina el archivo del módulo original durante la instalación
- Copia los idiomas `.ini`
- Instala las vistas previas del navegador de temas
- Prepara la integración con Skyscraper
- Crea las carpetas de música
- Instala Alekfull NX como tema predeterminado solamente cuando todavía no existe un tema configurado

## Instalación manual sin terminal

Para quienes prefieren evitar la terminal:

1. Descarga el archivo `emulationstation-es-x.sh` desde este repositorio.
2. Abre tu carpeta personal con el administrador de archivos.
3. Copia el archivo en:

   `RetroPie-Setup/scriptmodules/supplementary`

4. Si la carpeta `supplementary` no existe, créala.
5. Haz clic derecho sobre el archivo y abre **Propiedades → Permisos**.
6. Activa **Permitir ejecutar el archivo como un programa**.
7. Abre **RetroPie Setup** desde el sistema RetroPie de EmulationStation.
8. Entra en:

   **Manage packages → Experimental packages → emulationstation-es-x → Install from source**

La ubicación final debe ser:

```text
~/RetroPie-Setup/scriptmodules/supplementary/emulationstation-es-x.sh
```

Al desinstalar ES-X también se elimina el ejecutable instalado de EmulationStation, porque ambos usan la misma ubicación. Para volver a la versión estándar, reinstala el paquete original `emulationstation` desde RetroPie-Setup.
