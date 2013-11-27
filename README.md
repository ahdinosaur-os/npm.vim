# npm.vim: Run NPM commands in Vim.

npm.vim makes it easy to run npm commands from Vim. It doesn't have any
interesting features like errorlist integration yet.

For Vim version 7.x.

## Installation

[Download npm.vim.zip from vim.org](http://www.vim.org/scripts/script.php?script_id=4783). 

    unzip npm.vim.zip
    cp npm.vim.zip/doc/npm.txt ~/.vim/doc/
    cp npm.vim.zip/plugin/npm.vim ~/.vim/plugin/

As usual, to build help:

    :helptags ~/.vim/doc

##Global Commands

    :Npm <command> [options..]

Calls `npm <command> [options]`. Commands can be tab-completed.

##Global Settings

    g:npm_background = 1

If set to non-zero, runs all commands in background (so you lose their
output).

Overridden by g:npm\_foreground.

    g:npm_background = 1

If set to non-zero, runs commands in foreground. This is the default and is
best for long-running commands like "npm install".

Overrides g:npm\_background

    g:npm_custom_commands = []

If some NPM commands aren't being picked up, add them to this list.

##License

npm.vim is released under the MIT license. See the comments at the head of
npm.vim for the full license text, or the "COPYING" file you should have
received with your copy of this software.
