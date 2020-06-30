Clone the repository in ~/.dotfiles

```bash
$ git clone https://github.com/Anexen/dotfiles.git ~/.dotfiles
```

There is a list of third-party tools integrated as submodules:
* forgit
* ondir
* fzf-marks
* etc

Create symlinks (I'm using [GNU Stow](https://www.gnu.org/software/stow/)):

```bash
# install user configs
$ stow home
# install system configs
$ stow --target / system
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
