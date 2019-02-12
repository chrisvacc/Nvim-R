" *Nvim-R.txt*                                                  *Nvim-R*
"                                   Nvim-R~
" 			    Plugin to work with R~
" 
" Authors: Jakson A. Aquino   <jalvesaq@gmail.com>
"        " Jose Claudio Faria <joseclaudio.faria@gmail.com>
" 
" Version: 0.9.12.1
" For Neovim >= 0.2.0 and Vim >= 8.0.0946
" 
" 1. Overview                                    |Nvim-R-overview|
" 2. Main features                               |Nvim-R-features|
" 3. Installation                                |Nvim-R-installation|
" 4. Use                                         |Nvim-R-use|
" 5. Known bugs and workarounds                  |Nvim-R-known-bugs|
" 6. Options                                     |Nvim-R-options|
" 7. Custom key bindings                         |Nvim-R-key-bindings|
" 8. License and files                           |Nvim-R-license|
" 9. FAQ and tips                                |Nvim-R-tips|
" 10. News                                        |Nvim-R-news|
" 
" 
" ==============================================================================
							     " *Nvim-R-overview*
" 1. Overview~
" 
" This plugin improves the support for editing R code with both Vim and Neovim,
" integrating them with R. Stable versions of this plugin are available
" available at:
" 
    " https://github.com/jalvesaq/Nvim-R/releases
" 
" Feedback is welcomed. Please submit bug reports to the developers. Do not like
" a feature? Tell us and we may add an option to disable it. If you have any
" comments or questions, please post them at:
" 
    " https://groups.google.com/forum/#!forum/vim-r-plugin
" 
" The plugin should emit useful warnings if you do things it was not programmed
" to deal with. Cryptic error message are bugs... Please report them at:
" 
    " https://github.com/jalvesaq/Nvim-R/issues
" 
" Patches and git pull requests are welcome. If you want a feature that only few
" people might be interested in, you can write a script to be sourced by Nvim-R
" (see |R_source|).
" 
" 
" ==============================================================================
							     " *Nvim-R-features*
" 2. Main features~
" 
  " * Syntax highlighting for R code, including:
      " - Special characters in strings.
      " - Functions of loaded packages.
      " - Special highlighting for R output (.Rout files).
      " - Spell check only strings and comments.
      " - Fold code when foldmethod=syntax.
  " * Integrated communication with R:
      " - Start/Close R.
      " - Send lines, selection, paragraphs, functions, blocks, entire file.
      " - Send commands with the object under cursor as argument: help, args,
        " plot, print, str, summary, example, names.
      " - Send to R the Sweave, knit and pdflatex commands.
  " * Omni completion (auto-completion) for R objects (.GlobalEnv and loaded
    " packages).
  " * Omni completion of function arguments.
  " * Omni completion of knitr chunk options.
  " * Omni completion of bibliographic entries (Rmd and Rnoweb).
  " * Omni completion of python code in knitr chunks if the jedi-vim plugin is
    " installed (Rmd).
  " * Ability to see R's documentation in an editor buffer:
      " - Automatic calculation of the best layout of the R documentation buffer
        " (split the window either horizontally or vertically according to the
        " available room).
      " - Automatic formatting of the text to fit the panel width.
      " - Send code and commands to R (useful to run examples).
      " - Jump to another R documentation.
      " - Syntax highlighting of R documentation.
  " * Object Browser (.GlobalEnv and loaded packages):
      " - Send commands with the object under cursor as argument.
      " - Call R's `help()` with the object under cursor as argument.
      " - Syntax highlighting of the Object Browser.
  " * SyncTeX support.
  " * Most of the plugin's behavior is customizable.
" 
" 
" ==============================================================================
							 " *Nvim-R-installation*
" 3. Installation~
" 
" The installation process is described in four sections:
" 
   " 3.1. Installation of dependencies
   " 3.2. Installation of the plugin
   " 3.3. Troubleshooting
   " 3.4. Optional steps
" 
" ------------------------------------------------------------------------------
" 3.1. Installation of dependencies~
" 
" Before installing the plugin, you should install its dependencies:
" 
" Main dependencies:~
" 
   " Neovim >= 0.2.0 (Linux, OS X) or >= 0.2.1 (Windows):
      " https://github.com/neovim/neovim/releases
      " See also: https://github.com/neovim/neovim/wiki/Installing-Neovim
" 
   " or Vim >= 8.0:
      " http://www.vim.org/download.php
      " Vim must be compiled with |+channel|, |+job| and |+conceal| features.
      " In Normal mode, do `:version` to check if your Vim has these features.
      " You need Vim >= 8.0.0946 to run R in its built-in terminal emulator.
" 
" 
   " R >= 3.0.0:
      " http://www.r-project.org/
" 
   " Notes about the R package `nvimcom`:
" 
     " - The R package `nvimcom` is included in Nvim-R and is automatically
       " installed and updated whenever necessary. The package requires
       " compilation by a C compiler (e.g. `gcc` or `clang`).
" 
     " - You do not need to load nvimcom in your .Rprofile because the Nvim-R
       " plugin sets the environment variable `R_DEFAULT_PACKAGES`, including
       " `nvimcom` in the list of packages to be loaded on R startup. However,
       " if you set the option `defaultPackages` in a .Rprofile, you should
       " include "nvimcom" among the packages to be loaded (see
       " |nvimcom-not-loaded|).
" 
     " - On Windows, you have to install Rtools to be able to build the package:
       " https://cran.r-project.org/bin/windows/Rtools/
" 
" 
" Additional dependencies for editing Rnoweb documents:~
" 
   " latexmk:       Automate the compilation of LaTeX documents.
                  " See examples in |R_latexcmd|.
" 
   " PDF viewer with SyncTeX support and capable of automatically reloading
   " documents. This is required only if you edit Rnoweb files.
      " On Linux and other Unix systems: Zathura (recommended), Evince or Okular.
      " On OS X: Skim.
      " On Windows: SumatraPDF.
" 
   " wmctrl:       http://tomas.styblo.name/wmctrl/
                 " Required for better SyncTeX support under X Server.
		 " (Not required on either Windows or OS X)
" 
   " Python 3 and python3-pybtex library: required for omnicompletion of
   " citation keys (following |R_cite_pattern|).
" 
" 
" Additional dependencies for editing Rmd documents:~
" 
   " xdotool: Required to reload the page on the web browser (Linux only).
" 
   " Python 3 and python3-pybtex library: required for omnicompletion of
   " citation keys (following the `@` symbol).
" 
" 
" Additional suggestions for Unix (Linux, OS X, Cygwin, etc.):~
" 
   " Tmux >= 2.0:  http://tmux.sourceforge.net
		 " Tmux is required only if you want to run R in an external
		 " terminal emulator (see |R_in_buffer|).
" 
   " colorout:     https://github.com/jalvesaq/colorout/releases
                 " Colorizes the R output in terminal emulators.
		 " (Not necessary if using Neovim with |R_in_buffer| = 1)
		 " You should put in your Rprofile: `library(colorout)`
" 
" You may want to improve the configuration of your |vimrc| for a better use of
" the plugin. Please, see |Nvim-R-quick-setup| for some suggestions of
" configuration.
" 
" 
" ------------------------------------------------------------------------------
" 3.2. Installation of the plugin~
" 
" Now, install Nvim-R. You have two options: Vimball and Vim Package.
" 
" 
" Vimball~
" 
" If you want to install from the vimball, download the file Nvim-R.vmb from:
" 
   " http://www.vim.org/scripts/script.php?script_id=2628
" 
" Then, open the file with either Vim or Neovim and do:
" >
   " :packadd vimball
   " :so %
" <
" Finally, press the space bar a few time to ensure the installation of all
" files.
" 
" 
" Vim Package~
" 
" If you have a previous Vimball installation, you should uninstall it first:
" >
   " :packadd vimball
   " :RmVimball Nvim-R
" <
" The Vim package is a zip file released at:
" 
    " https://github.com/jalvesaq/Nvim-R/releases
" 
" If, for instance, it was saved in the `/tmp` directory, to install it on an
" Unix system, you should do for Neovim:
" >
   " mkdir -p ~/.local/share/nvim/site/pack/R
   " cd ~/.local/share/nvim/site/pack/R
   " unzip /tmp/Nvim-R_0.9.6.zip
" <
" The directory for Vim on Unix is `~/.vim/pack/R`.
" For Neovim on Windows, it is `~/AppData/Local/nvim/pack/R`.
" And, for Vim on Windows, it is `~/vimfiles/pack/R`.
" The name of the last subdirectory does not need to be `R`; it might be
" anything.
" 
" Finally, in Vim (or Neovim) run `:helptags` (adjust the path according to your
" system):
" >
   " :helptags ~/.local/share/nvim/site/pack/R/start/Nvim-R/doc
" <
" See |packages| for details.
" 
" 
" ------------------------------------------------------------------------------
" 3.3. Troubleshooting (if the plugin doesn't work)~
" 
" Note: The <LocalLeader> is '\' by default.
" 
" The plugin is a |file-type| plugin. It will be active only if you are editing
" a .R, .Rnw, .Rd, Rmd, or Rrst file. The menu items will not be visible and the
" key bindings will not be active while editing either unnamed files or files
" with name extensions other than the mentioned above (however, see
" |Nvim-R-global|). If the plugin is active, pressing <LocalLeader>rf should
" start R.
" 
" Did you see warning messages but they disappeared before you have had time to
" read them? Type the command |:messages| in Normal mode to see them again.
" 
" If R does not start with the <LocalLeader>rf command and you get an error
" message instead, you may want to set the path to the R executable (see
" |R_path|).
							  " *nvimcom-not-loaded*
" If you see the following message in the R console:
" >
   " During startup - Warning messages:
   " 1: In library(package, lib.loc = lib.loc, character.only = TRUE,
                 " logical.return = TRUE, : there is no package called ‘nvimcom’
   " 2: package ‘nvimcom’ in options("defaultPackages") was not found
" <
" Try quiting both R and Vim/Neovim and starting them again.
" 
" If you still see the message "The package nvimcom wasn't loaded yet" after
" starting R, then Nvim-R could not induce R to load nvimcom. Nvim-R sets the
" environment variable `R_DEFAULT_PACKAGES` before starting R. If the variable
" already exists, the string ",nvimcom" is appended to it. However, if you set
" the option `defaultPackages` in your .Rprofile or in a .Rprofile in the
" current directory, the environment variable will be overridden. Thus, if you
" have to set the option `defaultPackages`, you should include "nvimcom" among
" the packages to be loaded. You might want to include "nvimcom" only if R was
" started by Nvim-R, as in the example below:
" >
   " if(Sys.getenv("NVIMR_TMPDIR") == ""){
       " options(defaultPackages = c("utils", "grDevices", "graphics", "stats", "methods"))
   " } else {
       " options(defaultPackages = c("utils", "grDevices", "graphics", "stats", "methods", "nvimcom"))
   " }
" <
" Finally, run the command `:RDebugInfo` after <LocalLeader>rf and check the
" path where nvimcom was installed.
" 
" On Windows, nvimcom compilation will fail if your `.Rprofile` outputs anything
" during R Startup.
" 
" 
" ------------------------------------------------------------------------------
" 3.4. Optional steps~
" 
" Customize the plugin~
" 
" Please read the section |Nvim-R-options|. Emacs/ESS users should also read
" |ft-r-indent|.
" 
" 
" Install additional plugins~
" 
" You may be interested in installing additional general plugins to get
" functionality not provided by this file type plugin. Particularly interesting
" are vim-signature, csv.vim and snipMate. Please read |Nvim-R-tips| for details.
" 
" If you edit Rnoweb files, you may want to try LaTeX-Box for omnicompletion of
" LaTeX code (see |Nvim-R-latex-box| for details).
" 
" Note: Some of vim-latex keybindings might clash with Nvim-R ones.
" 
" If you edit RMarkdown files, you may prefer the syntax highlighting provided
" by https://github.com/vim-pandoc/vim-pandoc-syntax
" 
" See https://github.com/w0rp/ale if you want a syntax checker.
" 
" Gabriel Alcaras's plugin for asynchronous R completion:
" https://github.com/gaalcaras/ncm-R
" It will slowdown R if its workspace has too many objects, data.frames with too
" many columns or lists with too many elements (see |R_ls_env_tol|).
" 
" 
" ==============================================================================
								  " *Nvim-R-use*
" 4. Use~
" 
" By default, Nvim-R will run R in a built-in terminal emulator, but you can
" change this behavior (see |R_in_buffer|).
" 
" 
" 4.1. Key bindings~
" 
" Note: The <LocalLeader> is '\' by default.
" 
" Note: It is recommended the use of different keys for <Leader> and
" <LocalLeader> to avoid clashes between filetype plugins and general plugins
" key binds. See |filetype-plugins|, |maplocalleader| and |Nvim-R-localleader|.
" 
" To use the plugin, open a .R, .Rnw, .Rd, .Rmd or .Rrst file with Vim and
" type <LocalLeader>rf. Then, you will be able to use the plugin key bindings to
" send commands to R.
" 
" This plugin has many key bindings, which correspond with menu entries. In the
" list below, the backslash represents the <LocalLeader>. Not all menu items and
" key bindings are enabled in all filetypes supported by the plugin (r, rnoweb,
" rhelp, rrst, rmd).
" 
" Menu entry                                Default shortcut~
" Start/Close
  " . Start R (default)                                  \rf
  " . Start R (custom)                                   \rc
  " --------------------------------------------------------
  " . Close R (no save)                                  \rq
  " . Stop R                                          :RStop
" -----------------------------------------------------------
" 
" Send
  " . File                                               \aa
  " . File (echo)                                        \ae
  " . File (open .Rout)                                  \ao
  " --------------------------------------------------------
  " . Block (cur)                                        \bb
  " . Block (cur, echo)                                  \be
  " . Block (cur, down)                                  \bd
  " . Block (cur, echo and down)                         \ba
  " --------------------------------------------------------
  " . Chunk (cur)                                        \cc
  " . Chunk (cur, echo)                                  \ce
  " . Chunk (cur, down)                                  \cd
  " . Chunk (cur, echo and down)                         \ca
  " . Chunk (from first to here)                         \ch
  " --------------------------------------------------------
  " . Function (cur)                                     \ff
  " . Function (cur, echo)                               \fe
  " . Function (cur and down)                            \fd
  " . Function (cur, echo and down)                      \fa
  " --------------------------------------------------------
  " . Selection                                          \ss
  " . Selection (echo)                                   \se
  " . Selection (and down)                               \sd
  " . Selection (echo and down)                          \sa
  " . Selection (evaluate and insert output in new tab)  \so
  " --------------------------------------------------------
  " . Paragraph                                          \pp
  " . Paragraph (echo)                                   \pe
  " . Paragraph (and down)                               \pd
  " . Paragraph (echo and down)                          \pa
  " --------------------------------------------------------
  " . Line                                                \l
  " . Line (and down)                                     \d
  " . Line (and new one)                                  \q
  " . Left part of line (cur)                       \r<Left>
  " . Right part of line (cur)                     \r<Right>
  " . Line (evaluate and insert the output as comment)    \o
