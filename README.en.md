<!-- README language switch -->
[![中文](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-555555?style=for-the-badge)](README.md) [![English](https://img.shields.io/badge/English-1677ff?style=for-the-badge)](README.en.md)

**v1.0.5**: The original-outfit expression preset is gone; Selena always starts from the bridal set, and the original stickers remain in the library for any single interaction. Since v1.0.4 you choose how long "remind me later" on the rest reminder waits (1–240 minutes, 30 by default); the button on the reminder card shows your choice. Since v1.0.3, 33 voice lines that were cut short when the assets were exported are complete (an installed pet swaps in the full versions after updating), and the last moment of a line is no longer swallowed. A voice line, once started, is always said in full: clicking or dragging her while she speaks changes only her pose. The settings window shows every preview when it opens. The bridal expression set and a library of 128 expressions, and 115 Selena voice lines set up for 16 interactions. The full package includes a one-click deploy script that also installs the Harness connection plugin; later versions update from inside the pet.

<!-- /README language switch -->

<div align="center">

# Selena DeepSeek Desktop Pet

**Selena from *Punishing: Gray Raven* keeps you company in DeepSeek Harness: her expression follows your tasks, and she answers in her own voice.**

[Download for Windows](https://github.com/Doya16/selena-deepseek-pet/releases/latest) · [User guide (Chinese)](docs/USAGE.md) · [Report an issue](https://github.com/Doya16/selena-deepseek-pet/issues)

![Selena's expressions for the 16 interactions (bridal skin)](docs/images/events-bridal.jpg)

</div>

For the official **DeepSeek Harness Windows client**, on **Windows 10/11 x64**. The full package includes the bridal expression set and a library of 128 GIFs, 115 Selena voice lines with subtitles, fonts and the Harness connection plugin; no Python installation is required. A [Codex edition](https://github.com/Doya16/selena-codex-pet) is also available; both can run together.

## Installation

**Requirements**: Windows 10 (1809 or later) or Windows 11, 64-bit; Windows 7 / 8 are not supported. Install the official **DeepSeek Harness** desktop app first, then sign in and open it once.

1. Open [Releases](https://github.com/Doya16/selena-deepseek-pet/releases/latest) and download **Selena-DeepSeek-Windows-v1.0.5.zip**.
2. Extract it: right-click the ZIP → **Extract All**, or in 7-Zip / WinRAR choose **Extract to "Selena-DeepSeek-Windows-v…\"** (a folder named after the ZIP).
   - Don't choose "Extract here": the ZIP has no top-level folder, so the files would spill into your Downloads folder.
   - Don't extract into a folder you cannot write to, such as `C:\Program Files`, and don't run it from inside the archive viewer.
3. Open the extracted folder and double-click **一键部署.cmd** (one-click deploy). It:
   - checks that the package is complete and the folder is writable;
   - finds DeepSeek Harness and asks you to **fully quit** it: right-click the Harness tray icon → Quit, then press Enter in the deploy window (your login is kept). It then installs the Harness connection plugin;
   - creates desktop and Start menu shortcuts;
   - starts Selena.
4. Reopen Harness and start a task. The pet follows the most recent conversation and shows its state and your balance.

Afterwards, start the pet from the desktop shortcut. If you would rather not quit Harness now, type `S` at the prompt to skip the plugin and run the script again later, or use **Settings → Connect DeepSeek → Install / update the Harness connection plugin**. No API key is needed.

**If Windows or your security software stops it:**

- If **Windows protected your PC** appears, click **More info** → **Run anyway**; if **Open File - Security Warning** appears, click **Run**. The program has no paid code-signing certificate, which is why Windows asks; it is not a virus.
- If 360, Huorong or another security suite blocks it, add the folder to its trusted list. All source code is public on GitHub: [github.com/Doya16/selena-deepseek-pet](https://github.com/Doya16/selena-deepseek-pet). Every release page has a SHA256SUMS file for checking that your download is complete and unmodified.

When a new version is out, the pet tells you; click **更新并重启赛琳娜** (update and restart Selena) to update in one step, keeping your settings and assets (see "One-click updates" below).

Sound is on by default at 10% volume. Change it in Settings → Desktop & Sound.

## Expressions

Selena uses the **bridal** sticker set by default; every one of the 16 interactions has its own bridal expression.

The library also holds the original-outfit, community, Christmas and New Year stickers, 128 in all. In **Settings → Interaction Studio** you can give any interaction any of them, or import your own images.

## One-click updates

The pet checks for new versions in the background (every 6 hours by default). Click **更新并重启赛琳娜** (update and restart Selena) on the notice to download, verify, install and restart. Only program files are downloaded; your GIFs, voices, subtitles, fonts and settings stay. Update manifests are signed with the publisher's offline Ed25519 key; an interrupted install rolls back.

## Features

- Task states (thinking, reading, editing, running tools, waiting for you, done, error, paused) with their own expressions; separate completion notices per conversation.
- Mouse interactions (pat, double-click, hover, drag, drop, milk tea) with voices.
- 115 Selena voice lines with subtitles, picked at random per action.
- Account balance and per-turn cost; completion float with elapsed time and cost, confetti, edge docking, full-screen hiding, daily recap, reminders.
- Your own GIFs, images, voices and fonts; save everything and move it to another computer.
- The Windows volume mixer lists the pet as “赛琳娜 · DeepSeek”. The connection plugin is `dsh-selena-pet`; it does not affect other pets' plugins.

## Credits

Stickers: shared by the **Selena fan QQ group 978621218** (赛琳娜厨子). Voice lines: Selena (Tempest, Capriccio, Pianissimo) frame voices and event-story voice acting from *Punishing: Gray Raven*.

Character art, stickers and original voices belong to their respective rights holders (*Punishing: Gray Raven* © KURO GAMES). This is a fan project and is not affiliated with the official game. The stickers are for personal, non-commercial use only. See [asset credits](assets/CREDITS.txt) and [third-party licenses](THIRD_PARTY.txt).
