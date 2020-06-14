Clone the repository in ~/.dotfiles

```bash
$ git clone https://github.com/Anexen/dotfiles.git ~/.dotfiles
```

Create symlinks (I'am using [GNU Stow](https://www.gnu.org/software/stow/)):

```bash
$ stow bash
$ stow nvim
$ stow git
```

Dependencies:
* stow
* aspell
* fd
* fzf
* ripgrep