" -----------------------------------------------------------
" 
" Command
  " . List space                                         \rl
  " . Clear console                                      \rr
  " . Remove objects and clear console                   \rm
  " --------------------------------------------------------
  " . Print (cur)                                        \rp
  " . Names (cur)                                        \rn
  " . Structure (cur)                                    \rt
  " . View data.frame (cur)                              \rv
  " . Run dput(cur) and show output in new tab           \td
  " . Run print(cur) and show output in new tab          \tp
  " --------------------------------------------------------
  " . Arguments (cur)                                    \ra
  " . Example (cur)                                      \re
  " . Help (cur)                                         \rh
  " --------------------------------------------------------
  " . Summary (cur)                                      \rs
  " . Plot (cur)                                         \rg
  " . Plot and summary (cur)                             \rb
  " --------------------------------------------------------
  " . Set working directory (cur file path)              \rd
  " --------------------------------------------------------
  " . Sweave (cur file)                                  \sw
  " . Sweave and PDF (cur file)                          \sp
  " . Sweave, BibTeX and PDF (cur file) (Linux/Unix)     \sb
  " --------------------------------------------------------
  " . Knit (cur file)                                    \kn
  " . Knit, BibTeX and PDF (cur file) (Linux/Unix)       \kb
  " . Knit and PDF (cur file)                            \kp
  " . Knit and Beamer PDF (cur file)                     \kl
  " . Knit and HTML (cur file, verbose)                  \kh
  " . Knit and ODT (cur file)                            \ko
  " . Knit and Word Document (cur file)                  \kw
  " . Markdown render (cur file)                         \kr
  " . Spin (cur file) (only .R)                          \ks
  " --------------------------------------------------------
  " . Open attachment of reference (Rmd, Rnoweb)         \oa
  " . Open PDF (cur file)                                \op
  " . Search forward (SyncTeX)                           \gp
  " . Go to LaTeX (SyncTeX)                              \gt
  " --------------------------------------------------------
  " . Build tags file (cur dir)                  :RBuildTags
" -----------------------------------------------------------
" 
" Edit
  " . Insert "<-"                                          _
  " . Complete object name                     CTRL-X CTRL-O
  " --------------------------------------------------------
  " . Indent (line)                                       ==
  " . Indent (selected lines)                              =
  " . Indent (whole buffer)                             gg=G
  " --------------------------------------------------------
  " . Toggle comment (line, sel)                         \xx
  " . Comment (line, sel)                                \xc
  " . Uncomment (line, sel)                              \xu
  " . Add/Align right comment (line, sel)                 \;
  " --------------------------------------------------------
  " . Go (next R chunk)                                  \gn
  " . Go (previous R chunk)                              \gN
" -----------------------------------------------------------
" 
" Object Browser
  " . Open/Close                                         \ro
  " . Expand (all lists)                                 \r=
  " . Collapse (all lists)                               \r-
  " . Toggle (cur)                                     Enter
" -----------------------------------------------------------
" 
" Help (plugin)
" Help (R)                                            :Rhelp
" -----------------------------------------------------------
" 
" Please see |Nvim-R-key-bindings| to learn how to customize the key bindings
" without editing the plugin directly.
" 
" The plugin commands that send code to R Console are the most commonly used. If
" the code to be sent to R has a single line it is sent directly to R Console.
" If it has more than one line (a selection of lines, a block of lines between
" two marks, a paragraph etc) the lines are written to a file and the plugin
" sends to R the command to source the file. To send to R Console the line
" currently under the cursor you should type <LocalLeader>d. If you want to see
" what lines are being sourced when sending a selection of lines, you can use
" either <LocalLeader>se or <LocalLeader>sa instead of <LocalLeader>ss.
" 
" You can also use the command `:RSend` to type and, then, send a line of code
" to R. If you use this command frequently, you may consider creating a map for
" it in your |vimrc|. For example:
" >
   " nmap <LocalLeader>: :RSend
" <
" Observe that there is an empty space after `:RSend`, so you do not have to
" type it.
" 
" The command <LocalLeader>o runs in the background the R command `print(line)`,
" where `line` is the line under the cursor, and adds the output as commented
" lines to the source code.
" 
" If the cursor is over the header of an R chunk with the `child` option (from
" Rnoweb, RMarkdown or RreStructuredText document), and you use one of the
" commands that send a single line of code to R, then the plugin will send to R
" the command to knit the child document.
" 
" After the commands that send, sweave or knit the current buffer, Vim will
" save the current buffer if it has any pending changes before performing the
" tasks. After <LocalLeader>ao, Vim will run "R CMD BATCH --no-restore
" --no-save" on the current file and show the resulting .Rout file in a new tab.
" Please see |R_routnotab| if you prefer that the file is open in a new split
" window. Note: The command <LocalLeader>ao, silently writes the current buffer
" to its file if it was modified and deletes the .Rout file if it exists.
" 
" R syntax uses " <- " to assign values to variables which is inconvenient to
" type. In insert mode, typing a single underscore, "_", will write " <- ",
" unless you are typing inside a string. The replacement will always happen if
" syntax highlighting is off (see |:syn-on| and |:syn-off|). If necessary, it is
" possible to insert an actual underscore into your file by typing a second
" underscore. This behavior is similar to the EMACS ESS mode some users may be
" familiar with and is enabled by default. You have to change the value of
" |R_assign| to disable underscore replacement.
" 
" When you press <LocalLeader>rh, the plugin shows the help for the function
" under the cursor. The plugin also checks the class of the first object passed
" as argument to the function to try to figure out whether the function is a
" generic one and whether it is more appropriate to show a specific method. The
" same procedure is followed with <LocalLeader>rp, that is, while printing an
" object. For example, if you run the code below and, then, press
" <LocalLeader>rh and <LocalLeader>rp over the two occurrences of `summary`, the
" plugin will show different help documents and print different function methods
" in each case:
" >
   " y <- rnorm(100)
   " x <- rnorm(100)
   " m <- lm(y ~ x)
   " summary(x)
   " summary(m)
" <
" Nvim-R will not check the class of the first object if the `=` operator is
" present. For example, in the two cases below you would get the generic help
" for `summary`:
" >
   " summary(object = x)
   " summary(object = m)
" <
" To get help on an R topic, you can also type in Vim (Normal mode):
" >
   " :Rhelp topic
" <
" The command may be abbreviated to `:Rh` and you can either press <Tab> to
" trigger the autocompletion of R objects names or hit CTRL-D to list the
" possible completions (see |cmdline-completion| for details on the various ways
" of getting command-line completion). The list of objects used for completion
" is the same available for omnicompletion (see |R_start_libs|). You may close
" the R documentation buffer by simply pressing `q`.
" 
" The command <LocalLeader>td will run `dput()` with the object under cursor as
" argument and insert the output in a new tab. The command <LocalLeader>tp will
" run `print()` in the same way.
" 
" If the object under the cursor is a data.frame or a matrix, <LocalLeader>rv
" will show it in a new tab. If the csv.vim plugin is not installed, Nvim-R
" will warn you about that (see |Nvim-R-df-view|). Specially useful commands
" from the csv.vim plugin are |:CSVHeader|, |:ArrangeColumn| and |:CSVHiColumn|.
" It can be installed from:
" 
   " http://www.vim.org/scripts/script.php?script_id=2830
" 
" When completing object names (CTRL-X CTRL-O) you have to press CTRL-N to go
" foward in the list and CTRL-P to go backward (see |popupmenu-completion|). If
" R is running and 'completeopt' includes the `preview` string, the preview
" window will display help for the argument selected in the pop up menu (see
" |R_show_arg_help|). For rnoweb, rmd and rrst file types, CTRL-X CTRL-O can
" also be used to complete knitr chunk options if the cursor is inside the chunk
" header.
" 
" If R is not running or if it is running but is busy the completion will be
" based on information from the packages listed by |R_start_libs| (provided that
" the libraries were loaded at least once during a session of Nvim-R usage).
" Otherwise, the pop up menu for completion of function arguments will include
" an additional line with the name of the library where the function is (if the
" function name can be found in more than one library) and the function method
" (if what is being shown are the arguments of a method and not of the function
" itself). For both `library()` and `require()`, when completing the first
" argument, the popup list shows the names of installed packages, but only if R
" is running.
" 
" You can source all .R files in a directory with the Normal mode command
" :RSourceDir, which accepts an optional argument (the directory to be sourced).
" 
" ------------------------------------------------------------------------------
								     " *Rinsert*
								     " *Rformat*
" The command  `:Rinsert` <cmd>  inserts one or more lines with the output of the
" R command sent to R. By using this command we can avoid the need of copying
" and pasting the output R from its console to Vim. For example, to insert
" the output of `dput(levels(var))`, where `var` is a factor vector, we could do
" in Vim:
" >
   " :Rinsert dput(levels(var))
" <
" The output inserted by `:Rinsert` is limited to 5012 characters.
" 
" The command `:Rformat` calls the function `tidy_source()` of formatR package
" to format either the entire buffer or the selected lines. The value of the
" `width.cutoff` argument is set to the buffer's 'textwidth' if it is not
" outside the range 20-180. Se R help on `tidy_source` for details on how to
" control the function behavior.
" 
" 
" ------------------------------------------------------------------------------
" 4.2. Editing Rnoweb files~
" 
" In Rnoweb files (.Rnw), when the cursor is over the `@` character, which
" finishes an R chunk, the sending of all commands to R is suspended and the
" shortcut to send the current line makes the cursor to jump to the next chunk.
" While editing Rnoweb files, the following commands are available in Normal
" mode:
" 
   " [count]<LocalLeader>gn : go to the next chunk of R code
   " [count]<LocalLeader>gN : go to the previous chunk of R code
" 
" You can also press <LocalLeader>gt to go the corresponding line in the
" generated .tex file (if SyncTeX is enabled).
" 
" The commands <LocalLeader>cc, ce, cd and ca send the current chunk of R code
" to R Console. The command <LocalLeader>ch sends the R code from the first
" chunk up to the current line.
" 
" The commands <LocalLeader>kn builds the .tex file from the Rnoweb one using
" the knitr package and <LocalLeader>kp compiles the pdf; for Sweave, the
" commands are, respectively <LocalLeader>sw and <LocalLeader>sp. You can jump
" from the Rnoweb file to the PDF (forward search) with the command
" <LocalLeader>gp. The command to jump from a specific location in the PDF to
" the corresponding line in the Rnoweb (backward search) is specific to each pdf
" viewer:
" 
   " Zathura: <C-LeftMouse>
   " Evince:  <C-LeftMouse>
   " Okular:  <S-LeftMouse>
   " Skim:    <S-Cmd-Click>
   " Sumatra: <Double-click>
" 
" In any case, the pdf viewer must be started by the Nvim-R plugin. See
" |Nvim-R-SyncTeX| for details.
" 
" 
" ------------------------------------------------------------------------------
" 4.3. Omni completion and the highlighting of functions~
" 
" The plugin adds some features to the default syntax highlight of R code. One
" such feature is the highlight of R functions. However, functions are
" highlighted only if their libraries are loaded by R (but see
" |R_start_libs|).
" 
" Note: If you have too many loaded packages Vim may be unable to load the
" list of functions for syntax highlight.
" 
" Vim can automatically complete the names of R objects when CTRL-X CTRL-O is
" pressed in insert mode (see |omni-completion| for details). Omni completion
" shows in a pop up menu the name of the object, its class and its environment
" (most frequently, its package name). If the object is a function, the plugin
" can also show the function arguments in a separate preview window (this
" feature is disabled by default: see |R_show_args|).
" 
" If a data.frame is found, while building the list of objects, the columns in
" the data.frame are added to the list. When you try to use omni completion to
" complete the name of a data.frame, the columns are not shown. But when the
" data.frame name is already complete, and you have inserted the '$' symbol,
" omni completion will show the column names.
" 
" Only the names of objects in .GlobalEnv and in loaded libraries are completed.
" If R is not running, only objects of libraries listed in |R_start_libs| will
" have their names completed. When you load a new library in R, only the current
" buffer has the highlighting of function names immediately updated. If you have
" other buffers open, they will be updated when you enter them.
" 
" Vim uses one file to store the names of .GlobalEnv objects and a list of
" files for all other objects. The .GlobalEnv list is stored in the
" `$NVIMR_TMPDIR` directory and is deleted when you quit Vim. The other files
" are stored in the `$NVIMR_COMPLDIR` directory and remain available until you
" manually delete them.
" 
" 
" ------------------------------------------------------------------------------
" 4.4. The Object Browser~
" 
" You have to use <LocalLeader>ro to either open or close the Object Browser.
" The Object Browser has two views: .GlobalEnv and Libraries. If you press
" <Enter> on the first line of the Object Browser it will toggle the view
" between the objects in .GlobalEnv and the currently loaded libraries.
" 
" In the .GlobalEnv view, if an object has the attribute "label", it will also
" be displayed. For instance, the code below would make the Object Browser
" display the variable labels of an imported SPSS dataset:
" >
   " library(foreign)
   " d <- read.spss("/path/to/spss/dataset.sav", to.data.frame = TRUE)
   " vlabs <- attr(d, "variable.labels")
   " for(n in names(vlabs))
       " attr(d[[n]], "label") <- vlabs[[n]]
" <
" In the Object Browser window, while in Normal mode, you can either press
" <Enter> or double click (GVim only) over a data.frame or list to show/hide its
" elements (not if viewing the content of loaded libraries). If you are running
" R in an environment where the string UTF-8 is part of either LC_MESSAGES or
" LC_ALL variables, unicode line drawing characters will be used to draw lines
" in the Object Browser. This is the case of most Linux distributions.
" 
" In the Libraries view, you can either double click or press <Enter> on a
" library name to see its objects. In the Object Browser, the libraries have the
" color defined by the PreProc highlighting group. The other objects have
" their colors defined by the return value of some R functions. Each line in the
" table below shows a highlighting group and the corresponding type of R object:
" 
	 " PreProc	libraries
	 " Number		numeric
	 " String		character
	 " Special	factor
	 " Boolean	logical
	 " Type		list
	 " Function	function
	 " Statement	s4
	 " Comment	promise (lazy load object)
" 
" One limitation of the Object Browser is that objects made available by the
" command `data()` are only links to the actual objects (promises of lazily
" loading the object when needed) and their real classes are not recognized in
" the GlobalEnv view. The same problem happens when the `knitr` option
" `cache.lazy=TRUE`. However, if you press <Enter> over the name of the object
" in the Object Browser, it will be actually loaded by the command (ran in the
" background):
" >
   " obj <- obj
" <
" Note: The Object Browser may slowdown R if its workspace has too many
" objects, data.frames with too many columns or lists with too many elements.
" 
" 
" ------------------------------------------------------------------------------
" 4.5. Commenting and uncommenting lines~
" 
" You can toggle the state of a line as either commented or uncommented by
" typing <LocalLeader>xx. The string used to comment the line will be "# ", "##
" " or "### ", depending on the values of R_indent_commented and
" r_indent_ess_comments (see |R_rcomment_string|).
" 
" You can also add the string "# " to the beginning of a line by typing
" <LocalLeader>xc and remove it with <LocalLeader>xu. In this case, you can set
" the value of R_rcomment_string to control what string will be added
" to the beginning of the line. Example:
" >
   " let R_rcomment_string = '# '
" <
" Finally, you can also add comments to the right of a line with the
" <LocalLeader>; shortcut. By default, the comment starts at the 40th column,
" which can be changed by setting the value of r_indent_comment_column, as
" below:
" >
   " let r_indent_comment_column = 20
" <
" If the line is longer than 38 characters, the comment will start two columns
" after the last character in the line. If you are running <LocalLeader>; over a
" selection of lines, the comments will be aligned according to the longest
" line.
" 
" Note: While typing comments the leader comment string is automatically added
" to new lines when you reach 'textwidth' but not when you press <Enter>.
" Please, read the Vim help about 'formatoptions' and |fo-table|. For example,
" you can add the following line to your |vimrc| if you want the comment string
" being added after <Enter>:
" >
   " autocmd FileType r setlocal formatoptions-=t formatoptions+=croql
