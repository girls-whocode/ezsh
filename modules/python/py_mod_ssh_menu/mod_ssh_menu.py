#!/bin/python
# SSH Menu System, Jessica Brown using Rich Module

import os
import ssh_helper
from datetime import datetime
from rich import print, pretty, inspect
from rich.console import Console
from textual.containers import Container
from textual.app import App, ComposeResult
from textual.binding import Binding
from textual.widgets import Static, ListView, ListItem, Label, Footer, Header

class SSHMenu(App):
  CSS_PATH = "ssh_menu.css"
  
  BINDINGS = [
    Binding(key="escape", action="quit", description="Quit the app"),
    Binding(
        key="question_mark",
        action="help",
        description="Show help screen",
        key_display="?",
    ),
  ]

  def on_mount(self) -> None:
    self.screen.styles.background = "black"
    self.screen.styles.border = ("heavy", "white")

  def compose(self) -> ComposeResult:

    BINDINGS = [
      Binding(key="del", action="delete", description="Remove a host"),
      Binding(key="ins", action="insert", description="Add a new Host"),
      Binding(key="e", action="edit", description="Edit the host"),
      Binding(key="arrow_down", action="down", description="Scroll down", show=False),
    ]

    user_home = os.path.expanduser('~')
    config_file = user_home+"/.ssh/config"
    c = ssh_helper.read_ssh_config(config_file)

    yield Header()
    yield Container(
      Static(id="list_area")
    )

    for host in c.hosts():
      host = host.split()[0]
      if host != "*":
        yield ListView(
          ListItem(Label(host))
        )

    yield Footer()

if __name__ == "__main__":
    app = SSHMenu()
    app.run()

# for host in c.hosts():
#   print("hostname", c.host(host))

