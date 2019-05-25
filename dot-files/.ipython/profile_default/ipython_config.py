# coding: utf-8

import os
from IPython.terminal.prompts import Prompts as BasePrompts
from pygments.token import Token
from time import strftime

# https://newton.cx/~peter/howto/extend-prompt-in-ipython/
# https://gist.github.com/rsvp/ce3d64633713830fbea406f55adcd5e5
class MyPrompts(BasePrompts):
    def in_prompt_tokens(self, cli=None):
        return [
            # (Token.Prompt, strftime('[%F %H:%M:%S]') + ' '),
            (Token.Prompt, (os.sep.join(os.getcwd().split(os.sep)[-3:])) + ' '),
            (Token.PromptNum, str(self.shell.execution_count)),
            (Token.Prompt, ' >>> '),
        ]
c.InteractiveShell.prompts_class = MyPrompts

c.HistoryManager.enabled = False
c.HistoryManager.hist_file = '/tmp/ipython_hist.sqlite'
c.TerminalInteractiveShell.term_title = False
c.TerminalIPythonApp.display_banner = False
