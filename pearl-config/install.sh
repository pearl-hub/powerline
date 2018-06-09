
function post_install(){
    info "Installing or updating the powerline git repository..."
    install_or_update_git_repo https://github.com/Lokaltog/powerline.git "${PEARL_PKGVARDIR}/powerline" master
    mkdir -p ${HOME}/.fonts
    mkdir -p ${HOME}/.fonts.conf.d/
    local fonts_file="${PEARL_PKGVARDIR}/powerline/font/PowerlineSymbols.otf"
    [ -f "$fonts_file" ] || ln -s "$fonts_file" "${HOME}/.fonts"
    fc-cache -vf "${HOME}/.fonts"

    cp ${PEARL_PKGVARDIR}/powerline/font/10-powerline-symbols.conf ${HOME}/.fonts.conf.d/

    info "Vim binding applied."

    if ask "Do you want Powerline binding for Bash?" "N"

    then
        link "bash" "${PEARL_PKGVARDIR}/powerline/powerline/bindings/bash/powerline.sh"
    fi
    if ask "Do you want Powerline binding for Tmux?" "N"
    then
        link "tmux" "${PEARL_PKGVARDIR}/powerline/powerline/bindings/tmux/powerline.conf"
    fi

    return 0
}

function post_update(){
    post_install
}

function pre_remove(){
    rm -f "${HOME}/.fonts/PowerlineSymbols.otf"
    fc-cache -vf ${HOME}/.fonts

    rm -f "${HOME}/.fonts.conf.d/10-powerline-symbols.conf"

    unlink "bash" "${PEARL_PKGVARDIR}/powerline/powerline/bindings/bash/powerline.sh"
    unlink "tmux" "${PEARL_PKGVARDIR}/powerline/powerline/bindings/tmux/powerline.conf"

    rm -rf ${PEARL_PKGVARDIR}/powerline
    return 0
}