![preview](https://user-images.githubusercontent.com/5568591/140620519-59ed439e-b9e1-4098-8521-37e19509ae06.png)

Clone the repository in ~/.dotfiles

```bash
$ git clone https://github.com/Anexen/dotfiles.git ~/.dotfiles
```

Integrated third-party tools:
* [ondir](https://github.com/alecthomas/ondir)
* [forgit](https://github.com/wfxr/forgit)
* [fzf-marks](https://github.com/urbainvaes/fzf-marks)

Create symlinks (I'm using [GNU Stow](https://www.gnu.org/software/stow/)):

```bash
# install user configs
$ stow home
# install system configs
$ stow --target / system
# dry-run
$ stow --simulate home
```

Dependencies:
* alacritty
* tmux
* starship
* neovim
* aspell
* fd
* fzf
* ripgrep
* tree
* bat
