import os
import subprocess
from libqtile import layout, bar, widget, hook
from libqtile.config import Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration
from libqtile.widget.cpu import CPU

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.Popen([os.path.expanduser("~/.config/qtile/autostart.sh")])

home=os.path.expanduser('~')
mod="mod4" # super key
alt="mod1"
myTerm="kitty"
myBrowser="vivaldi"
myIDE="myTerm -e nvim"
@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

keys = [
# SUPER + FUNCTION KEYS
    Key([alt], "1", lazy.spawn(myBrowser)),
    Key([alt], "2", lazy.spawn(myIDE)),
    Key([alt], "3", lazy.spawn("neovide")),
    Key([alt], "4", lazy.spawn("spotify")),
    Key([alt], "5", lazy.spawn("vesktop")),
# SUPER + ... KEYS
    Key([mod], "v", lazy.spawn("rofi -show drun")),
    Key([mod], "b", lazy.spawn("pcmanfm")),
    Key([mod], "period", lazy.spawn("rofi -show emoji")),
    Key([mod], "return", lazy.spawn(myTerm)),
    Key([mod], "m", lazy.spawn(f"{myTerm} -e ranger {home}")),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "x", lazy.shutdown()),
    Key([mod], "r", lazy.restart()),
    Key([mod], "comma", lazy.next_screen()),
# MEDIA KEYS
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -q sset Master toggle")),
# SCREENSHOTS
    Key([], "Print", lazy.spawn('flameshot gui')),
    Key(["control"], "Print", lazy.spawn('flameshot screen -n 1 -p ' + home + '/Pictures')),
# QTILE LAYOUT KEYS
    Key([mod], "space", lazy.next_layout()),
    Key([mod,"shift"], "e", lazy.hide_show_bar(), desc="Hides the bar"),
# CHANGE FOCUS
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
# RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "h", lazy.layout.shrink(), lazy.layout.decrease_nmaster()),
    Key([mod, "control"], "l", lazy.layout.grow(), lazy.layout.increase_nmaster()),
# FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "f", lazy.layout.flip()),
# FLIP LAYOUT FOR BSP
    Key([mod, alt], "k", lazy.layout.flip_up()),
    Key([mod, alt], "j", lazy.layout.flip_down()),
    Key([mod, alt], "l", lazy.layout.flip_right()),
    Key([mod, alt], "h", lazy.layout.flip_left()),
# MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
]

groups = [Group(f"{i+1}", label="") for i in range(9)]