" <
" Tip: You can use Vim substitution command `:%s/#.*//` to delete all comments
" in a buffer (see |:s| and |pattern-overview|).
" 
" 
" ------------------------------------------------------------------------------
								  " *RBuildTags*
" 4.6. Build a tags file to jump to function definitions~
" 
" Vim can jump to functions defined in other files if you press CTRL-] over the
" name of a function, but it needs a tags file to be able to find the function
" definition (see |tags-and-searches|). The command `:RBuildTags` calls the R
" functions `rtags()` and `etags2ctags` to build the tags file for the R scripts
" in the current directory. Please read |Nvim-R-tagsfile| to learn how to create
" a tags file referencing source code located in other directories, including
" the entire R source code.
" 
" 
" ==============================================================================
							   " *Nvim-R-known-bugs*
" 5. Known bugs and workarounds~
" 
" Known bugs that will not be fixed are listed in this section. Some of them can
" not be fixed because they depend on missing features in either R or Vim;
" others would be very time consuming to fix without breaking anything.
" 
" 
" ------------------------------------------------------------------------------
" 5.1. R's source() issues~
" 
" The R's `source()` function of the base package prints an extra new line
" between commands if the option echo = TRUE, and error and warning messages are
" printed only after the entire code is sourced. This makes it more difficult to
" find errors in the code sent to R. Details:
" 
   " https://stat.ethz.ch/pipermail/r-devel/2012-December/065352.html
" 
" 
" ------------------------------------------------------------------------------
" 5.2. The menu may not reflect some of your custom key bindings~
" 
" If you have created a custom key binding for Nvim-R, the menu in
" GVim will not always reflect the correct key binding if it is not the same for
" Normal, Visual and Insert modes.
" 
" 
" ------------------------------------------------------------------------------
" 5.3. Functions are not always correctly sent to R~
" 
" The plugin is only capable of recognizing functions defined using the `<-`
" operator. Also, only current function scope is sent to R. See:
" 
   " https://github.com/jalvesaq/Nvim-R/issues/34
" 
" 
" ------------------------------------------------------------------------------
" 5.4. Wrong message that "R is busy" (Windows only)~
" 
" On Windows, when code is sent from Vim to R Console, the nvimcom library
" sets the value of the internal variable `r_is_busy` to 1. The value is set
" back to 0 when any code is successfully evaluated. If you send invalid code to
" R, there will be no successful evaluation of code and, thus, the value of
" `r_is_busy` will remain set to 1. Then, if you try to update the object
" browser, see the R documentation for any function, or do other tasks that
" require the hidden evaluation of code by R, the nvimcom library will refuse to
" do the tasks to avoid any risk of corrupting R's memory. It will tell Vim
" that "R is busy" and Vim will display this message. Everything should work
" as expected again after any valid code is executed in the R Console.
" 
" 
" ------------------------------------------------------------------------------
" 5.5. R must be started by Vim~
" 
" The communication between Vim and R will work only if R was started by
" Vim through the <LocalLeader>rf command because the plugin was designed to
" connect each Vim instance with its own R instance.
" 
" If you start R before Vim, it will not inherit from Vim the environment
" variables R_DEFAULT_PACKAGES, NVIMR_TMPDIR, NVIMR_COMPLDIR, NVIMR_ID, and
" NVIMR_SECRET. The first one induces R to load nvimcom; the second variable is
" the path used by the R package nvimcom to save temporary files used by Nvim-R
" to: perform omnicompletion, show R documentation in a Vim buffer, and update
" the Object Browser. The two last ones are used by Nvim-R and by nvimcom to
" know that the connections are valid. Unless you are running R in a Neovim's
" built-in terminal (which is the default on Unix), if you use Vim to start R,
" but then close Vim, some variables will become outdated. Additionally, Nvim-R
" sets the value of its internal variable SendCmdToR from SendCmdToR_fake to the
" appropriate value when R is successfully started. It is possible to set the
" values of all those variables and start the TCP client-server manually, but it
" is not practical to do so.
" 
" Please see the explanation on the communication between Vim and R at the end
" of
" 
   " https://github.com/jalvesaq/Nvim-R/blob/master/README.md
" 
" 
" ==============================================================================
							      " *Nvim-R-options*
" 6. Options~
" 
" |R_in_buffer|         Run R in Vim/Neovim built in terminal emulator
" |R_esc_term|          Map <Esc> to go to Normal mode in the terminal buffer
" |R_close_term|        Close terminal buffer after R quited
" |R_hl_term|           Syntax highlight terminal as rout file type
" |R_OutDec|            Set comma as decimal separator in rout files
" |R_term|              External terminal to be used
" |R_term_cmd|          Complete command to open an external terminal
" |R_silent_term|       Do not show terminal errors
" |R_set_home_env|      Set the value of $HOME for R (Windows only)
" |Rtools_path|         Path to Rtools
" |R_save_win_pos|      Save positions of R and GVim windows (Windows only)
" |R_arrange_windows|   Restore positions of R and GVim windows (Windows only)
" |R_assign|            Convert '_' into ' <- '
" |R_assign_map|        Choose what to convert into ' <- '
" |R_rnowebchunk|       Convert '<' into '<<>>=\n@' in Rnoweb files
" |R_rmdchunk|          Convert grave accent chunk into delimiters in Rmd files
" |R_objbr_place|       Placement of Object Browser
" |R_objbr_w|           Initial width of Object Browser window
" |R_objbr_h|           Initial height of Object Browser window
" |R_objbr_opendf|      Display data.frames open in the Object Browser
" |R_objbr_openlist|    Display lists open in the Object Browser
" |R_objbr_allnames|    Display hidden objects in the Object Browser
" |R_objbr_labelerr|    Show error if "label" attribute is invalid
" |R_nvimpager|         Use Vim to see R documentation
" |R_open_example|      Use Vim to display R examples
" |R_editor_w|          Minimum width of R script buffer
" |R_help_w|            Desired width of R documentation buffer
" |R_path|              Directory where R is
" |R_app|, |R_cmd|        Names of R applications
" |R_args|              Arguments to pass to R
" |R_start_libs|        Objects for omnicompletion and syntax highlight
" |Rout_more_colors|    More syntax highlighting in R output
" |R_hi_fun|            Highlight R functions
" |R_hi_fun_paren|      Highlight R functions only if followd by a `(`
" |R_hi_fun_globenv|    Highlight R functions from .GlobalEnv
" |R_routnotab|         Show output of R CMD BATCH in new window
" |R_indent_commented|  Indent lines commented with the \xx command
" |R_rcomment_string|   String to comment code with \xx and \o
" |R_notmuxconf|        Don't use a specially built Tmux config file
" |R_rconsole_height|   Number of lines of R Console
" |R_rconsole_width|    Number of columns of R Console
" |R_min_editor_width|  Minimum number of columns of editor after R start
" |R_applescript|       Use osascript in Mac OS X to run R.app
" |RStudio_cmd|         Run RStudio instead of R.
" |R_listmethods|       Do `nvim.list.args()` instead of `args()`
" |R_specialplot|       Do `nvim.plot()` instead of `plot()`
" |R_paragraph_begin|   Send paragraph from its beginning
" |R_parenblock|        Send lines until closing parenthesis
" |R_bracketed_paste|   Bracket R code in special escape sequences
" |R_source_args|       Arguments to R `source()` function
" |R_commented_lines|   Include commented lines in code sent to `source()`
" |R_latexcmd|          Command to run on .tex files
" |R_texerr|            Show a summary of LaTeX errors after compilation
" |R_sweaveargs|        Arguments do `Sweave()`
" |R_rmd_environment|   Environment in which to save evaluated rmd code
" |R_never_unmake_menu| Do not unmake the menu when switching buffers
" |R_clear_line|        Clear R Console line before sending a command
" |R_editing_mode|      The mode defined in your `~/.inputrc`
" |R_pdfviewer|         PDF application used to open PDF documents
" |R_openpdf|           Open PDF after processing rnoweb file
" |R_openhtml|          Open HTML after processing either Rrst or Rmd
" |R_strict_rst|        Code style for generated rst files
" |R_insert_mode_cmds|  Allow R commands in insert mode
" |R_allnames|          Show names which begin with a dot
" |R_rmhidden|          Remove hidden objects from R workspace
" |R_source|            Source additional scripts
" |R_non_r_compl|       Bibliography completion
" |R_complete|          Include objects in argument completion
" |R_show_args|         Show extra information during omnicompletion
" |R_show_arg_help|     Show extra information during arguments completion
" |R_args_in_stline|    Set 'statusline' to function arguments
" |R_wait|              Time to wait for nvimcom loading
" |R_wait_reply|        Time to wait for R reply
" |R_nvim_wd|           Start R in Vim's working directory
" |R_after_start|       System command to execute after R startup
" |R_user_maps_only|    Only set user specified key bindings
" |R_tmpdir|            Where temporary files are created
" |R_compldir|          Where lists for omnicompletion are stored
" |R_remote_tmpdir|     Mount point of remote temporary directory
" |R_nvimcom_home|      Mount point of remote R library
" |Nvim-R-df-view|      Options for visualizing a data.frame or matrix
" |Nvim-R-SyncTeX|      Options for SyncTeX
" 
" 
" ------------------------------------------------------------------------------
								" *R_esc_term*
								" *R_close_term*
								" *R_hl_term*
								" *R_OutDec*
								" *R_setwidth*
								" *R_in_buffer*
" 6.1. R in Vim/Neovim buffer~
" 
" By default, R runs in a Vim/Neovim buffer created with the command |:term|,
" and the <Esc> key is mapped to stop the Terminal mode and go to Normal mode.
" In Terminal mode, What you type is passed directly to R while in Normal mode
" Vim's navigation commands work as usual (see |motion.txt|).
" 
" If you need the <Esc> key in R, for example if you want to use `vi`, `vim` or
" `nvim` within R Console, put in your |vimrc|:
" >
   " let R_esc_term = 0
" <
" Then, you will have to press the default <C-\><C-N> to go from Terminal to
" Normal mode.
" 
" Nvim-R sets the option "editor" to a function that makes the object to be
" edited in a new tab when `R_esc_term` = 1 (the default value).
" 
" Neovim does not close its built-in terminal emulator when the application
" running in it quits, but Nvim-R does close it for you. If you rather prefer
" that the terminal remains open after R quits, put in your |vimrc|:
" >
   " let R_close_term = 0
" >
" Neovim stops automatically scrolling the R Console if you move the cursor to
" any line that is not the last one. This emulates the behavior of other
" terminal emulator, but considering that (1) R only outputs something after we
" send a command to it, and (2) when we send a command to R, we want to see its
" output, Nvim-R will enter the R Console and move the cursor to its last line
" before sending commands to it, forcing the auto scrolling of the terminal.
" This will trigger an auto command that relies on the cursor moving to the
" terminal window. If you have defined such auto command, you will may want to
" put the line below in your |init.vim| to disable the auto scrolling of the
" terminal:
" >
   " let R_auto_scroll = 0
" <
" You may either use the package colorout (Unix only) to colorize R output or
" let Neovim highlight the terminal contents as it was a .Rout file type. Two
" advantages of colorout are the possibility of highlighting numbers close to
" zero in a different color and the distinction between stdout and stderr. The
" value of R_hl_term (0 or 1) determines whether Neovim should syntax highlight
" the R output, and its default value will be set to 0 if the package colorout
" is loaded. If you prefer do not rely on the auto detection of colorout, you
" should set the value of R_hl_term in your |vimrc|. Example:
" >
   " let R_hl_term = 0
" <
" Right after starting R, Nvim-R will try to detect if either the value of R's
" `OutDec` option is `","` or the current R script sets the `OutDec` option. If
" you are using Neovim to syntax highlight R's output and it is not correctly
" detecting R's `OutDec` option, then, to get numbers correctly recognized, you
" should put in your |vimrc|:
" >
   " let R_OutDec = ','
" <
" On Unix systems, BEFORE sending a command to R Console, if the terminal width
" has changed, Vim/Neovim will send to nvimcom the command `options(width=X)`,
" where X is the new terminal width. You can set the value of R_setwidth to 0 to
" avoid the width being set. Example:
" >
   " let R_setwidth = 0
" <
" On Windows, the command is sent to R Console because it would crash R if sent
" through nvimcom.
" 
" If you have the option 'number' set in your |vimrc|, Nvim-R will calculate the
" number of columns available for R as the window width - 6. If you want a
" different adjustment, you should set `R_setwidth` as a negative value between
" -1 and -16. Example:
" >
   " let R_setwidth = -7
" <
" You can also set the value of `R_setwidth` to `2`. In this case, nvimcom will
" check the value of the environment variable `COLUMNS` AFTER each command is
" executed and if the environment variable exists, R's width option will be set
" accordingly. This is the most precise way of setting the option "width", but
" it has the disadvantage of setting it only after the command is executed. That
" is, the width will be outdated for the first command executed after a change
" in the number of columns of the R Console window.
" 
" Tips:
" 
  " - Use the commands CTRL-W H and CTRL-W K to switch the editor and the R
    " console orientation (vertical and horizontal). See |window-moving| for a
    " complete description of commands.
" 
  " - If you have set the option 'number' and want to disable it just for the
    " built-in terminal emulator, put in your |init.vim|:
" >
    " autocmd TermOpen * setlocal nonumber
" <
    " or in your |vimrc|:
" >
    " autocmd TerminalOpen * setlocal nonumber
" <
  " - If you want to press `gz` in Normal mode to emulate the <C-a>z Tmux
    " command (zoom Window), put the following in your |vimrc|:
" >
    " " Emulate Tmux ^az
    " function ZoomWindow()
        " let cpos = getpos(".")
        " tabnew %
        " redraw
        " call cursor(cpos[1], cpos[2])
        " normal! zz
    " endfunction
    " nmap gz :call ZoomWindow()<CR>
" <
    " Then, you can open the current buffer in a new tab to get it occupying the
    " whole screen.
" 
" If you do not want to run R in Vim/Neovim's built in terminal emulator, you
" have to install Tmux >= 2.0, and then put in your |vimrc|:
" >
   " let R_in_buffer = 0
" <
" Then, R will start in an external terminal emulator (useful if you use two
" monitors and want Vim/Neovim and R separate from each other), and Tmux will be
" used to send commands from Vim/Neovim to R.
" 
" 
" ------------------------------------------------------------------------------
								      " *R_term*
								  " *R_term_cmd*
							       " *R_silent_term*
" 6.2. Terminal emulator (Linux/Unix only)~
" 
" Note: The options of this section are ignored on Mac OS X, where the command
" `open` is called to run the default application used to run shell scripts.
" 
" If |R_in_buffer| = 0 and the X Window System is running and Tmux is installed,
" then R will run in an external terminal emulator. The plugin uses the first
" terminal emulator that it finds in the following list:
" 
    " 1. gnome-terminal,
    " 2. konsole,
    " 3. xfce4-terminal,
    " 4. Eterm,
    " 5. (u)rxvt,
    " 6. aterm,
    " 7. roxterm,
    " 8. lxterminal
    " 9. xterm.
" 
" If Vim does not select your favorite terminal emulator, you may define it in
" your |vimrc| by setting the variable R_term, as shown below:
" >
   " let R_term = 'xterm'
" <
" If your terminal emulator is not listed above, or if you are not satisfied
" with the way your terminal emulator is called by the plugin, you may define in
" your |vimrc| the variable R_term_cmd, as in the examples below:
" >
   " let R_term_cmd = 'xterm -title R -e'
   " let R_term_cmd = 'tilix -a session-add-right -e'
   " let R_term_cmd = 'xfce4-terminal --icon=/path/to/icons/R.png --title=R -x'
