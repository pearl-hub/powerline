
function post_install(){
    info "Installing or updating the powerline git repository..."
    install_or_update_git_repo https://github.com/powerline/powerline.git "${PEARL_PKGVARDIR}/powerline" master

    if command -v fc-cache &> /dev/null
    then
        mkdir -p ${HOME}/.fonts
        mkdir -p ${HOME}/.fonts.conf.d/
        local fonts_file="${PEARL_PKGVARDIR}/powerline/font/PowerlineSymbols.otf"
        if [[ -f "$fonts_file" ]]
        then
            link_to "$fonts_file" "${HOME}/.fonts/PowerlineSymbols.otf"
        else
            warn "Powerline symbols in powerline source code not found."
        fi
        fc-cache -vf "${HOME}/.fonts" || warn "fc-cache command did not work. Skipping the configuration of fonts..."
        cp ${PEARL_PKGVARDIR}/powerline/font/10-powerline-symbols.conf ${HOME}/.fonts.conf.d/
    else
        info "If running in OSX, make sure to follow the procedure for installing fonts:"
        info "    https://powerline.readthedocs.io/en/latest/installation/osx.html#fonts-installation"
    fi


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
    if command -v fc-cache &> /dev/null
    then
        rm -f "${HOME}/.fonts/PowerlineSymbols.otf"
        fc-cache -vf ${HOME}/.fonts || warn "fc-cache command did not work. Skipping the configuration of fonts..."
        rm -f "${HOME}/.fonts.conf.d/10-powerline-symbols.conf"
    fi

    unlink "bash" "${PEARL_PKGVARDIR}/powerline/powerline/bindings/bash/powerline.sh"
    unlink "tmux" "${PEARL_PKGVARDIR}/powerline/powerline/bindings/tmux/powerline.conf"

    rm -rf ${PEARL_PKGVARDIR}/powerline
    return 0
}
