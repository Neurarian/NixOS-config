import { Widget, App } from "gi://Astal";
import Hyprland from "gi://AstalHyprland";
import Wp from "gi://AstalWp";
import Indicators from "../../services/osd.js";
import PopupWindow from "../../utils/popup_window.js";

const Audio = Wp.get_default().audio;
const hyprland = Hyprland.get_default()
// connections
Audio.connect("speaker-changed", () =>
  Audio.speaker.connect(
    "changed",
    () => {
      if (!App.getWindow("system-menu")?.visible) {
        Indicators.speaker();
      }
    },
  ));
Audio.connect(
  "microphone-changed",
  () => Audio.microphone.connect("changed", () => Indicators.mic()),
);

let lastMonitor;

const child = () =>
  Widget.Box({
    hexpand: true,
    visible: false,
    className: "osd",

    children: [
      Widget.Icon().hook(
        Indicators,
        (self, props) => self.icon = props?.icon ?? "",
      ),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Label({
            hexpand: false,
            truncate: "end",
            max_width_chars: 24,
          })
            .hook(
              Indicators,
              (self, props) => self.label = props?.label ?? "",
            ),

          Widget.ProgressBar({
            hexpand: true,
            vertical: false,
          })
            .hook(
              Indicators,
              (self, props) => {
                self.value = props?.value ?? 0;
                self.visible = props?.showProgress ?? false;
              },
            ),
        ],
      }),
    ],
  });

export default () =>
  PopupWindow({
    name: "osd",
    layer: "overlay",
    child: child(),
    click_through: true,
    anchor: ["bottom"],
    revealerSetup: (self) =>
      self
        .hook(Indicators, (revealer, _, visible) => {
          revealer.reveal_child = visible;
        }),
  })
    .hook(
      hyprland.active,
      (self) => {
        // prevent useless resets
        if (lastMonitor === hyprland.active.monitor) return;

        self.monitor = hyprland.active.monitor.id;
      },
    )
    .hook(Indicators, (win, _, visible) => {
      win.visible = visible;
    });
