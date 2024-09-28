import { Widget, App } from "gi://Astal";
import Wp from "gi://AstalWp";
import execAsync from "gi://Astal";
import { audioIcon } from "../../utils/audio.js";

const Audio = Wp.get_default().audio;

const Slider = (args) =>
  Widget.Box({
    ...args.props ?? {},
    className: args.name,

    children: [
      Widget.Button({
        onPrimaryClick: args.icon.action ?? null,
        child: Widget.Icon({
          icon: args.icon.icon ?? "",
          setup: args.icon.setup,
        }),
      }),
      Widget.Slider({
        drawValue: false,
        hexpand: true,
        setup: args.slider.setup,
        onChange: args.slider.onChange ?? null,
      }),
    ],
  });

const vol = () => {
  return {
    name: "volume",
    icon: {
      icon: "",
      action: () => {
        App.toggleWindow("system-menu");
        execAsync("pavucontrol");
      },
      setup: (self) =>
        self
          .bind("icon", Audio.speaker, "volume", audioIcon)
          .bind("icon", Audio.speaker.stream, "is-muted", audioIcon),
    },
    slider: {
      setup: (self) => self.bind("value", Audio.speaker, "volume"),
      onChange: ({ value }) => Audio.speaker.volume = value,
    },
  };
};


export default () =>
  Widget.Box({
    className: "sliders",
    vertical: true,

    // The Audio service is ready later than ags is done parsing the config,
    // so only build the widget when we receive a signal from it.
    setup: (self) => {
      const connID = Audio.connect("notify::speaker", () => {
        Audio.disconnect(connID);
        self.children = [
          Slider(vol()),
        ];
      });
    },
  });
