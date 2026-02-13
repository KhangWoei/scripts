#!/bin/bash
# @name: aur-update
# @desc: Updates all AUR packages

yay --sudoloop --noconfirm --noredownload --norebuild --removemake
