Clone the repository in ~/.dotfiles

```bash
$ git clone https://github.com/Anexen/dotfiles.git ~/.dotfiles
```

Create symlinks (I'm using [GNU Stow](https://www.gnu.org/software/stow/)):

```bash
# install user configs
$ stow home
# install system configs
$ stow --target / system
```

Dependencies:
* stow
* aspell
* fd
* fzf
* ripgrep
* tree
* bat
