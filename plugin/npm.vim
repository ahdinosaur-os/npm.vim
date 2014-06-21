" File: npm.vim
" Description: Tab completion for NPM commands.
" Author: Thomas Allen <thomas@oinksoft.com>
" Version: 0.1.2

" Copyright (c) 2013 Oinksoft <https://oinksoft.com/>
"
" Permission is hereby granted, free of charge, to any person obtaining a
" copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be included
" in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
" OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
" CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
" TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
" SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists('s:npm_loaded')
  finish
endif

let s:npm_loaded = 1

" Settings

function! s:defsetting(name, default)
  if !exists(a:name)
    exec 'let ' . a:name . ' = ' . string(a:default)
  endif
endfunction

" If set to non-zero, runs all commands in background (so you lose their
" output).
call s:defsetting('s:npm_background', 0)

" If some NPM commands aren't being picked up, add them with this list.
call s:defsetting('s:npm_custom_commands', [])

" If set to non-zero, commands for tab completion are loaded at startup rather
" than the first time completion is needed.
call s:defsetting('s:npm_load_commands', 0)

function! s:npm(...)
  if len(a:000)
    call s:command(a:000[0], a:000[1:])
  else
    call s:command('help', [])
  endif
endfunction

function! s:command(cmd, args)
  let cmd = join(['npm', a:cmd] + map(a:args, 'shellescape(v:val)'), ' ')
  let out = system(cmd)
  if !s:npm_background
    echo out
  endif
endfunction

function! s:npm_complete(arg_lead, cmd_lead, cursor_pos)
  call s:ensure_commands_loaded()
  let commands = copy(s:npm_commands + s:npm_custom_commands)
  return filter(commands, 'v:val =~ "^' . a:arg_lead . '"')
endfunction

function! s:ensure_commands_loaded()
  if !exists('s:npm_commands')
    let s:npm_commands = s:get_commands()
  endif
endfunction

function! s:get_commands()
  let npm_help = system('npm help')
  if v:shell_error != 0
    " Report an error here?
    return []
  else
    let lines = []
    let in_commands = 0
    for line in split(npm_help, '\n')
      if in_commands
        if line =~ '^$'
          break
        endif
        call add(lines, line)
      elseif line =~ '^\s'
        let in_commands = 1
        call add(lines, line)
      endif
    endfor
    let joined = join(map(lines, 'substitute(v:val, ",", "\n", "g")'), "\n")
    return filter(
          \map(split(joined, "\n"),
            \'substitute('
              \.'substitute(v:val, "^\\s\\+", "", "g"),'
              \.'"\\s\\+$", "", "g")'),
          \'v:val != ""')
  endif
endfunction

" Usage: :Npm <command> [args...]
command! -complete=customlist,s:npm_complete -nargs=* Npm :call s:npm(<f-args>)

if s:npm_load_commands
  call s:ensure_commands_loaded()
endif
