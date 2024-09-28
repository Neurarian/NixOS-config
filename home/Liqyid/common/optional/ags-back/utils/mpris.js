import Icons from "./utils/icons.js";
import GLib from "gi://GLib";
import exec from "gi://Astal";
import Gio from 'gi://Gio';


function ensureDirectory(path) {
    if (!GLib.file_test(path, GLib.FileTest.EXISTS))
        Gio.File.new_for_path(path).make_directory_with_parents(null);
}
const CACHE_DIR = `${GLib.get_user_cache_dir()}/${pkg.name.split('.').pop()}`;

export const findPlayer = (players) => {
  // try to get the first active player
  const activePlayer = players.find((p) => p.playBackStatus == "Playing");
  if (activePlayer != null) return activePlayer;

  // otherwise get the first "working" player
  for (const p of players) {
    if (p.title != "undefined") return p;
  }
};

export const mprisStateIcon = (status) => {
  const state = status == "Playing" ? "pause" : "play";
  return Icons.media[state];
};

export const MEDIA_CACHE_PATH = CACHE_DIR + "/media";
export const blurredPath = MEDIA_CACHE_PATH + "/blurred";

export const generateBackground = (cover_path) => {
  const url = cover_path;
  if (!url) return "";

  const makeBg = (bg) => `background: center/cover url('${bg}')`;

  const blurred = blurredPath +
    url.substring(MEDIA_CACHE_PATH.length);

  if (GLib.file_test(blurred, GLib.FileTest.EXISTS)) {
    return makeBg(blurred);
  }

  ensureDirectory(blurredPath);
  exec(`convert ${url} -blur 0x22 ${blurred}`);

  return makeBg(blurred);
};

export function lengthStr(length) {
  const min = Math.floor(length / 60);
  const sec = Math.floor(length % 60);
  const sec0 = sec < 10 ? "0" : "";
  return `${min}:${sec0}${sec}`;
}
