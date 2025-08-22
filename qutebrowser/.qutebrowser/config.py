config.load_autoconfig()
config.source("gruvbox.py")
c.content.blocking.method = "adblock"
c.editor.command = ["vim", "{}"]
c.fonts.web.size.default = 20

# dark mode setup
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"
config.set("colors.webpage.darkmode.enabled", False, "file://*")

# styles, cosmetics
c.tabs.padding = {"top": 5, "bottom": 5, "left": 9, "right": 9}
c.tabs.indicator.width = 0  # no tab indicators
# c.window.transparent = True # apparently not needed
c.tabs.width = "7%"
# hidetab
# c.tabs.show = "never"

# fonts
c.fonts.default_family = []
c.fonts.default_size = "15pt"
c.fonts.web.family.fixed = "Inconsolata Nerd Font Mono"
c.fonts.web.family.sans_serif = "Inconsolata Nerd Font Mono"
c.fonts.web.family.serif = "Inconsolata Nerd Font Mono"
c.fonts.web.family.standard = "Inconsolata Nerd Font Mono"

c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "g": "https://www.google.com/search?q={}",
    "gs": "https://scholar.google.com/scholar?q={}",
}
c.completion.open_categories = [
    "searchengines",
    "quickmarks",
    "bookmarks",
    "history",
    "filesystem",
]
c.url.start_pages = [
    "https://app.daily.dev/?utm_source=landing&utm_medium=cta&utm_campaign=landing_conversions"
]
c.window.hide_decoration = True

# hide status bar
c.statusbar.show = "in-mode"

config.bind("<d>", "cmd-run-with-count 15 scroll down")
config.bind("<e>", "cmd-run-with-count 15 scroll up")
config.bind(",r", "spawn --userscript readability-js")
c.scrolling.smooth = True
