#!/bin/bash
# @name: nvim-update
# @desc: Syncs Neovim Lazy plugin packages

nvim --headless "+Lazy! sync" +qa
