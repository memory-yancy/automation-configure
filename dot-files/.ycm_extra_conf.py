# https://github.com/Valloric/YouCompleteMe#working-with-virtual-environments
# coding: utf-8

import os
import sys

def Settings( **kwargs ):
    virtual_python = (
        os.path.join(os.getenv('CONDA_PREFIX'), 'bin/python') if os.getenv('CONDA_PREFIX') else sys.executable
    )
    virtual_python = virtual_python if os.path.exists(virtual_python) else sys.executable

    return {'interpreter_path': virtual_python}
