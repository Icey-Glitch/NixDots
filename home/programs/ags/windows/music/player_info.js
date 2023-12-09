import { Mpris, Utils, Widget } from "../../imports.js";
import Gtk from "gi://Gtk?version=3.0";

export default Widget.Box({
  className: "player-info",
  vexpand: true,
  valign: Gtk.Align.START,

  children: [
    Widget.Icon({
      hexpand: true,
      halign: Gtk.Align.END,
      className: "player-icon",
      tooltipText: player.value?.identity ?? "",

      connections: [[
        Mpris,
        (self) =>
          self.icon = Utils.lookUpIcon(player.value?.entry)
            ? player.value?.entry
            : "view-media-track",
        "player-changed",
      ]],
    }),
  ],
});
