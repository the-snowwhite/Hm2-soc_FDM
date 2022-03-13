#!/usr/bin/python

import sys
import os
import subprocess
import time
from machinekit import launcher
from machinekit import config


if 'MACHINEKIT_INI' not in os.environ:  # export for package installs
    mkconfig = config.Config()
    os.environ['MACHINEKIT_INI'] = mkconfig.MACHINEKIT_INI

def check_mklaucher():
    try:
        subprocess.check_output(['pgrep', 'mklauncher'])
        return True
    except subprocess.CalledProcessError:
        return False

os.chdir(os.path.dirname(os.path.realpath(__file__)))

try:
    launcher.check_installation()
    launcher.cleanup_session()
    launcher.register_exit_handler()  # needs to executed after HAL files

    nc_path = os.path.expanduser('~/nc_files')
    if not os.path.exists(nc_path):
        os.mkdir(nc_path)

    if not check_mklaucher():  # start mklauncher if not running to make things easier
        launcher.start_process('mklauncher ~/Hm2-soc_FDM/Cramps/HAL/OX')

    launcher.start_process("configserver -n OX Router ~/Cetus/")
    launcher.start_process('linuxcnc ox.ini')
    while True:
        launcher.check_processes()
        time.sleep(1)
except subprocess.CalledProcessError:
    launcher.end_session()
    sys.exit(1)

sys.exit(0)