for i in groups:
    keys.extend([
#CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])

# LAYOUTS
layout_theme={
    "margin":6,
    "border_width":0,
    "border_focus": "#E5E9F0",
    "border_normal": "#45475A"
}

layouts=[
    layout.RatioTile(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Columns(**layout_theme),
]

# WIDGETS FOR THE BAR
def init_widgets_defaults():
    return dict(
        font="JetBrains Mono Nerd",
        fontsize=14,
        padding=3,
    )

widget_defaults=init_widgets_defaults()
extension_defaults=[ widget_defaults.copy()]

colors={
    'night': '#2E3440',
    'dark': '#3B4252',
    'clear': ' #000000',
    'medium': '#434C5E',
    'light': '#4C566A',
    'sat': '#8FBCBB',
    'dim': '#5E81AC',

}

roundness=10

def init_widgets():
    widgets=[
        widget.Spacer(
            length=10,
            background=colors["night"],
        ),
        widget.Image(
            filename='~/.config/qtile/assets/logo.png',
            margin=2,
            background=colors["night"],
            decorations=[
                PowerLineDecoration(
                    path='rounded_left',
                    override_colour=colors["night"], 
                    size=roundness
                )
            ],
        ),
        widget.GroupBox(
            fontsize=15,
            borderwidth=1,
            highlight_method='text',
            background=colors["dark"],
            active=colors["dim"],
            inactive=colors["light"],
            this_current_screen_border=colors["sat"],
            disable_drag=True,
            decorations=[
                PowerLineDecoration(
                    path='rounded_left',
                    override_colour=colors["dark"], 
                    size=roundness
                )
            ],
            ),
        widget.CurrentLayoutIcon(
            background=colors["medium"],
            padding=5,
            scale=0.5,
        ),
        widget.CurrentLayout(
            background=colors["medium"],
            font='JetBrains Mono Nerd',
            decorations=[
                PowerLineDecoration(
                    path='rounded_left',
                    override_colour=colors["medium"], 
                    size=roundness
                )
            ],
        ),
        widget.Spacer(
            length=3,
            background=colors["light"],
        ),
        widget.WindowName(
            background=colors["light"],
            format="{state}",
            max_chars=60,
            fontsize=11,
            decorations=[
                PowerLineDecoration(
                    path='rounded_right',
                    override_colour=colors["light"], 
                    size=roundness
                )
            ],
        ),
        widget.TextBox(
            text=" ",
            font="JetBrains Mono Nerd",
            fontsize=16,
            background=colors["night"],
        ),
        widget.Clock(
            background=colors["night"],
            format='%I:%M %p',
            decorations=[
                PowerLineDecoration(
                    path='rounded_left',
                    override_colour=colors["night"], 
                    size=roundness
                )
            ],
        ),
        widget.Spacer(
            background=colors["light"],
            decorations=[
                PowerLineDecoration(
                    path='rounded_right',
                    override_colour=colors["light"], 
                    OpenWeather=2,
                    size=roundness
                )
            ],
        ),
        widget.TextBox(
            text=" ",
            font="JetBrains Mono Nerd",
            fontsize=16,
            background=colors["medium"],
        ),
        widget.Memory(
            measure_mem='G',
            format='{MemUsed: .1f}{mm}',
            background=colors["medium"],
        ),
        widget.Spacer(
            length=10,
            background=colors["medium"],
        ),
        widget.TextBox(
            text=" ",
            font="JetBrains Mono Nerd",
            fontsize=16,
            background=colors["medium"],
        ),
        widget.CPU(
            font="JetBrains Mono Nerd",
            fontsize=13,
            background=colors['medium'],
            format='{freq_current}GHz',
            padding=0
        ),            
        widget.Spacer(
            length=5,
            background=colors["medium"],
            decorations=[
                PowerLineDecoration(
                    path='rounded_right',
                    override_colour=colors["medium"], 
                    size=roundness
                )
            ],
        ),
        widget.OpenWeather(
            app_key='50dfe3c4af787e95cfb00325885f0019',
            background=colors["dark"],
            cityid=3714637,
            #London (Original ID 3076586)
            format='{icon}  {main_temp: .1f}°{units_temperature}'
        ),
        widget.Spacer(
            length=10,
            background=colors["dark"],
        ),
        widget.TextBox(
            text=" ",
            font="JetBrains Mono Nerd",
            background=colors["dark"],
        ),
        widget.Volume(
            background=colors["dark"],
        ),
        widget.Spacer(
            length=5,
            background=colors["night"],
            decorations=[
                PowerLineDecoration(
                    background=colors["clear"],
                    path='rounded_right',
                    override_colour=colors["dark"], 
                    size=roundness
                )
            ],
        ),
        widget.TextBox(
            text=" ",
            font="JetBrains Mono Nerd",
            fontsize=10,
            padding=0,
            background=colors["night"],
        ),
        widget.Clock(
            padding=5,
            background=colors["night"],
            format='%d/%m/%y'
        )
    ]
    return widgets

    screen1_widgets=init_widgets()
#    screen2_widgets=init_widgets()

screens=[Screen(top=bar.Bar(widgets=init_widgets(), size=30, opacity=1, margin=[5, 5, -3, 5])),
         #screens=[Screens(top=bar.Bar(widget=init_widgets(), size=30, opacity=1, margin=[10 ,15, -3, 15])),
         ]


# MOUSE CONFIGURATION
mouse=[
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder=None
dgroups_app_rules=[]
main = None

follow_mouse_focus=True
bring_front_click=False
cursor_warp=False

floating_layout=layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='file_progress'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(wm_class='confirmreset'),
        Match(wm_class='notification'),
        Match(wm_class='makebranch'),
        Match(wm_class='maketag'),
        Match(wm_class='Arandr'),
        Match(wm_class='feh'),
        Match(wm_class='Galculator'),
        Match(title='branchdialog'),
        Match(title='Open File'),
        Match(title='pinentry'),
        Match(wm_class='ssh-askpass'),
        Match(wm_class='lxpolkit'),
        Match(wm_class='yad'),
    ],
    **layout_theme
)

auto_fullscreen = True
auto_minimize = True
focus_on_window_activation = "smart" 

wmname = "LG3D"
