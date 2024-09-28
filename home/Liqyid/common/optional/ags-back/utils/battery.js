import Battery from "gi://AstalBattery";

const battery = Battery.get_default();

export const toTime = (time) => {
  const MINUTE = 60;
  const HOUR = MINUTE * 60;

  if (time > 24 * HOUR) return "";

  const hours = Math.round(time / HOUR);
  const minutes = Math.round((time - hours * HOUR) / MINUTE);

  const hoursDisplay = hours > 0 ? `${hours}h ` : "";
  const minutesDisplay = minutes > 0 ? `${minutes}m ` : "";

  return `${hoursDisplay}${minutesDisplay}`;
};

export const batteryTime = () => {
  return battery.timeRemaining > 0 && toTime(battery.timeRemaining) != ""
    ? `${toTime(battery.timeRemaining)}remaining`
    : "";
};