" <
" Please, look at the manual of your terminal emulator to know how to call it.
" The last argument must be the one which precedes the command to be executed.
" 
" Note: Terminal emulators that require the command to be executed to be quoted
" (such as `termit`) are not supported.
" 
" The terminal error messages, if any, are shown as warning messages, unless you
" put in your |vimrc|:
" >
   " let R_silent_term = 1
" <
" 
" ------------------------------------------------------------------------------
							         " *Rtools_path*
							      " *R_save_win_pos*
							   " *R_arrange_windows*
							      " *R_set_home_env*
" 6.3. Windows specific options~
" 
" Nvim-R will try to find the path to Rtools installation and add it to the
" beginning of the `PATH` environment variable. If it cannot find the path, or
" if it takes too long to find it, you can put in your |vimrc|:
" >
   " let Rtools_path = "C:\\Rtools"
" <
" By default, Nvim-R will save the positions of R Console and Vim windows
" when you quit R with the <LocalLeader>rq command, and it will restore the
" positions of the windows when you start R. If you do not like this behavior,
" you can put in your |vimrc|:
" >
   " let R_save_win_pos = 0
   " let R_arrange_windows = 0
" <
" If you want R and GVim windows always in a specific arrangement, regardless of
" their state when you have quited R for the last time, you should arrange them
" in the way you want, quit R, change in your |vimrc| only the value of
" R_save_win_pos and, finally, quit Vim.
" 
" The plugin sets `$HOME` as the Windows register value for "Personal" "Shell
" Folders" which is the same value set by R. However, if you have set `$HOME`
" yourself with the intention of changing the default value of `$HOME` assumed
" by R, you will want to put in your |vimrc|:
" >
   " let R_set_home_env = 0
" <
" 
" ------------------------------------------------------------------------------
							       " *R_rnowebchunk*
							       " *R_rmdchunk*
							       " *R_assign_map*
							       " *R_assign*
" 6.4. Assignment operator and Rnoweb completion of code block~
" 
" In Rnoweb files, a `<` is replaced with `<<>>=\n@`. To disable this feature,
" put in your |vimrc|:
" >
   " let R_rnowebchunk = 0
" <
" Similarly, in Rmd files the grave accent is replaced with chunk delimiters
" unless you put in your |vimrc|:
" >
   " let R_rmdchunk = 0
" <
" While editing R code, `_` is replaced with `<-`. If you want to bind other
" keys to be replaced by `<-`, set the value of |R_assign_map| in your
" |vimrc|, as in the example below which emulates RStudio behavior (may only
" work on GVim):
" >
   " let R_assign_map = '<M-->'
" <
" Note: If you are using Vim in a terminal emulator, you have to put in your
" |vimrc|:
" >
   " set <M-->=^[-
   " let R_assign_map = '<M-->'
" <
" where `^[` is obtained by pressing CTRL-V CTRL-[ in Insert mode.
" 
" Note: You can't map <C-=>, as StatET does because in Vim only alphabetic
" letters can be mapped in combination with the CTRL key.
" 
" To completely disable this feature, put in your |vimrc|:
" >
   " let R_assign = 0
" <
" If you need to type many object names with underscores, you may want to change
" the value R_assign to 2. Then, you will have to type two `_` to get
" them converted into `<-`. Alternatively, if the value of R_assign is 3, the
" plugin will run the following command in each buffer containing R code (R,
" Rnoweb, Rhelp, Rrst, and Rmd):
" >
   " iabb <buffer> _ <-
" <
" That is, the underscore will be replaced with the assign operator only if it
" is preceded by a space and followed by a non-word character.
" 
" ------------------------------------------------------------------------------
							    " *R_objbr_w*
							    " *R_objbr_h*
							    " *R_objbr_place*
							    " *R_objbr_opendf*
							    " *R_objbr_openlist*
							    " *R_objbr_allnames*
							    " *R_objbr_labelerr*
" 6.5. Object Browser options~
" 
" By default, the Object Browser will be created at the right of the script
" window, and with 40 columns. Valid values for the Object Browser placement are
" the combination of either "script" or "console" and "right", "left", "above",
" "below", separated by a comma. You can also simply choose "RIGHT", "LEFT",
" "TOP" or "BOTTOM" to start the Object Browser as far as possible to the
" indicated direction. Examples:
" >
   " let R_objbr_place = 'script,right'
   " let R_objbr_place = 'console,left'
   " let R_objbr_place = 'LEFT'
   " let R_objbr_place = 'RIGHT'
" <
" 
" The minimum width of the Object Browser window is 9 columns. You can change
" the object browser's default width by setting the value of |R_objbr_w| in your
" |vimrc|, as below:
" >
   " let R_objbr_w = 30
" <
" If the Object Browser is being created bellow or at the top of the existing
" window, it will be 10 lines high, unless you set its height in your |vimrc|:
" >
   " let R_objbr_h = 20
" <
" Below is an example of setup of some other options in the |vimrc| that
" control the behavior of the Object Browser:
" >
   " let R_objbr_opendf = 1    " Show data.frames elements
   " let R_objbr_openlist = 0  " Show lists elements
   " let R_objbr_allnames = 0  " Show .GlobalEnv hidden objects
   " let R_objbr_labelerr = 1  " Warn if label is not a valid text
" <
" Objects whose names start with a "." are hidden by default. If you want them
" displayed in the Object Browser, set the value of `R_objbr_allnames` to `1`.
" 
" When a `data.frame` appears in the Object Browser for the first time, its
" elements are immediately displayed, but the elements of a `list` are displayed
" only if it is explicitly opened. The options `R_objbr_opendf` and
" `R_objbr_openlist` control the initial status (either opened or closed) of,
" respectively, `data.frames` and `lists`. The options are ignored for
" `data.frames` and `lists` of libraries which are always started closed.
" 
" If an object R's workspace has the attribute `"label"`, it is displayed in
" Vim's Object Browser. If the `"label"` attribute is not of class
" `"character"`, and if  `R_objbr_labelerr` is `1`, an error message is printed
" in the Object Browser.
" 
" 
" ------------------------------------------------------------------------------
							      " *R_open_example*
							      " *R_nvimpager*
							      " *R_editor_w*
							      " *R_help_w*
" 6.6. Vim as pager for R help~
" 
" 6.6.1. Quick setup~
" 
" If you do not want to see R examples in a Vim buffer, put in your |vimrc|:
" >
   " let R_open_example = 0
" <
" If you do not want to see R documentation in a Vim buffer, put in your
" |vimrc|:
" >
   " let R_nvimpager = 'no'
" <
" This option can only be set to "no" in the |vimrc|. It will be automatically
" changed to a suitable value if it is set to "no" after Vim startup.
" 
" If you want to see R documentation in Vim, but are not satisfied with the
" way it works, please, read the subsection 6.6.2 below.
" 
" ------------------------------------------------------------------------------
" 6.6.2. Details and other options:~
" 
" The plugin key bindings will remain active in the documentation buffer, and,
" thus, you will be able to send commands to R as you do while editing an R
" script. You can, for example, use <LocalLeader>rh to jump to another R help
" document.
" 
" The valid values of R_nvimpager are:
" 
   " "tab"       : Show the help document in a new tab. If there is already a
                 " tab with an R help document tab, use it.
                 " This is the default if R_in_buffer = 0.
   " "vertical"  : Split the window vertically if the editor width is large
                 " enough; otherwise, split the window horizontally and attempt
                 " to set the window height to at least 20 lines.
                 " This is the default if R_in_buffer = 1.
   " "horizontal": Split the window horizontally.
   " "tabnew"    : Show the help document in a new tab.
   " "no"        : Do not show R documentation in Vim.
" 
" The window will be considered large enough if it has more columns than
" R_editor_w + R_help_w. These variables control the minimum
" width of the editor window and the help window, and their default values are,
" respectively, 66 and 46. Thus, if you want to have more control over Vim's
" behavior while opening R's documentations, you will want to set different
" values to some variables in your |vimrc|, as in the example:
" >
   " let R_editor_w = 80
   " let R_editor_h = 60
" <
" 
" ------------------------------------------------------------------------------
								      " *R_path*
								      " *R_app*
								      " *R_cmd*
" 6.7. R path and application names~
" 
" Vim will run the first R executable in the path. You can set an alternative
" path to R in your |vimrc| as in the examples:
" >
   " let R_path = '/path/to/my/preferred/R/version/bin'
   " let R_path = "C:\\Program Files\\R\\R-3.3.1\\bin\\i386"
" <
" On Windows, Vim will try to find the R install path in the Windows Registry.
" 
" You can set the path to a different R version for specific R scripts in your
" |vimrc|. Example:
" >
   " autocmd BufReadPre ~/old* let R_path='~/app/R-2.8.1/bin'
" <
" By default the value of `R_app` is `"R"` on Unix systems (such as Linux and
" Mac OS X). On Windows, it is `Rterm.exe` if R is going to run in a Neovim
" buffer and `"Rgui.exe"` otherwise. Nvim-R cannot send messages to `Rterm.exe`
" in an external `cmd` window. If your R binary has a different name (for
" example, if it is called by a custom script), you should set the value of
" `R_app` in your |vimrc|.
" 
" By default the plugin will call the application `R` to run the following
" commands:
" >
   " R CMD build nvimcom
   " R CMD install nvimcom
   " R CMD BATCH current_script.R
" <
" If it is necessary to call a different application to run the above commands
" in your system, you should set the value of `R_cmd` in your |vimrc|.
" 
" 
" ------------------------------------------------------------------------------
								      " *R_args*
" 6.8. Arguments to R~
" 
" Set this option in your |vimrc| if you want to pass command line arguments to
" R at the startup. The value of this variable must be a |List|. Example:
" >
   " let R_args = ['--no-save', '--quiet']
" <
" On Linux, there is no default value for |R_args|. On Windows, the default
" value is `['--sdi']`, but you may change it to `['--mdi']` if you do not like
" the SDI style of the graphical user interface.
" 
" 
" ------------------------------------------------------------------------------
								" *R_start_libs*
" 6.9. Omnicompletion and syntax highlight of R functions~
" 
" The list of functions to be highlighted and the list of objects for
" omnicompletion are built dynamically as the libraries are loaded by R.
" However, you can set the value of R_start_libs if you want that
" the functions and objects of specific packages are respectively highlighted
" and available for omnicompletion even if R is not running yet. By default,
" only the functions of vanilla R are always highlighted. Below is the default
" value of R_start_libs:
" >
   " let R_start_libs = 'base,stats,graphics,grDevices,utils,methods'
" <
" 
" ------------------------------------------------------------------------------
							    " *Rout_more_colors*
							    " *R_hi_fun_globenv*
							    " *R_hi_fun_paren*
							    " *R_hi_fun*
" 6.10. Syntax highlight: functions and .Rout files~
" 
" By default, the R commands in .Rout files are highlighted with the color of
" comments, and only the output of commands has some of its elements highlighted
" (numbers, strings, index of vectors, warnings and errors).
" 
" If you prefer that R commands in the R output are highlighted as they are in R
" scripts, put the following in your |vimrc|:
" >
   " let Rout_more_colors = 1
" <
" When syntax highlighting .Rout files, Nvim-R considers "> " as the prompt
" string and "+ " as the continuation string. If you have defined different
" prompt and continuation strings in your `~./Rprofile`, you should do the same
" in your |vimrc|. Example:
" >
   " let g:Rout_prompt_str = '» '
   " let g:Rout_continue_str = '… '
" <
" By default, Nvim-R highlights the names of R functions even if they are not
" followed by a parenthesis. If you prefer to highlight R functions only if
" the `(` is typed, put in your |vimrc|:
" >
   " let R_hi_fun_paren = 1
" <
" Note: The syntax highlighting is slower when `R_hi_fun_paren` is 1, and,
" depending on your system configuration, the slowness might be noticeable.
" 
" By default, functions from `.GlobalEnv` and other environments in the
" `search()` path whose names do not start with `"package:"` are not highlighted
" to avoid the need of both nvimcom saving a temporary file with the list
" objects in these environments after each command sent to R and Nvim-R reading
" and parsing this file, which might be slow in some machines, and especially if
" R's workspace has too many objects, data.frames with too many columns or lists
" with too many elements. Anyway, if you prefer these functions highlighted, put
" in your |vimrc|:
" >
   " let R_hi_fun_globenv = 1
" <
" The functions from `.GlobalEnv` as well as functions from other environments
" in the search path will be highlighted when created, but the highlighting will
" not be cleared when the functions are deleted because sending commands to R
" could become noticeably slow when editing files with complex syntax highlight
" such as large RMarkdown scripts. Anyway, if you want the syntax highlighting
" of these functions cleared and redone after each command sent to R, put in
" your |vimrc|:
" >
   " let R_hi_fun_globenv = 2
" <
" Functions from environments in the search path are highlighted as functions
" from packages, but in Neovim (not in Vim) you can set a different highlight
" command for them in your |vimrc|, as in the example below:
" >
   " hi rGlobEnvFun ctermfg=117 guifg=#87d7ff cterm=italic gui=italic
" <
" If you prefer to completely disable the syntax highlighting of R functions put
" in your |vimrc|:
" >
   " let R_hi_fun = 0
" <
" On Unix systems, the highlighting of new functions created in the `.GlobalEnv`
" will be interrupted if nvimcom takes more than 500 milliseconds to create the
" list of objects that Nvim-R needs to find and, then, highlight new functions
" (this also affects `ncm-R` completion). If you want that nvimcom be either more
" or less tolerant to delays, put a different value in your |vimrc|. Valid
" values are between 10 and 10000 milliseconds. Example:
" >
   " let R_ls_env_tol = 700
" <
" 
" ------------------------------------------------------------------------------
								 " *R_routnotab*
" 6.11. How to automatically open the .Rout file~
" 
" After the command <LocalLeader>ao, Vim will save the current buffer if it
" has any pending changes, run `R CMD BATCH --no-restore --no-save` on the
" current file and show the resulting .Rout file in a new tab. If you prefer
" that the file is open in a new split window, put in your |vimrc|:
" >
   " let R_routnotab = 1
" <
" 
" ------------------------------------------------------------------------------
							  " *R_indent_commented*
						          " *R_rcomment_string*
" 6.12. Indent commented lines~
" 
" You can type <LocalLeader>xx to comment out a line or selected lines. If the
" line already starts with a comment string, it will be removed. After adding
" the comment string, the line will be reindented by default. To turn off the
" automatic indentation, put in your |vimrc|:
" >
   " let R_indent_commented = 0
" <
" The string used to comment text with <LocalLeader>xc, <LocalLeader>xu,
" <LocalLeader>xx and <LocalLeader>o is defined by R_rcomment_string.
" Example:
" >
   " let R_rcomment_string = '# '
" <
" If the value of `r_indent_ess_comments` is 1, `R_rcomment_string` will be
" overridden and the string used to comment the line will change according to
" the value of `R_indent_commented` ("## " if 0 and "### " if 1; see
" |ft-r-indent|).
" 
" 
" ------------------------------------------------------------------------------
								" *R_notmuxconf*
" 6.13. Tmux configuration (Linux/Unix only)~
" 
" 
" If Vim is running R in an external terminal emulator, R will run in a Tmux
" session with a specially built Tmux configuration file. If you want to use
" your own ~/.tmux.conf, put in your |vimrc|:
" >
   " let R_notmuxconf = 1
