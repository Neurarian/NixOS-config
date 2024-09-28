import Widget from "gi://Astal";

export default (player) =>
  Widget.Box({ className: "cover" })
    .bind(
      "css",
      player,
      "cover-path",
      (cover) => `background-image: url('${cover ?? ""}')`,
    );
