import catppuccin

config.load_autoconfig()
# Setup catppuccin mocha
catppuccin.setup(c, "mocha", True)
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"
c.qt.args = ["disable-gpu"]