" <
" If you opted for using your own configuration file, the plugin will write a
" minimum configuration which will set the value of four environment variables
" required for the communication with R and then source your own configuration
" file (~/.tmux.conf).
" 
" 
" ------------------------------------------------------------------------------
							  " *R_rconsole_height*
							  " *R_rconsole_width*
							  " *R_min_editor_width*
" 6.14. Control of R window~
" 
" When starting R, Neovim's buffer is split vertically if its width is larger
" than:
" >
   " R_min_editor_width + R_rconsole_width + 1 + (&number * &numberwidth)
" <
" That is, if it is large enough to guarantee that both the script and the R
" windows will have at least the desired number of columns even if 'number' is
" set. The default value of both `R_min_editor_width` and `R_rconsole_width` is
" 80. If you prefer the window is always split vertically, set these two options
" with lower values in your |vimrc|. Example:
" >
   " let R_rconsole_width = 57
   " let R_min_editor_width = 18
" <
" You can also set a `R_rconsole_width` relative to current Vim window width.
" For example, if you want to split the available horizontal space evenly
" between Vim and R, put in your |vimrc|:
" >
   " autocmd VimResized * let R_rconsole_width = winwidth(0) / 2
" <
" If you always prefer a horizontal split, set the value of `R_rconsole_width`
" to 0:
" >
   " let R_rconsole_width = 0
" <
" For a horizontal split, you can set the number of lines of the R window:
" >
   " let R_rconsole_height = 15
" <
" You should set 'nosplitright' if you wanted the R Console on the left side,
" and 'nosplitbelow' if you wanted it above the R script.
" 
" Note: If running R in a Neovim buffer, the number of lines and columns will
" automatically change if you switch between horizontal and vertical splits (see
" |CTRL-W_K| and |CTRL-W_H|). You may request Neovim to try to keep the minimum
" width and height of a specific window by setting the options 'winwidth' and
" 'winheight'. So, if the window is split horizontally and you want a small R
" Console window, you should set a large value for 'winheight' in the script
" window.
" 
" 
" ------------------------------------------------------------------------------
							       " *R_applescript*
								 " *RStudio_cmd*
" 6.15. Integration with R.app (OS X only) and RStudio~
" 
" If you are on Mac OS X and want to use the R.app graphical application, put in
" your |vimrc|:
" >
   " let R_in_buffer = 0
   " let R_applescript = 1
" <
" If you want to run RStudio instead of R set in your |vimrc| the value of
" `RStudio_cmd` to the complete path of the RStudio_cmd binary. Example:
" >
   " let R_in_buffer = 0
   " let RStudio_cmd = 'C:\Program Files\RStudio\bin\rstudio'
" <
" Note: You must manually run a successful comand in RStudio Console before
" sending code from Vim to RStudio. The command might be something as simple as
" the number `1`.
" 
" 
" ------------------------------------------------------------------------------
							       " *R_listmethods*
							       " *R_specialplot*
" 6.16. Special R functions~
" 
" The R function `args()` lists the arguments of a function, but not the
" arguments of its methods. If you want that the plugin calls the function
" `nvim.list.args()` after <LocalLeader>ra, you have to add to your |vimrc|:
" >
   " let R_listmethods = 1
" <
" By default, R makes a scatterplot of numeric vectors. The function
" `nvim.plot()` do both a histogram and a boxplot. The function can be called by
" the plugin after <LocalLeader>rg if you put the following line in your
" |vimrc|:
" >
   " let R_specialplot = 1
" <
" 
" ------------------------------------------------------------------------------
							   " *R_paragraph_begin*
							   " *R_parenblock*
							   " *R_bracketed_paste*
" 6.17. Control how paragraphs and lines are sent~
" 
" By default, when you press <LocalLeader>pp Nvim-R sends all contiguous lines to
" R, that is all lines above and below the current one that are not separated by
" an empty line. If you prefer that only lines from the cursor position to the
" end of the paragraph are sent, put in your |vimrc|:
" >
   " let R_paragraph_begin = 0
" <
" If a line has an opening parenthesis, all lines up to the closing parenthesis
" are sent to R when you send a line of code to R. If you prefer to send the
" lines one by one, put in your |vimrc|:
" >
   " let R_parenblock = 0
" <
" Bracketed paste mode will bracket R code in special escape sequences when it
" is being sent to R so that R can tell the differences between stuff that you
" type directly to the console and stuff that you send. It is particularly
" useful when you are using a version of R which is compiled against readline
" 7.0+ or when rice console is used. To enable it, put in your |vimrc|:
" >
   " let R_bracketed_paste = 1
" <
" 
" ------------------------------------------------------------------------------
							       " *R_source_args*
							   " *R_commented_lines*
" 6.18. Arguments to R source() function~
" 
" When you send multiple lines of code to R (a selection of lines, a paragraph,
" code between two marks or an R chunk of code), Nvim-R saves the lines in a
" temporary file and, then, sends to R a command which calls `base::source()` to
" run the commands from the temporary file.
" 
" By default, R's `source()` is called with the arguments `print.eval=TRUE` and
" `spaced=FALSE`. The argument `local=parent.frame()` is passed to `source()`
" too because it is run inside another function the. But you can either add or
" change the arguments passed to it. Examples:
 " >
   " let R_source_args = 'echo = TRUE'
   " let R_source_args = 'print.eval = FALSE, echo = TRUE, spaced = TRUE'
" <
" If you want that commented lines are included in the code to be sourced, put
" in your |vimrc|:
" >
   " let R_commented_lines = 1
" <
" 
" ------------------------------------------------------------------------------
							      " *R_sweaveargs*
							      " *R_latexcmd*
							      " *R_texerr*
							      " *R_cite_pattern*
" 6.19. LaTeX options~
" 
" To produce a pdf document from the .tex file generated by either `Sweave()` or
" `knit()` command, Nvim-R calls:
" >
   " latexmk -pdf -pdflatex="xelatex %O -file-line-error -interaction=nonstopmode -synctex=1 %S"
" <
" If `xelatex` is not installed, it will be replaced with `pdflatex` in the
" above command. If `latexmk` is not installed, Nvim-R will call either
" `xelatex` or `pdflatex` directly.
" 
" You can set the value `R_latexcmd` to change this behavior. `R_latexcmd` is a
" list: its first element is the command to be executed and the remaining
" elements are arguments to be passed to the command. Examples:
" >
   " let R_latexcmd = ['pdflatex']
   " let R_latexcmd = ['xelatex']
   " let R_latexcmd = ['latexmk', '-pdf', '-pdflatex="xelatex %O -synctex=1 %S"']
" <
" The elements of `R_latexcmd` may contain double quotes (as in the last example
" above), but not single quotes, because Nvim-R will use single quotes to
" separate them in an R's `c()` command.
" 
" If you want to pass arguments to the `Sweave()` function, set the value of the
" R_sweaveargs variable.
" 
" If the value of `R_texerr` is `1`, nvmimcom will output to R Console LaTeX
" errors and warnings produced by the compilation of the .tex document into
" .pdf. So, you do not have to scroll the R Console seeking for these messages.
" However, if Nvim-R cannot not find the LaTeX log file because it is not saved
" in the same directory as the Rnoweb, you should set the value of
" `R_latex_build_dir`. Example:
" >
   " let R_latex_build_dir = 'build'
" <
" If you are no using LaTeX-Box omni completion, you can set the value of
" `R_cite_pattern` to control when completion of citation keys is activated.
" Example:
" >
   " let R_cite_pattern = '\\\(cite\|bibentry\)\S*{'
" <
" You do not need to set `R_cite_pattern` if you have already set the value of
" `LatexBox_cite_pattern`.
" 
" ------------------------------------------------------------------------------
							   " *R_rmd_environment*
" 6.20. Rmd environment~
" 
" When rendering an Rmd file, the code can be evaluated (and saved) in a
" specified environment.  The default value is `.GlobalEnv` which makes the
" objects stored in the Rmd file available on the R console.  If you do not want
" the  objects stored in the Rmd file to be available in the global environment,
" you can set
" >
    " let R_rmd_environment = 'new.env()'
" <
" 
" ------------------------------------------------------------------------------
							 " *R_never_unmake_menu*
" 6.21. Never unmake the R menu~
" 
" Use this option if you want that the "R" menu item in GVim is not deleted when
" you change from one buffer to another, for example, when going from a .R file
" to a .txt one:
" >
   " let R_never_unmake_menu = 1
" <
" When this option is enabled all menu items are created regardless of the file
" type.
" 
" 
" ------------------------------------------------------------------------------
							      " *R_clear_line*
							      " *R_editing_mode*
" 6.22. Clear R Console line before sending commands~
" 
" When one types <C-a> in the R Console the cursor goes to the beginning of the
" line and when one types <C-k> the characters to the right of the cursor are
" deleted. This is useful to avoid characters left on the R Console being mixed
" with commands sent by Vim. Nvim-R will add <C-a><C-k> to every command if you
" put in your |vimrc|:
" >
   " let R_clear_line = 1
" <
" Nvim-R reads your `~/.inputrc` and, if it finds the string "set editing-mode
" vi" it will send to R <Esc>0Da instead of <C-a><C-k>. If Nvim-R fails to
" detect that R is running in vi editing mode, you have to put this line in your
" |vimrc|:
" >
   " let R_editing_mode = "vi"
" <
" This might produce a beep when sending commands, and you may want to disable
" the audible bell only for R by putting in your `~/.inputrc`:
" >
   " $if R
       " set bell-style none
   " $else
       " set bell-style audible
   " $endif
" <
" 
" ------------------------------------------------------------------------------
							   " *R_pdfviewer*
							   " *R_openpdf*
							   " *R_openhtml*
" 6.23. Open PDF after processing rnoweb, rmd or rrst files~
" 
" The plugin can automatically open the pdf file generated by pdflatex, after
" either `Sweave()` or `knit()`. This behavior is controlled by the variable
" |R_openpdf| whose value may be 0 (do not open the pdf), 1 (open only
" the first time that pdflatex is called) or a number higher than 1 (always
" open the pdf). For example, if you want that the pdf application is started
" automatically but do not want the terminal (or GVim) losing focus every time
" that you generate the pdf, you should put in put in your |vimrc|:
" >
   " let R_openpdf = 1
" <
" If you use Linux or other Unix and eventually use the system console (without
" the X server) you may want to put in your |vimrc|:
" >
   " if $DISPLAY != ""
       " let R_openpdf = 1
   " endif
" <
" The default value of `R_openpdf` is 1 on Mac OS X and 2 on other systems.
" 
" On Windows, Nvim-R will call Sumatra to open the PDF, and, on Mac OS X, it
" will call Skim. On Linux, you can change the value of R_pdfviewer in your
" |vimrc| to define what PDF viewer will be called. Valid values are "zathura"
" (default, and the one best integrated with Nvim-R), "evince" and "okular".
" 
" If editing an Rmd file, you can produce the html result with <LocalLeader>kr
" or <LocalLeader>kh (it may also work with other file types). The html file
" will be automatically opened if you put the following in your |vimrc|:
" >
   " let R_openhtml = 1
" <
" The meanings of different values of R_openhtml are:
" 
   " 0: Never open the html.
   " 1: Always open the html.
   " 2: Decide between opening the html and reloading the page (Linux only).
" 
" The browser application called by Nvim-R is whatever is returned by the R
" command `getOption("browser")`, unless it is NULL. In this case, Nvim-R will
" call `open` on both Windows and Mac OS X, and `xdg-open` on Linux.
" 
" Most browser will open a new tab each time they are called instead of
" refreshing a document that is already open. Please, see |Nvim-R-reload-html|
" for a workaround.
" 
" If you rather prefer that Nvim-R never tries to open the web browser, put in
" your |vimrc|:
" >
   " let R_openhtml = 0
" <
" 
" ------------------------------------------------------------------------------
							      " *R_rrstcompiler*
							      " *R_strict_rst*
							      " *R_rst2pdfpath*
							      " *R_rst2pdfargs*
" 6.24. Support to RreStructuredText file~
" 
" By default, Nvim-R sends the command `render_rst(strict=TRUE)` to R
" before using R's `knit()` function to convert an Rrst file into an rst one. If
" you prefer the non strict rst code, put the following in your |vimrc|:
" >
   " let R_strict_rst = 0
" <
" You can also set the value of R_rst2pdfpath (the path to rst2pdf
" application), R_rrstcompiler (the compiler argument to be passed to R
" function knit2pdf), and R_rst2pdfargs (further arguments to be passed
" to R function knit2pdf).
" 
" 
" ------------------------------------------------------------------------------
							  " *R_insert_mode_cmds*
" 6.25. Allow R commands in insert mode~
" 
" Nvim-R commands are enabled for Normal mode, but most of them can also be
" enabled in Insert mode. However, depending on your <LocalLeader>, this can
" make it very difficult to write R packages or Sweave files.  For example, if
" <LocalLeader> is set to the `\` character, typing `\dQuote` in a .Rd file
" tries to send the command!
" 
" If you want to enable commands in Insert mode, add the following to your
" |vimrc|:
" >
   " let R_insert_mode_cmds = 1
" <
" See also: |Nvim-R-localleader|.
" 
" 
" ------------------------------------------------------------------------------
								  " *R_allnames*
								  " *R_rmhidden*
" 6.26. Show/remove hidden objects~
" 
" Hidden objects are not included in the list of objects for omni completion. If
" you prefer to include them, put in your |vimrc|:
" >
   " let g:R_allnames = 1
" <
" Hidden objects are removed from R workspace when you do <LocalLeader>rm. If
" you prefer to remove only visible objects, put in your |vimrc|:
" >
   " let g:R_rmhidden = 0
" <
" After removing the objects, Nvim-R will also send CTRL-L to the R Console to
" clear the screen. If you have set vi mode in your `~/.inputrc` you might also
" want to set CTRL-L to clear the screen, as explained at
" 
" https://unix.stackexchange.com/questions/104094/is-there-any-way-to-enable-ctrll-to-clear-screen-when-set-o-vi-is-set
" 
" ------------------------------------------------------------------------------
								    " *R_source*
" 6.27. Source additional scripts~
" 
" This variable should contain a comma separated list of Vim scripts to be
" sourced by Nvim-R. These scripts may provide additional
" functionality and/or change the behavior of Nvim-R. If you have such
" scripts, put in your |vimrc|:
" >
   " let R_source = '~/path/to/MyScript.vim,/path/to/AnotherScript.vim'
" <
" Currently, there is only one script known to extend Nvim-R features:
" 
   " Support to the devtools R package~
   " https://github.com/mllg/vim-devtools-plugin
" 
" 
" ------------------------------------------------------------------------------
							       " *R_non_r_compl*
