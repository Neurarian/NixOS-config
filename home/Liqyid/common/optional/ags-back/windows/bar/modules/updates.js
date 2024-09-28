import Widget from "gi://Astal";
import execAsync from "gi://Astal";

export default () =>
  Widget.EventBox({
    child: Widget.Label({ className: "updates module" })
      .poll(
        10000,
        (self) =>
          execAsync(["bash", "-c", `~/scripts/updates.sh | awk '{print $2}'`,

    ]).then((r) =>
            self.tooltipText = r
          ),
      ),
  });
