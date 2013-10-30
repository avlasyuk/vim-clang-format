function! s:is_empty_region(begin, end)
    return a:begin[1] == a:end[1] && a:end[2] < a:begin[2]
endfunction

function! s:restore_screen_pos()
    let line_diff = line('w0') - g:operator#clang_format#save_screen_pos
    if line_diff > 0
        execute 'silent normal!' line_diff."\<C-y>"
    elseif line_diff < 0
        execute 'silent normal!' (-line_diff)."\<C-e>"
    endif
endfunction

function! operator#clang_format#do(motion_wise)
    if s:is_empty_region(getpos("'["), getpos("']"))
        return
    endif

    call clang_format#replace(getpos("'[")[1], getpos("']")[1])

    " work around for textobject making cursor move
    call setpos('.', g:operator_clang_format_save_pos)
    unlet g:operator_clang_format_save_pos

    call s:restore_screen_pos()
    unlet g:operator#clang_format#save_screen_pos
endfunction