" 6.28. Completion of non R code~
" 
" Rnoweb~
" 
" The omnicompletion of bibliographic data from bib files requires Python 3 and
" the PyBTeX library for Python 3.
" 
" For Rnoweb documents, omnicompletion of non R code is similar to that provided
" by LaTeX-Box, but better adjusted for an Rnoweb document. The completion of
" citation keys gathers data from `.bib` files in the same directory of the
" current Rnoweb document, and the completion works only if a pattern similar to
" "\cite{" precedes the cursor (see |R_cite_pattern|). Some of the most commonly
" used LaTeX commands are also completed. The completion of the argument for
" both `\ref{}` and `\pageref{}` includes both the label of R chunks where the
" option `fig.cap` was found prefixed with `fig:` and the string attributed to
" the argument `label` in the R code, but only if they begin with the substring
" "tab:".
" 
" If the reference includes the field "file", you can open this file by typing
" <LocalLeader>od in Normal mode with the cursor over the citation key.
" 
" Rmarkdown~
" 
" For RMarkdown documents it is recommended the installation of zotcite for
" completing citation keys directly from Zotero database:
" 
   " https://github.com/jalvesaq/zotcite
" 
" You can also use another plugin to insert citation keys if they use the same
" @zotero_key#your_citation_key scheme for building citation keys. The
" citation.vim plugin does just this, providing a source for Unite:
" 
   " https://github.com/rafaqz/citation.vim
" 
" If zotcite is not installed, Nvim-R will do omni completion of bibliographic
" citation keys from `.bib` files, requiring Python 3 and the PyBTeX library for
" Python 3 to work. Then, Nvim-R will look for bibliographic data in any `.bib`
" file listed in the `bibliography` field of the YAML header. If the
" `bibliography` field is not defined, it will use all `.bib` files that are in
" the same directory of the RMarkdown document as bibliography sources. The list
" of `.bib` files is updated whenever the buffer is saved.
" 
" If the reference includes the field "file", you can open this file by typing
" <LocalLeader>od in Normal mode with the cursor over the citation key.
" 
" If you include Python chunks in your Rmd document, you should put the lines
" below in your |vimrc| to get them highlighted:
" >
   " let g:markdown_fenced_languages = ['r', 'python']
   " let g:rmd_fenced_languages = ['r', 'python']
" <
" You may also want to install the jedi-vim plugin to get omni completion of
" Python code when the cursor is within a Python chunk:
" 
   " https://github.com/davidhalter/jedi-vim
" 
" Lines of Python code are sent to R Console as arguments to
" `reticulate::py_run_string()`. Hence, you must send to R the command
" `library(reticulate)` before sending lines of Python code.
" 
" 
" How to disable~
" 
" To disable the completion of non R code in Rmd and Rnoweb files, and use the
" omni completion provided by another plugin, put in your |vimrc|:
" >
   " let R_non_r_compl = 0
" <
" Then, Nvim-R may use another function to complete non R code, such as the ones
" from vim-pandoc or LaTeX-Box
" 
" If you want a different function for completion of non R code, you should not
" set the value 'omnifunc' in your |vimrc| because you would lose the completion
" of R objects. It is better to use an |autocmd| to set the value of buffer the
" variable `b:rplugin_non_r_omnifunc`. Examples:
" >
   " autocmd FileType rnoweb let b:rplugin_non_r_omnifunc = "g:LatexBox_Complete"
   " autocmd FileType rmd let b:rplugin_non_r_omnifunc = "g:omnifunc=pandoc#completion#Complete"
" <
" Note: On Windows, Nvim-R's bibliographic completion works only with ascii letters.
" 
" 
" ------------------------------------------------------------------------------
								  " *R_complete*
								 " *R_show_args*
							     " *R_show_arg_help*
							    " *R_args_in_stline*
" 6.29. Function arguments~
" 
" During omni completion, triggered by CTRL-X CTRL-O, a preview window shows
" functions' description and usage. If you do not want the preview window,
" put in your |vimrc|:
" >
   " let R_show_args = 0
" <
" When completing function arguments, objects from both R Workspace and loaded
" libraries are included in the list, but only if there no argument to complete.
" You can change this behavior in your |vimrc| as in the examples below:
" >
   " let R_complete = 1 " Include names of objects if there is no argument
   " let R_complete = 2 " Always include names of objects
" <
" During the completion of function arguments, the preview window shows R's
" documentation help for the item being completed unless you put in your
" |vimrc|:
" >
   " let R_show_arg_help = 0
" <
" You can also completely disable the preview window by setting 'completeopt'
" without the `preview` string.
" 
" If you want that function arguments are displayed in Vim's status line when
" you insert `(`, put in your |vimrc|:
" >
   " let R_args_in_stline = 1
" <
" The status line is restored when you either type `)` or leave Insert mode.
" This option is useful only if the window has a status line (see 'laststatus').
" If the string with the list of arguments is longer than the status line width,
" the list is not displayed completely. This argument is incompatible with most
" plugins that changes the status line. It is also incompatible with any plugin
" that automatically closes parentheses. Functions of .GlobalEnv do not have
" their arguments displayed. You can change the appearance of the status line by
" setting the `R_sttline_fmt` (default value = `"%fun(%args)"`, where `%fun` is
" replaced by the function name and `%args` by the list of arguments). See
" 'statusline' to know how to format the status line. The example below put some
" colors in the status line (see |highlight-groups|):
" >
   " let R_sttline_fmt = '%#Function#%fun%#Delimiter#(%#Normal#%args%#Delimiter#)'
" <
" If you knew Vim Language, you could look at the Nvim-R source code (file
" `R/common_global.vim`) and set the value of `R_set_sttline_cmd`. The example
" below sets the color of individual arguments' names to the highlight group
" `Special`:
" >
   " let R_sttline_fmt = '%#Function#%fun%#Normal#(%args)'
   " let R_set_sttline_cmd = "let sline = substitute(sline, " .
           " \ "'\\( \\|(\\)\\(\\w\\.*\\w*\\.*\\w*\\)\\(=*\\)\\(.\\{-}\\)\\([,)]\\)', " .
           " \ "'\\1%#Special#\\2%#Normal#\\3\\4\\5', 'g')"
" 
" 
" ------------------------------------------------------------------------------
								      " *R_wait*
" 6.30. Time to wait for nvimcom loading~
" 
" Nvim-R asynchronously waits 60 seconds for the nvimcom package to be loaded
" during R startup. If 60 seconds are not enough to your R startup, then set a
" higher value for the variable in your |vimrc|. Example:
" >
   " let R_wait = 100
" <
" 
" ------------------------------------------------------------------------------
								" *R_wait_reply*
" 6.31. Time to wait for R reply~
" 
" By default Nvim-R waits 2 seconds for R to reply after a request for omni
" completion is issued. You can set the amount of time Nvim-R waits (in seconds)
" in your |vimrc|.  Example:
" >
   " let R_wait_reply = 5
" <
" 
" ------------------------------------------------------------------------------
								   " *R_nvim_wd*
" 6.32 Start R in working directory of Vim~
" 
" When you are editing an R file (.R, .Rnw, .Rd, .Rmd, .Rrst) and start R, the R
" package nvimcom runs the command `setwd()` with the directory of the file
" being edited as argument, that is, the R working directory becomes the same
" directory of the R file. If you want R's working directory to be the same as
" Vim's working directory, put in your |vimrc|:
" >
   " let R_nvim_wd = 1
" <
" This option is useful only for those who did not enable 'autochdir'.
" 
" If you prefer that Nvim-R does not set the working directory in any way, put
" in |vimrc|:
" >
   " let R_nvim_wd = -1
" <
" 
" ------------------------------------------------------------------------------
							       " *R_after_start*
" 6.33 System command to be executed after R startup~
" 
" If you want that Vim executes a external command right after R startup, set
" the value of R_after_start in your |vimrc|.
" 
" Nvim-R stores the environment variable $WINDOWID of the terminal where R is
" running as $RCONSOLE. Thus, if you are running R in a external terminal
" emulator on Linux, `~/bin` is in your path, and you want to resize and change
" the positions of the terminals containing Vim and R, you may create a
" script `~/bin/after_R_start` similar to the following:
" >
   " #!/bin/sh
   " wmctrl -i -r $RCONSOLE -e 0,0,200,1200,800
   " wmctrl -i -r $WINDOWID -e 0,300,40,1200,800
   " wmctrl -i -r $WINDOWID -b remove,maximized_vert,maximized_horz
" 
" <
" Then, make the script executable, and put in your |vimrc|:
" >
   " let R_in_buffer = 0
   " let R_after_start = 'after_R_start'
" <
" Similarly, on Mac OS X, the script below (developed by songcai) will bring the
" focus to Neovim terminal window:
" >
   " #!/usr/bin/env osascript
" 
   " --Raise the Terminal window containing name ".R".
   " tell application "Terminal"
     " set index of window 1 where name contains ".R" to 1
     " delay 0.05
     " activate window 1
   " end tell
" 
   " --Click the title bar of the raised window to bring focus to it.
   " tell application "System Events"
     " tell process "Terminal"
       " click menu item (name of window 1) of menu of menu bar item "Window" of menu bar 1
     " end tell
   " end tell
" <
" 
" ------------------------------------------------------------------------------
							    " *R_user_maps_only*
" 6.34 Only set key bindings that are user specified~
" 
" The Nvim-R sets many default key bindings.  The user can set custom
" key bindings (|Nvim-R-key-bindings|).  If you wish Nvim-R to only
" set those key-bindings specified by the user, put in your |vimrc|:
" >
    " let R_user_maps_only = 1
" <
" 
" ------------------------------------------------------------------------------
								  " *R_tmpdir*
								  " *R_compldir*
" 6.35 Temporary files directories~
" 
" You can change the directories where temporary files are created and
" stored by setting in your |vimrc| the values of R_tmpdir and
" R_compldir, as in the example below:
" >
   " let R_tmpdir = '/dev/shm/R_tmp_dir'
   " let R_compldir = '~/.cache/Nvim-R'
" <
" The default paths of these directories depend on the operating system. If you
" want to know what they are, while editing an R file, do in Normal mode:
" >
   " :echo g:rplugin.tmpdir
   " :echo g:rplugin.compldir
" <
" 
" ------------------------------------------------------------------------------
							      " *R_remote_tmpdir*
							      " *R_nvimcom_home*
" 6.36 Options for accessing Remote R from local Vim~
" 
" See |Nvim-R-remote|.
" 
" ------------------------------------------------------------------------------
							      " *Nvim-R-df-view*
" 6.37 View a data.frame or matrix~
" 
" The csv.vim plugin helps to visualize and edit csv files, and if it is not
" installed, Nvim-R will warn you about that when you do <LocalLeader>rv.
" If you do not want to install the csv.vim plugin, put in your |vimrc|:
" >
   " let R_csv_warn = 0
" <
" If you rather prefer to see the table in a graphical viewer, you should set
" the value of R_csv_app in your |vimrc|. Examples:
" >
   " let R_csv_app = 'localc'
   " let R_csv_app = 'c:/Program Files (x86)/LibreOffice 4/program/scalc.exe'
" <
" You should prefix the application name with `terminal:` if it is a terminal
" application and you want to run it in Vim/Neovim's built in terminal emulator.
" Example:
" >
   " let R_csv_app = 'terminal:scim'
" <
" If you are running Vim/Neovim within Tmux, you may prefer:
" >
   " let R_csv_app = 'tmux new-window scim --txtdelim="\t"'
" <
" If the default field delimiter causes problems in your case, you can change it
" in your |vimrc|. Valid values are `"\t"`, `";"` and `","`. Example:
" >
   " let R_csv_delim = ','
" <
" There is also the option of configuring Nvim-R to run an R command to
" display the data. Example:
" >
   " let R_df_viewer = "relimp::showData(%s, font = 'Courier 14')"
" <
" The value of R_df_viewer is a string and the substring `%s` is replaced by the
" name of the object under the cursor.
" 
" 
" ------------------------------------------------------------------------------
							      " *Nvim-R-SyncTeX*
" 6.38 SyncTeX support~
" 
" SyncTeX is a set of communication systems used by some PDF viewers and by some
" text editors which allow users to jump from a specific line in the text editor
" to the corresponding line in the PDF viewer and vice-versa. The Nvim-R
" has support for the SyncTeX systems of five applications:
" 
   " Linux:   Zathura, Evince and Okular
   " OS X:    Skim
   " Windows: SumatraPDF
" 
" On Linux, the application `wmctrl` is required to raise both the PDF viewer
" and Vim windows.
" 
" To completely disable SyncTeX support, put in your |vimrc|:
" >
   " let R_synctex = 0
" <
" You do not have to do anything special in your Rnoweb document if you are
" using the knitr package, and are editing single file Rnoweb documents.
" Otherwise, keep reading...
" 
" If you use `Sweave()` rather than `knit()`, you must put in your Rnoweb
" document:
" >
   " \SweaveOpts{concordance=TRUE}
" <
" If you work with a master document and child subdocuments, each child
" subdocument (TeX and Rnoweb alike) should include the following line:
" >
   " % !Rnw root = master.Rnw
" <
" where `master.Rnw` must be replaced with the name of the actual master
" document.
" 
" Note: The current knitr package (version 1.7) has at least two limitations:
" 
   " - It has no SyncTeX support for child documents. The correspondence data
     " point to lines right below child chunks in the master document and not to
     " somewhere in the child documents themselves. See:
     " https://github.com/yihui/knitr/issues/225
" 
   " - It only starts registering the concordance after the first chunk. So, it
     " is recommended that you put the first chunk of R code just after the
     " `\begin{document}` command.
" 
" 
" ------------------------------------------------------------------------------
" 6.38.1 Okular configuration~
" 
" In Okular, do the mouse clicks described below and fill the field "Command"
" from "Custom Text Editor" as exemplified:
" >
     " Settings
     " Configure Okular
     " Editor
     " Dropdown menu: Custom Text Editor
           " Command: nclientserver '%f' %l
" <
" Note: If the PDF document is already open the first time that you jump to it,
" and if Okular was not started with the `--unique` argument, another instance
" of Okular will be started.
" 
" 
" ------------------------------------------------------------------------------
" 6.38.2 Skim configuration~
" 
" In Skim, click in the drop down menu and fill the fields:
" >
   " Skim
   " Settings
   " Sync
   " Preset: Custom
   " Command: nclientserver
   " Arguments: '%file' %line
" <
" 
" ------------------------------------------------------------------------------
" 6.38.3 Qpdfview configuration~
" 
" Qpdfview is only partially supported: SyncTeX backward does not work with file
" paths containing spaces, and the qpdfview window is not automatically raised
" during SyncTeX forward search. If you want to use it despite these
" limitations, click in its drop down menu as illustrated below and fill the
" field Source editor:
" >
   " Edit
   " Settings
   " Source editor: nclientserver %1 %2
" <
" 
" ==============================================================================
							 " *Nvim-R-key-bindings*
" 7. Custom key bindings~
" 
" When creating custom key bindings for Nvim-R, it is necessary to
" create three maps for most functions because the way the function is called is
" different in each Vim mode. Thus, key bindings must be made for Normal mode,
" Insert mode, and Visual mode.
" 
" To customize a key binding you should put in your |vimrc| something like:
" >
   " nmap <LocalLeader>sr <Plug>RStart
   " imap <LocalLeader>sr <Plug>RStart
   " vmap <LocalLeader>sr <Plug>RStart
" <
" The above example shows how to change key binding used to start R from
" <LocalLeader>rf to <LocalLeader>sr. After changing the maps in your |vimrc|,
" you have to restart Vim.
" 
" Only the custom key bindings for Normal mode are shown in Vim's menu, but
" you can type |:map| to see the complete list of current mappings, and below is
" the list of the names for custom key bindings (the prefix RE means "echo"; RD,
" "cursor down"; RED, both "echo" and "down"):
" 
   " Star/Close R~
   " RStart
   " RCustomStart
   " RClose
   " RSaveClose
" 
   " Clear R console~
   " RClearAll
   " RClearConsole
" 
   " Edit R code~
   " RSimpleComment
   " RSimpleUnComment
   " RToggleComment
   " RRightComment
   " RIndent
   " RNextRChunk
   " RPreviousRChunk
" 
   " Send line or part of it to R~
   " RSendLine
   " RDSendLine
   " RSendLAndOpenNewOne
   " RNLeftPart
   " RNRightPart
   " RILeftPart
   " RIRightPart
   " RDSendLineAndInsertOutput
" 
   " Send code to R console~
   " RSendSelection
   " RESendSelection
   " RDSendSelection
   " REDSendSelection
   " RSendSelAndInsertOutput
   " RSendMBlock
   " RESendMBlock
   " RDSendMBlock
   " REDSendMBlock
   " RSendParagraph
   " RESendParagraph
   " RDSendParagraph
   " REDSendParagraph
   " RSendFunction
   " RESendFunction
   " RDSendFunction
   " REDSendFunction
   " RSendFile
" 
   " Send command to R~
   " RHelp
   " RPlot
   " RSPlot
   " RShowArgs
   " RShowEx
   " RShowRout
   " RObjectNames
   " RObjectPr
   " RObjectStr
   " RViewDF
   " RDputObj
   " RPrintObj
   " RSetwd
   " RSummary
   " RListSpace
" 
   " Support to Sweave and knitr~
   " RSendChunk
   " RDSendChunk
   " RESendChunk
   " REDSendChunk
   " RSendChunkFH (from the first chunk to here)
   " RBibTeX    (Sweave)
   " RBibTeXK   (Knitr)
   " RSweave
   " RKnit
   " RMakeHTML
   " RMakePDF   (Sweave)
   " RMakePDFK  (Knitr)
   " RMakePDFKb (.Rmd, beamer)
   " RMakeODT   (.Rmd, Open document)
   " RMakeWord  (.Rmd, Word document)
   " RMakeRmd   (rmarkdown default)
   " RMakeAll   (rmarkdown all in yaml)
   " ROpenPDF
   " RSyncFor   (SyncTeX search forward)
   " RGoToTeX   (Got to LaTeX output)
   " RSpinFile
   " RNextRChunk
   " RPreviousRChunk
" 
   " Open attachment of bib item~
   " ROpenRefFile
" 
   " Object browser~
   " RUpdateObjBrowser
   " ROpenLists
   " RCloseLists
" 
" The completion of function arguments only happens in Insert mode.
" 
" The plugin also contains a function called RAction which allows you to build
" ad-hoc commands to R. This function takes the name of an R function such as
" "levels" or "table" and the word under the cursor, and passes them to R as a
" command.
" 
" For example, if your cursor is sitting on top of the object called gender and
" you call the RAction function, with an argument such as levels, Vim will
" pass the command `levels(gender)` to R, which will show you the levels of the
" object gender. To make it even easier to use this and other functions, you
" could write custom key bindings in your |vimrc|, as in the examples below:
" >
   " nmap <silent> <LocalLeader>rk :call RAction("levels")<CR>
   " nmap <silent> <LocalLeader>t :call RAction("tail")<CR>
   " nmap <silent> <LocalLeader>H :call RAction("head")<CR>
   " nmap <silent> <LocalLeader>h :call RAction("head", "@,48-57,_,.")<CR>
" <
" The second, and optional, argument that can be passed to RAction is the value
" of 'iskeyword' that will be used to get the word under cursor (see the last
" example above).
" 
" If you want an action over an selection, then the second argument must be the
" string `"v"`:
" >
   " vmap <silent> <LocalLeader>h :call RAction("head", "v")<CR>
" <
" In this case, the beginning and the end of the selection must be in the same
" line.
" 
" If either a second or a third optional argument starts with a comma, it will
" be inserted as argument(s) to the RAction function. Examples:
" >
   " nmap <silent> <LocalLeader>h :call RAction('head', ', n = 10')<CR>
   " nmap <silent> <LocalLeader>t :call RAction('tail', ', n = 10, addrownums = FALSE')<CR>
" <
" If the command that you want to send does not require an R object as argument,
" you can create a shortcut to it by following the example:
" >
   " map <silent> <LocalLeader>s :call g:SendCmdToR("search()")<CR>
" <
" See also: |R_source|.
" 
" 
" ==============================================================================
							      " *Nvim-R-license*
" 8. License~
" 
" The Nvim-R is free software; you can redistribute it and/or modify it
" under the terms of the GNU General Public License as published by the Free
" Software Foundation; either version 2 of the License, or (at your option) any
" later version.
" 
" The Nvim-R is distributed in the hope that it will be useful, but
" WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
" FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
" details.
" 
" A copy of the GNU General Public License is available at
" http://www.r-project.org/Licenses/
" 
" 
" ==============================================================================
								 " *Nvim-R-tips*
" 9. FAQ and tips~
" 
" 9.1. How to start and quit R automatically?~
" 
" If you want that R is started automatically when you start editing an R
" script, you should create in |vimrc| auto commands for each R file type that
" you usually edit. However, you should try to start R only if it is not already
" started. Examples for R and RMarkdown:
" >
   " autocmd FileType r if string(g:SendCmdToR) == "function('SendCmdToR_fake')" | call StartR("R") | endif
   " autocmd FileType rmd if string(g:SendCmdToR) == "function('SendCmdToR_fake')" | call StartR("R") | endif
" <
" And if you want to quit automatically when quiting Vim, put in your |vimrc|
" (replace `"nosave"` with `"save"` if you want to save R's workspace):
" >
   " autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif
" <
" 
" 9.2. Is it possible to stop R from within Vim?~
" 
" Yes. In Normal mode do `:RStop` and Vim will send SIGINT to R which is the
" same signal sent when you press CTRL-C into R's Console.
" 
" 
" ------------------------------------------------------------------------------
" 9.3. Html help and custom pager~
" 
" If you prefer to see help pages in an html browser, put in your `~/.Rprofile`:
" >
   " options(help_type = "html")
" <
" and in your |vimrc| (see |R_nvimpager|):
" >
   " let R_nvimpager = 'no'
" <
" 
" ------------------------------------------------------------------------------
							    " *Nvim-R-showmarks*
" 9.4. How do marked blocks work?~
" 
" Vim allows you to put several marks (bookmarks) in buffers (see |mark|). The
" most commonly used marks are the lowercase alphabet letters. If the cursor is
" between any two marks, the plugin will send the lines between them to R if you
" press <LocalLeader>bb. If the cursor is above the first mark, the plugin will
" send from the beginning of the file to the mark. If the cursor is below the
" last mark, the plugin will send from the mark to the end of the file. The mark
" above the cursor is included and the mark below is excluded from the block to
" be sent to R. To create a mark, press m<letter> in Normal mode.
" 
" We recommended the use of either ShowMarks or vim-signature which show what
" lines have marks defined. The plugins are available at:
" 
   " http://www.vim.org/scripts/script.php?script_id=152
   " https://github.com/kshenoy/vim-signature
" 
" ------------------------------------------------------------------------------
							     " *Nvim-R-snippets*
" 9.5. Use snipMate~
" 
" You probably will want to use the snipMate plugin to insert snippets of code
" in your R script. The plugin may be downloaded from:
" 
   " http://www.vim.org/scripts/script.php?script_id=2540
" 
" The snipMate plugin does not come with snippets for R, but you can copy the
" files r.snippets and rmd.snippets that ship with Nvim-R (look at the R
" directory) to the snippets directory. The files have only a few snippets, but
" they will help you to get started. If you usually edit rnoweb files, you may
" also want to create an rnoweb.snippets by concatenating both tex.snippets and
" r.snippets. If you edit R documentation, you may want to create an
" rhelp.snippets
" 
" 
" ------------------------------------------------------------------------------
							     " *Nvim-R-bindings*
" 9.6. Easier key bindings for most used commands~
" 
" The most used commands from Nvim-R probably are "Send line" and "Send
" selection". You may find it a good idea to map them to the space bar in your
" |vimrc| (suggestion made by Iago Mosqueira):
" >
   " vmap <Space> <Plug>RDSendSelection
   " nmap <Space> <Plug>RDSendLine
" <
" If you want to press <C-Enter> to send lines to R, see:
" 
   " https://github.com/jalvesaq/Nvim-R/issues/64
" 
" You may also want to remap <C-x><C-o>:
" 
   " http://stackoverflow.com/questions/2269005/how-can-i-change-the-keybinding-used-to-autocomplete-in-vim
" 
" Note: Not all mappings work in all versions of Vim. Some mappings may not
" work on GVim on Windows, and others may not work on Vim running in a
" terminal emulator or in Linux Console. The use of <Shift>, <Alt> and <Fn> keys
" in mappings are particularly problematic.
" 
" 
" ------------------------------------------------------------------------------
							  " *Nvim-R-localleader*
" 9.7. Remap the <LocalLeader>~
" 
" People writing Rnoweb documents may find it better to use a comma or other key
" as the <LocalLeader> instead of the default backslash (see |maplocalleader|).
" For example, to change the <LocalLeader> to a comma, put at the beginning of
" your |vimrc| (before any mapping command):
" >
   " let maplocalleader = ','
" <
" 
" ------------------------------------------------------------------------------
							     " *Nvim-R-tagsfile*
" 9.8. Use a tags file to jump to function definitions~
" 
" Vim can jump to a function definition if it finds a "tags" file with the
" information about the place where the function is defined. To generate the
" tags file, use the R function `rtags()`, which will build an Emacs tags file.
" You can use the nvimcom function `etags2ctags()` to convert the Emacs tags
" file into a Vim one. To jump to a function definition, put the cursor over
" the function name and hit CTRL-]. Please, read |tagsrch.txt| for details on
" how to use tags files, specially the section |tags-option|.
" 
" You could, for example, download and unpack R's source code, start R inside
" the ~/.cache/Nvim-R directory and do the following commands:
" >
   " rtags(path = "/path/to/R/source/code", recursive = TRUE, ofile = "RTAGS")
   " etags2ctags("RTAGS", "Rtags")
" <
" Then, you would quit R and do the following command in the terminal emulator:
" >
   " ctags --languages=C,Fortran,Java,Tcl -R -f RsrcTags /path/to/R/source/code
" <
" Finally, you would put the following in your |vimrc|, optionally inside an
" |autocmd-group|:
" >
   " autocmd FileType r set tags+=~/.cache/Nvim-R/Rtags,~/.cache/Nvim-R/RsrcTags
   " autocmd FileType rnoweb set tags+=~/.cache/Nvim-R/Rtags,~/.cache/Nvim-R/RsrcTags
" <
" Note: While defining the autocmd, the Rtags path must be put before RsrcTags.
" 
" Example on how to test whether your setup is ok:
" 
   " 1. Type `mapply()` in an R script and save the buffer.
   " 2. Press CTRL-] over "mapply" (Vim should jump to "mapply.R").
   " 3. Locate the string "do_mapply", which is the name of a C function.
   " 4. Press CTRL-] over "do_mapply" (Vim sould jump to "mapply.c").
" 
" 
" ------------------------------------------------------------------------------
							      " *Nvim-R-folding*
" 9.9. Folding setup~
" 
" Vim has several methods of folding text (see |fold-methods| and
" |fold-commands|). To enable the syntax method of folding for R files, put in
" your |vimrc|:
" >
   " let r_syntax_folding = 1
" <
" With the above option, Vim will load R files with all folds closed. If you
" prefer to start editing files with all folds open, put in your |vimrc|:
" >
   " set nofoldenable
" <
" Notes: (1) Enabling folding may slow down Vim. (2) Folding is not a file
" type plugin option. It is a feature defined in syntax/r.vim.
" 
" Note: Indentation of R code is very slow because the indentation algorithm
" sometimes goes backwards looking for an opening parenthesis or brace or for
" the beginning of a `for`, `if` or `while` statement. This is necessary because
" the indentation level of a given line depends on the indentation level of the
" previous line, but the previous line is not always the line above. It's the
" line where the statement immediately above started. Of course someone may
" develop a better algorithm in the future.
" 
" 
" ------------------------------------------------------------------------------
" 9.10. Highlight chunk header as R code~
" 
" By default, Vim will highlight chunk headers of RMarkdown and
" RreStructuredText with a single color. When the code is processed by knitr,
" chunk headers should contain valid R code and, thus, you may want to highlight
" them as such. You can do this by putting in your |vimrc|:
" >
   " let rrst_syn_hl_chunk = 1
   " let rmd_syn_hl_chunk = 1
" <
" 
" ------------------------------------------------------------------------------
" 9.11. Automatically close parenthesis~
" 
" Some people want Vim automatically inserting a closing parenthesis, bracket
" or brace when an open one has being typed. The page below explains how to
" achieve this goal:
" 
   " http://vim.wikia.com/wiki/Automatically_append_closing_characters
" 
" 
" ------------------------------------------------------------------------------
" 9.12. Automatic line breaks~
" 
" By default, while editing R code, Vim does not break lines when you are
" typing if you reach the column defined by the 'textwidth' option. If you
" prefer that Vim breaks the R code automatically put in your |vimrc|:
" >
   " autocmd FileType r setlocal formatoptions+=t
" <
" 
" ------------------------------------------------------------------------------
" 9.13. Run your Makefile from within R~
" 
" Do you have many Rnoweb files included in a master tex or Rnoweb file and use
" a Makefile to build the pdf? You may consider it useful to put the following
" line in your |vimrc|:
" >
   " nmap <LocalLeader>sm :update<CR>:call g:SendCmdToR('system("make")')<CR>
" <
" 
" ------------------------------------------------------------------------------
							     " *Nvim-R-Rprofile*
" 9.14. Edit your ~/.Rprofile~
" 
" You may want to edit your `~/.Rprofile` in addition to considering the
" suggestions of |Nvim-R-R-setup| you may also want to put the following
" lines in your `~/.Rprofile` if you are using Linux:
" >
   " grDevices::X11.options(width = 4.5, height = 4, ypos = 0,
                          " xpos = 1000, pointsize = 10)
" <
" The `X11.options()` is used to choose the position and dimensions of the X11
" graphical device. You can also install the application wmctrl and create
" shortcuts in your desktop environment to the commands
" >
   " wmctrl -r "R Graphics" -b add,above
   " wmctrl -r "R Graphics" -b remove,above
" <
" which will toggle the "always on top" state of the X11 device window.
" Alternatively, you can right click on the X11 device window title bar and
" choose "Always on top". This is useful to emulate a feature present in R IDEs
" which can display R plots in a separate panel. Although we can not embed an R
" graphical device in Vim, we can at least make it always visible over the
" terminal emulator or the GVim window.
" 
" And add this to your `~/.Rprofile` if you want to use `w3m`, a text based web
" browser, to navigate through R docs after `help.start()` when you cannot run a
" graphical web browser (e.g. when you are in the Linux console):
" >
   " if(interactive() && Sys.info()[["sysname"]] == "Linux" && Sys.getenv("DISPLAY") == ""){
       " if(Sys.getenv("TMUX") != "")
           " options(browser = function(u) system(paste0("tmux new-window 'w3m ", u, "'")))
       " else if(Sys.getenv("NVIMR_TMPDIR") != "")
           " options(browser = function(u) .C("nvimcom_msg_to_nvim",
                                            " paste0('StartTxtBrowser("w3m", "', u, '")')))
   " }
" <
" 
" ------------------------------------------------------------------------------
" 9.15. Debugging R functions~
" 
" The Nvim-R-Plugin does not have debugging facilities, but you may want to use
" the R package "debug":
" >
   " install.packages("debug")
   " library(debug)
   " mtrace(function_name)
" <
" If you receive a message about the package not being available on CRAN, you
" could try:
" >
   " install.packages("https://cran.r-project.org/src/contrib/Archive/debug/debug_1.3.1.tar.gz",
   " repos = NULL, type = "source")
" 
" Once the library is installed and loaded, you should use
" `mtrace(function_name)` to enable the debugging of a function. Then, the next
" time that the function is called it will enter in debugging mode. Once
" debugging a function, you can hit <Enter> to evaluate the current line,
" `go(n)` to go to line `n` in the function and `qqq()` to quit the function
" (See debug's help for details). A useful tip is to click on the title bar of
" the debug window and choose "Always on top" or a similar option provided by
" your desktop manager.
" 
" 
" ------------------------------------------------------------------------------
							    " *Nvim-R-latex-box*
" 9.16. Integration with LaTeX-Box~
" 
" LaTeX-Box does not automatically recognize Rnoweb files as a valid LaTeX file.
" You have to tell LaTeX-Box that the .tex file compiled by either `knitr()` or
" `Sweave()` is the main LaTeX file. You can do this in two ways. Suppose that
" your Rnoweb file is called report.Rnw... You can:
" 
   " (1) Create an empty file called "report.tex.latexmain".
" 
   " or
" 
   " (2) Put in the first 5 lines of report.Rnw:
" >
   " % For LaTeX-Box: root = report.tex
" <
   " or
" 
   " (3) If you do not use child rnoweb documents, put in your |vimrc|:
" >
   " autocmd FileType rnoweb let b:main_tex_file = substitute(expand("%"), "\....$", ".tex", "")
" <
" Of course you must run either `knitr()` or `Sweave()` before trying LaTeX-Box
" omnicompletion. Please, read LaTeX-Box documentation for more information.
" 
" 
" See also: |R_latexcmd|.
" 
" 
" ------------------------------------------------------------------------------
							  " *Nvim-R-quick-setup*
" 9.17. Suggested setup for Nvim-R~
" 
" Please, look at section |Nvim-R-options| if you want information about the
" Nvim-R customization.
" 
" Here are some suggestions of configuration for Vim/Neovim. To understand what
" you are doing, and change the configuration to your taste, please read this
" document from the beginning.
" 
   " ~/.vimrc or ~/.config/nvim/init.vim or ~\AppData\Local\nvim\init.vim~
" >
   " " Change Leader and LocalLeader keys:
   " let maplocalleader = ','
   " let mapleader = ';'
" 
   " " Use Ctrl+Space to do omnicompletion:
   " if has('nvim') || has('gui_running')
       " inoremap <C-Space> <C-x><C-o>
   " else
       " inoremap <Nul> <C-x><C-o>
   " endif
" 
   " " Press the space bar to send lines and selection to R:
   " vmap <Space> <Plug>RDSendSelection
   " nmap <Space> <Plug>RDSendLine
" <
" 
" ------------------------------------------------------------------------------
								 " *rout_colors*
" 9.18. Syntax highlight of .Rout files~
" 
" You can set the both foreground background colors of R output in your |vimrc|.
" The example below is for either a gui version of Vim or a terminal
" interface of Neovim with 'termguicolors' (see |true-color|):
" >
   " if has('gui_running') || &termguicolors
     " let rout_color_input    = 'guifg=#9e9e9e'
     " let rout_color_normal   = 'guifg=#ff5f00'
     " let rout_color_number   = 'guifg=#ffaf00'
     " let rout_color_integer  = 'guifg=#feaf00'
     " let rout_color_float    = 'guifg=#fdaf00'
     " let rout_color_complex  = 'guifg=#fcaf00'
     " let rout_color_negnum   = 'guifg=#d7afff'
     " let rout_color_negfloat = 'guifg=#d6afff'
     " let rout_color_date     = 'guifg=#00d7af'
     " let rout_color_true     = 'guifg=#5dd685'
     " let rout_color_false    = 'guifg=#ff5d5e'
     " let rout_color_inf      = 'guifg=#10aed7'
     " let rout_color_constant = 'guifg=#5fafcf'
     " let rout_color_string   = 'guifg=#5fd7af'
     " let rout_color_error    = 'guifg=#ffffff guibg=#c40000'
     " let rout_color_warn     = 'guifg=#d00000'
     " let rout_color_index    = 'guifg=#d0d080'
   " endif
" <
" If you are running Vim with support for 256 colors, you could use lines like
" these:
" >
   " if &t_Co == 256
     " let rout_color_input    = 'ctermfg=247'
     " let rout_color_normal   = 'ctermfg=39'
     " " etc.
   " endif
" <
" You can also set both true colors and 256 colors at the same time:
" >
   " let rout_color_input    = 'ctermfg=247 guifg=#9e9e9e'
   " let rout_color_normal   = 'ctermfg=39 guifg=#ff5f00'
   " " etc.
" <
" To know what number corresponds to your preferred color (among the 256
" possibilities), hover you mouse pointer over the table of colors built by:
" >
   " library("colorout")
   " show256Colors()
" <
" If you prefer that R output is highlighted using you current |:colorscheme|,
" put in your |vimrc|:
" >
   " let rout_follow_colorscheme = 1
" <
" 
" ------------------------------------------------------------------------------
							       " *Nvim-R-global*
" 9.19 Enable the plugin when editing any file type~
" 
" Nvim-R is a file-type plugin. This means that its functionalities will be
" available only when an R file type is being edited (R, Rnoweb, Rhelp, Rmd,
" etc). However, if you need to run R with other file types, you can put in your
" |vimrc|:
" >
   " command RStart let oldft=&ft | set ft=r | exe 'set ft='.oldft | let b:IsInRCode = function("DefaultIsInRCode") | normal <LocalLeader>rf
" <
" The above Vim line will create the Normal mode command `:RStart` which when
" run will:
" 
  " 1. Set the file-type of the buffer being edited as "r" and, consequently,
     " enable Nvim-R.
" 
  " 2. Set the file-type back to its original value.
" 
  " 3. Avoid an internal error when you type "_".
" 
  " 4. Start R.
" 
" 
" ------------------------------------------------------------------------------
							  " *Nvim-R-reload-html*
" 9.20 Auto refresh HTML page~
" 
" Nvim-R gets the value of R's "browser" option (as returned by
" `getOption("browser")` to open an HTML document. The problem is that most
" browsers always open a new tab instead of refreshing a tab where the document
" is already open. One solution for this issue is to create a script to refresh
" the tab and set the value of the `browser` option to this script. For example,
" on Linux, if you create the script at `~/bin/reload_html` and make it
" executable, and if the `~/bin` directory is in your PATH, you could put in
" your `~/.Rprofile`:
" >
   " options(browser = "reload_html")
" <
" The contents of `reload_html` could be:
" >
   " #!/bin/sh
" 
   " # Get the document title because Firefox use it in the window name
   " WINNAME=`grep '<title>.*</title>' "$1" | sed -e 's/.*<title>\(.*\)<\/title>.*/\1/'`
" 
   " # If the title is empty, use the file name
   " if [ "x$WINNAME" = "x" ]
   " then
       " WINNAME=$1
   " fi
" 
   " # Check if the page is already open
   " xdotool search --name "$WINNAME" windowactivate --sync
" 
   " if [ "$?" = "0" ]
   " then
       " # The page is open; emulate the F5 key press to refresh it:
       " xdotool search --name "$WINNAME" key --clearmodifiers F5
   " else
       " # Start the browser
       " firefox "$1" &
   " fi
" <
" The above script requires that `xdotool` is installed, and it works with
" Firefox. If you prefer Google-Chrome, just replace `firefox` with
" `google-chrome`. Other browsers might require further adjustments. The script
" will not work on Mac OS X because both Firefox and Google-Chrome run on the
" native OS X environment, and the `xdotool` application can manipulate only
" applications running on the X Server.
" 
" For examples of Mac OS X scripts, please, see:
" 
   " https://gist.github.com/itissid/0725fc55ae837dcb0b40ce1b65511d50
" 
" and
" 
   " https://gist.github.com/itissid/e167e079fddc07a5b528b6bf8dbea784
" 
" 
" ------------------------------------------------------------------------------
							       " *Nvim-R-remote*
" 9.21 Remote access~
" 
" The easiest way of running R in a remote machine is logging into the remote
" machine through ssh, starting Neovim and running R in a Neovim's terminal (the
" default). You will only need both Vim (or Neovim) and R configured as usual in
" the remote machine.
" 
" However, if you need to start either Neovim or Vim in the local machine and
" run R in the remote machine, then, a lot of additional configuration is
" required to enable full communication between Vim and R because by default
" both Nvim-R and nvimcom only accept TCP connections from the local host, and,
" R saves temporary files in the `/tmp` directory of the machine where it is
" running. To make the communication between local Vim and remote R possible,
" each application have to know the IP addres of the other, and some remote
" directories must be mounted locally. Here is an example of how to achieve this
" goal (tested on April, 2017).
" 
   " 1. Setup the remote machine to accept ssh login from the local machine
      " without password (search the Internet to discover how to do it).
" 
   " 2. At the remote machine:
" 
      " - You have to edit your `~/.Rprofile` to create the environment variable
	" `R_IP_ADDRESS`. R will save this value in a file that Vim has to read
	" to be able to send messages to R. If the remote machine is a Linux
	" system, the following code might work:
" >
	" # Only create the environment variable R_IP_ADDRESS if NVIM_IP_ADDRESS
	" # exists, that is, if R is being controlled remotely:
        " if(interactive() && Sys.getenv("NVIM_IP_ADDRESS") != ""){
            " Sys.setenv("R_IP_ADDRESS" = trimws(system("hostname -I", intern = TRUE)))
        " }
" <
	" If the code above does not work, you have to find a way of discovering
	" the IP address of the remote machine (perhaps parsing the output of
	" `ifconfig`).
" 
   " 3. At the local machine:
" 
      " - Make the directories `~/.remoteR/NvimR_cache` and `~/.remoteR/R_library`.
" 
      " - Create the shell script `~/bin/mountR` with the following contents,
	" and make it executable (of course, replace `remotelogin`, `remotehost`
	" and the path to R library with valid values for your case):
" >
       " #!/bin/sh
       " sshfs remotelogin@remotehost:/home/remotelogin/.cache/Nvim-R ~/.remoteR/NvimR_cache
       " sshfs remotelogin@remotehost:/home/remotelogin/R/x86_64-pc-linux-gnu-library/3.3 ~/.remoteR/R_library
" <
      " - Create the shell script `~/bin/sshR` with the following contents, and
	" make it executable (replace `remotelogin` and `remotehost` with the
	" real values):
" >
        " #!/bin/sh
        " ssh -t remotelogin@remotehost "PATH=/home/remotelogin/bin:\$PATH \
	    " NVIMR_COMPLDIR=~/.cache/Nvim-R \
	    " NVIMR_TMPDIR=~/.cache/Nvim-R/tmp \
	    " NVIMR_ID=$NVIMR_ID \
	    " NVIMR_SECRET=$NVIMR_SECRET \
	    " R_DEFAULT_PACKAGES=$R_DEFAULT_PACKAGES \
	    " NVIM_IP_ADDRESS=$NVIM_IP_ADDRESS R $@"
" <
" 
      " - Add the following lines to your |vimrc| (replace `hostname -I` with a
	" command that works in your system):
" >
	" " Setup Vim to use the remote R only if the output of df includes
	" " the string 'remoteR', that is, the remote file system is mounted:
        " if system('df') =~ 'remoteR'
            " let $NVIM_IP_ADDRESS = substitute(system("hostname -I"), " .*", "", "")
            " let R_app = '/home/locallogin/bin/sshR'
            " let R_cmd = '/home/locallogin/bin/sshR'
            " let R_compldir = '/home/locallogin/.remoteR/NvimR_cache'
            " let R_tmpdir = '/home/locallogin/.remoteR/NvimR_cache/tmp'
            " let R_remote_tmpdir = '/home/remotelogin/.cache/NvimR_cache/tmp'
            " let R_nvimcom_home = '/home/locallogin/.remoteR/R_library/nvimcom'
        " endif
" <
      " - Mount the remote directories:
" >
	" ~/bin/mountR
" <
      " - Start Neovim (or Vim), and start R.
" 
" 
" ==============================================================================
								 " *Nvim-R-news*
" 10. News~
" 
" 0.9.12.1 (2019-01-01)
" 
 " * Support for Python code in knitr chunks: integration with the R package
   " reticulate and with the jedi-vim plugin.
 " * New option: R_editing_mode
 " * Minor bug fixes.
" 
" 0.9.12 (2018-08-19)
" 
 " * Minor bug fixes.
 " * Bibliographic completion for Rmd.
 " * New command:  :RDebugInfo
 " * New options: R_hi_fun_globenv, R_auto_scroll, R_ls_env_tol,
   " R_non_r_compl, R_cite_pattern.
 " * Accept prefix "terminal:" in `R_csv_app`.
 " * Remove option R_tmux_split.
 " * Changes:
   " - If the Object Browser is already open, \ro will close it.
   " - The values "bottom" and "top" are no longer valid for R_objbr_place
     " (use "below" and "above" instead).
" 
" 0.9.11 (2018-01-29)
" 
 " * The option R_latexcmd now is a list and the option R_latexmk no longer
   " exists. By default, latexmk and xelatex will be called to compile pdf
   " documents.
 " * Arguments completion is now done by CTRL-X CTRL-O.
 " * New options: R_OutDec, R_csv_delim, R_rmdchunk, R_parenblock,
   " R_bracketed_paste, R_complete.
 " * New command: `:RSend`.
 " * Require Neovim >= 0.2.0 (Linux, OS X) or >= 0.2.1 (Windows).
" 
" 0.9.10 (2017-09-08)
" 
 " * Change command \dt to \td and \pt to \tp.
 " * New default value for R_show_args = 1.
 " * New options: R_hi_fun_paren, R_show_arg_help,R_sttline_fmt and
   " R_set_sttline_cmd.
 " * Minor bug fixes.
" 
" 0.9.9 (2017-04-22)
" 
 " * Delete option R_vsplit.
 " * New options: R_min_editor_width and R_wait_reply, Rtools_path,
   " R_remote_tmpdir, R_nvimcom_home, R_paragraph_begin.
 " * Rename option R_ca_ck as R_clear_line
 " * Change in \pp behavior.
 " * Minor bug fixes.
" 
" 0.9.8 (2016-12-10)
" 
 " * Minor bug fixes.
 " * New commands: \dt and \pt
 " * Require Neovim >= 0.1.7.
" 
" 0.9.7 (2016-09-26)
" 
 " * Require Vim >= 8.0.0 or Neovim >= 0.1.5.
 " * Replaced R_nvimcom_wait (time in miliseconds) with R_wait (time in
   " seconds).
 " * Minor bug fixes.
" 
" 0.9.6 (2016-08-10)
" 
 " * New option: R_open_example.
 " * Change default value of R_source_args to "print.eval=TRUE".
 " * Change in \aa and \ae: do not save the buffer before sending the whole file
   " to R.
 " * Minor bug fixes.
" 
" 0.9.5 (2016-05-18)
" 
 " * Ask whether R_LIBS_USER directory should be created.
" 
" 0.9.4 (2016-05-16)
" 
 " * Delete option R_tmux_ob. The Object Browser will always start in a Vim
   " split window, not in a Tmux split pane.
 " * New option: R_cmd
 " * Minor bug fixes.
 " * Require Neovim >= 0.1.4 or Vim >= 7.4.1829.
" 
" 0.9.3 (2016-03-26)
" 
 " * Build nvimcom even when Nvim-R directory in non-writable.
" 
" 0.9.2 (2016-03-19)
" 
 " * Support Vim.
 " * New option: R_app.
" 
" 0.9.1 (2016-02-28)
" 
 " * New option: R_close_term.
 " * Delete option: R_restart.
" 
" 0.9.0 (2015-11-03)
" 
 " * Initial release of Nvim-R for Neovim 0.1.0.
" 
" vim:tw=78:ts=8:ft=help:norl
"
