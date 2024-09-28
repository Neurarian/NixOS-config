import bluetooth from "gi://AstalBluetooth";
import Widget from "gi://Astal"

const Bluetooth = bluetooth.get_default()
import {
  getBluetoothIcon,
  getBluetoothText,
} from "../../../utils/bluetooth.js";

export default () =>
  Widget.Icon({ className: "bluetooth module" })
    .bind("icon", Bluetooth, "connected-devices", getBluetoothIcon)
    .bind("tooltip-text", Bluetooth, "connected-devices", getBluetoothText);
