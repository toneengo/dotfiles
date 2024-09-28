const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

const date = Variable("", {
    poll: [1000, 'date "+%a %d %b"'],
})
const time = Variable("", {
    poll: [1000, 'date "+%l:%M %P"'],
})

const iconmap = new Map();
const iconws = ['', 'discord', 'chromium', 'nvim', 'applications-games', 'audacity', 'applications-other', '', '', ''];

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

const dispatch = ws => hyprland.messageAsync(`dispatch workspace ${ws}`);
function Workspaces() {
    const activeId = hyprland.active.workspace.bind("id");

    return Widget.Box({
        class_name: "workspaces",
        homogeneous: false,
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            attribute: i,
            child: Widget.Icon({
                size: 16,
                icon: hyprland.active.client.bind("class").as(c => {
                    return iconws[i];
                }),
            }),
            onClicked: () => dispatch(i),
            class_name: activeId.as(ai => `${ai === i ? "focused" : "occupied"}`),
        })),

        // remove this setup hook if you want fixed number of buttons
        setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
            if (!hyprland.workspaces.some(ws => ws.id === btn.attribute))
            {
                btn.class_name = "hidden";
                btn.child.icon = '';
            }
            else 
            {
                btn.child.icon = iconws[btn.attribute];
            }
        })),
    })
}

function findicon(c) {
    const activeId = hyprland.active.workspace.bind("id");
    if (iconmap.has(c)) {
        activeId.as(ai => iconws[ai] = iconmap.get(c));
        return iconmap.get(c);
    }

    Utils.execAsync(`bash -c "$HOME/scripts/geticon.sh "${c}""`).then(out => iconmap.set(c, out)).catch(err => print(err));
    activeId.as(ai => iconws[ai] = iconmap.get(c));
    return iconmap.get(c);
}

function ClientTitle() {
    return Widget.Box({
        spacing: 6,
        children: [

            Widget.Icon({
                class_name: "title-icon",
                size: 16,
                icon: hyprland.active.client.bind("class").as(p => findicon(p)),
            }),
            Widget.Label({
                class_name: "client-title",
                maxWidthChars: 80,
                truncate: 'end',
                label: hyprland.active.client.bind("title"),
            }),
        ],
    })
}


function Clock() {
    return Widget.Box({
        class_name: "clock",
        spacing: 8,
        children: [
            Widget.Icon({
                icon: "x-office-calendar-symbolic",
            }),
            Widget.Label({
                label: date.bind(),
            }),
            Widget.Icon({
                icon: "document-open-recent-symbolic",
            }),
            Widget.Label({
                label: time.bind(),
            }),
        ]
    })
}


// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
    return Widget.Button({
        class_name: "notification",
        on_primary_click: () => Utils.execAsync("swaync-client -t"),
        child: Widget.Icon({
            icon: "preferences-system-notifications-symbolic",
        }),
    })
}


function Media() {
    const Player = player => Widget.Box({
        class_name: "media",
        children: [
            Widget.Icon({
                class_name: "player-icon",
                icon: player.bind("name").as(p => {
                    if (p == "spotify") return "spotify-launcher";
                    return `${p}`
                }),
            }),
            Widget.Label({
                class_name: "media-label",
                truncate: 'end',
                maxWidthChars: 20,
                label: Utils.merge([player.bind("track_artists"), player.bind("track_title")], (p1, p2) => {
                    return `${p1.join(", ")} - ${p2}`
                }),            
            }),
            Widget.Button({
                class_name: "media-control prev",
                child: Widget.Icon({ icon: "media-skip-backward-symbolic"}),
                on_primary_click: () => player.previous(),
            }),
            Widget.Button({
                class_name: "media-control play",
                on_primary_click: () => player.playPause(),
                child: Widget.Icon({
                    icon: player.bind("play_back_status").transform(s => {
                        switch (s) {
                            case "Playing": return "media-playback-pause"
                            case "Paused":  return "media-playback-start"
                            case "Stopped": return "media-playback-start"
                        }
                    })
                }),
            }),
            Widget.Button({
                class_name: "media-control next",
                child: Widget.Icon({ icon: "media-skip-forward-symbolic"}),
                on_primary_click: () => player.next(),
            }),
        ]
    })

    return Widget.Box({
        class_name: "media-widget",
        /*
        on_primary_click: () => mpris.getPlayer("")?.playPause(),
        on_scroll_up: () => mpris.getPlayer("")?.next(),
        on_scroll_down: () => mpris.getPlayer("")?.previous(),
        */
        children: mpris.bind('players').as(p => p.map(Player)),
    })
}


function Volume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    })
    const button = Widget.Button({
        class_name: "volume-button",
        child: icon,
        on_primary_click: () => Utils.execAsync("pavucontrol"),
    })

    const slider = Widget.Slider({
        hexpand: false,
        draw_value: false,
        on_change: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return Widget.Box({
        class_name: "volume",
        spacing: 10,
        children: [button, slider],
    })
}


function BatteryLabel() {
    const value = battery.bind("percent").as(p => `${p}%`)
    const icon = battery.bind("icon_name").as(p => `${p}`)

    return Widget.Box({
        class_name: "battery",
        visible: battery.bind("available"),
        spacing: 6,
        children: [
            Widget.Icon({
                icon: icon,
            }),

            Widget.Label({
                label: value,
            }),
        ],
    })
}


function SysTray() {
    var items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        children: items,
        class_name: "systray",
    })
}

function Separator() {
    return Widget.Label({
        class_name: "separator",
        label: "|",
    })
}

// layout of the bar
function Left() {
    return Widget.Box({
        hpack: "start",
        spacing: 10,
        class_name: "container left",
        children: [
            Workspaces(),
            Separator(),
            ClientTitle(),
        ],
    })
}

function Center() {
    return Widget.Box({
        spacing: 8,
        class_name: "container center",
        children: [
        ],
    })
}

function RightClickMenu() {
    const menu = Widget.Menu({
        children: [
            Widget.MenuItem({
                child: Widget.Label('hello'),
            }),
        ],
    })

    return Widget.Button({
        on_primary_click: (_, event) => {
            menu.popup_at_pointer(event)
        },
    })
}

function Hyprshade() {
    return Widget.Button({
        on_primary_click: () => Utils.execAsync("hyprshade toggle blue-light-filter"),
        child: Widget.Icon({
            size: 16,
            icon: 'display-brightness',
        }),
    })
}
function Right() {
    return Widget.Box({
        hpack: "end",
        spacing: 12,
        class_name: "container right",
        children: [
            RightClickMenu(),
            Media(),
            Separator(),
            Hyprshade(),
            Separator(),
            Volume(),
            Separator(),
            BatteryLabel(),
            Separator(),
            Clock(),
            Separator(),
            SysTray(),
            Notification(),
        ],
    })
}

function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            end_widget: Right(),
        }),
    })
}

const scss = `${App.configDir}/style.scss`
const css = `/tmp/style.css`
Utils.exec(`sass ${scss} ${css}`)
App.config({
    style: css,
    windows: [
        Bar(0),
        //Bar(1),

        // you can call it, for each monitor
        // Bar(0),
        // Bar(1)
    ],
})

export { }
