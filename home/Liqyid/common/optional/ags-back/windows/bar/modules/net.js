import Widget from "gi://Astal";
import network from "gi://AstalNetwork";
import { getNetIcon, getNetText } from "../../../utils/net.js";

const Network = network.get_default();
export default () =>
  Widget.Icon({ className: "net module" })
    .bind(
      "icon",
      Network,
      "connectivity",
      getNetIcon,
    )
    .bind(
      "tooltip-text",
      Network,
      "connectivity",
      getNetText,
    );
