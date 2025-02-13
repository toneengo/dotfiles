import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Gio from "gi://Gio"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Tray from "gi://AstalTray"

function SysTray() {
    const tray = Tray.get_default()

    return <box className="SysTray">
        {bind(tray, "items").as(items => items.map(item => {
            if (item.iconThemePath)
                App.add_icons(item.iconThemePath)

            const menu = item.create_menu()

            return <button
                tooltipMarkup={bind(item, "tooltipMarkup")}
                onDestroy={() => menu?.destroy()}
                onClickRelease={self => {
                    menu?.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
                }}>
                <icon gIcon={bind(item, "gicon")} />
            </button>
        }))}
    </box>
}

function Wifi() {
    const { wifi } = Network.get_default()

    return <icon
        tooltipText={bind(wifi, "ssid").as(String)}
        className="Wifi"
        icon={bind(wifi, "iconName")}
    />
}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <box className="AudioSlider" css="min-width: 140px">
        <icon icon={bind(speaker, "volumeIcon")} />
        <slider
            hexpand
            onDragged={({ value }) => speaker.volume = value}
            value={bind(speaker, "volume")}
        />
    </box>
}

function BatteryLevel() {
    const bat = Battery.get_default()

    return <box className="Battery"
        visible={bind(bat, "isPresent")}>
        <icon icon={bind(bat, "batteryIconName")} />
        <label label={bind(bat, "percentage").as(p =>
            `${Math.floor(p * 100)} %`
        )} />
    </box>
}

function Media() {
    const mpris = Mpris.get_default()

    return <box className="Media">
        {bind(mpris, "players").as(ps => ps[0] ? (
            <box>
                <box
                    className="Cover"
                    valign={Gtk.Align.CENTER}
                    css={bind(ps[0], "coverArt").as(cover =>
                        `background-image: url('${cover}');`
                    )}
                />
                <label
                    label={bind(ps[0], "title").as(() =>
                        `${ps[0].title} - ${ps[0].artist}`
                    )}
                    truncate={true}
                    maxWidthChars={50}
                />
            </box>
        ) : (
            "Nothing Playing"
        ))}
    </box>
}

function Workspaces() {
    const hypr = Hyprland.get_default()
    return <box className="Workspaces"  homogeneous={true}>
        {Array.from({ length: 10 }, (_, i) => i + 1).map(i => (
            <button
                className={bind(hypr, "focusedWorkspace").as(fw =>
                    i + bind(hypr, "focusedMonitor").get().id * 10 === fw.id ? "focused" : "")}
                onClicked={() => hypr.get_workspace(i + bind(hypr, "focusedMonitor").get().id * 10).focus()}>
                {i}
            </button>
        ))}

    </box>
}

function Separator() {
    return <label
                className="Separator"
                label="|" />
}

function FocusedClient() {
    const hypr = Hyprland.get_default()
    const focused = bind(hypr, "focusedClient")

    return <box
        className="Focused"
        visible={focused.as(Boolean)}>
        {focused.as(client => (
            client && <label wrap={false} label={bind(client, "title").as(String)} />
        ))}
    </box>
}

function Time({ format = "%a %d %b %l:%M %P" }) {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format(format)!)

    return <label
        className="Time"
        onDestroy={() => time.drop()}
        label={time()}
    />
}

var count = 0;
export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
    const winname = "mainbar-" + count;
    count++;

    return <window
        className="Bar"
        namespace="mainbar"
        name={winname}
        setup={self => App.add_window(self)}
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}>
        <centerbox className="BarCBox">
            <box hexpand halign={Gtk.Align.START}>
                <Workspaces />
                <Separator />
                <FocusedClient />
            </box>
            <box>
            </box>
            <box hexpand halign={Gtk.Align.END} >
                <BatteryLevel />
                <Separator />
                <Time />
                <Separator />
                <SysTray />
            </box>
        </centerbox>
    </window>
}
