
function post_install(){
    mkdir -p ${HOME}/.fonts
    mkdir -p ${HOME}/.fonts.conf.d/
    local fonts_file="${PEARL_PKGDIR}/module/font/PowerlineSymbols.otf"
    [ -f "$fonts_file" ] || ln -s "$fonts_file" "${HOME}/.fonts"
    fc-cache -vf "${HOME}/.fonts"

    cp ${PEARL_PKGDIR}/module/font/10-powerline-symbols.conf ${HOME}/.fonts.conf.d/

    info "Vim binding applied."

    if ask "Do you want Powerline binding for Bash?" "N"

    then
        link "bash" "${PEARL_PKGDIR}/module/powerline/bindings/bash/powerline.sh"
    fi
    if ask "Do you want Powerline binding for Tmux?" "N"
    then
        link "tmux" "${PEARL_PKGDIR}/module/powerline/bindings/tmux/powerline.conf"
    fi

    return 0
}

function pre_remove(){
    rm -f "${HOME}/.fonts/PowerlineSymbols.otf"
    fc-cache -vf ${HOME}/.fonts

    rm -f "${HOME}/.fonts.conf.d/10-powerline-symbols.conf"

    unlink "bash" "${PEARL_PKGDIR}/module/powerline/bindings/bash/powerline.sh"
    unlink "tmux" "${PEARL_PKGDIR}/module/powerline/bindings/tmux/powerline.conf"

    return 0
}
