import Widget from "gi://Astal";
import execAsync from "gi://Astal";

export default () =>
  Widget.EventBox({
    child: Widget.Label({ className: "date module" })
      .poll(
        1000,
        (self) =>
          execAsync(["date", "+%H 󰇙 %M"]).then((r) =>
            self.label = r
          ),
      ),
  });
