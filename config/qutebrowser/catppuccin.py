import qutebrowser.api.interceptor

def setup(c, flavor='mocha', statusbar_bold=False):
    palette = {
        'rosewater': '#f5e0dc', 'flamingo': '#f2cdcd', 'pink': '#f5c2e7',
        'mauve': '#cba6f7', 'red': '#f38ba8', 'maroon': '#eba0ac',
        'peach': '#fab387', 'yellow': '#f9e2af', 'green': '#a6e3a1',
        'teal': '#94e2d5', 'sky': '#89dceb', 'sapphire': '#74c7ec',
        'blue': '#89b4fa', 'lavender': '#b4befe', 'text': '#cdd6f4',
        'subtext1': '#bac2de', 'subtext0': '#a6adc8', 'overlay2': '#9399b2',
        'overlay1': '#7f849c', 'overlay0': '#6c7086', 'surface2': '#585b70',
        'surface1': '#45475a', 'surface0': '#313244', 'base': '#1e1e2e',
        'mantle': '#181825', 'crust': '#11111b',
    }

    # Background color of the completion widget category headers.
    c.colors.completion.category.bg = palette['base']
    # Bottom border color of the completion widget category headers.
    c.colors.completion.category.border.bottom = palette['mantle']
    # Top border color of the completion widget category headers.
    c.colors.completion.category.border.top = palette['mantle']
    # Foreground color of completion widget category headers.
    c.colors.completion.category.fg = palette['lavender']
    # ... (Rest of the UI colors) ...
    c.colors.tabs.even.bg = palette['surface0']
    c.colors.tabs.odd.bg = palette['surface0']
    c.colors.tabs.selected.even.bg = palette['base']
    c.colors.tabs.selected.odd.bg = palette['base']
    c.colors.tabs.selected.even.fg = palette['mauve']
    c.colors.tabs.selected.odd.fg = palette['mauve']
    c.colors.statusbar.normal.bg = palette['base']
    c.colors.statusbar.insert.bg = palette['green']
