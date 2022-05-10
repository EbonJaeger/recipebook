namespace RecipeBook.View.Widgets {
    /**
     * A widget containing a single-line text input.
     */
    public class FormTextEntry : Gtk.Box {
        public string value { get; construct set; default = ""; }

        public string? description { get; construct set; }
        public string? label_text { get; construct set; }
        public string? entry_placeholder { get; construct set; }

        private Gtk.Label? label = null;
        private Gtk.Entry? entry = null;

        public FormTextEntry (string label, string description, string entry_placeholder) {
            Object (
                value: "",
                label_text: label,
                description: description,
                entry_placeholder: entry_placeholder,
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 4,
                hexpand: true
            );
        }

        construct {
            this.label = new Gtk.Label ("<big>%s</big>".printf (label_text)) {
                use_markup = true,
                halign = Gtk.Align.START
            };

            this.tooltip_text = description;
            this.append (label);

            var controller = new Gtk.GestureClick ();
            controller.pressed.connect (on_widget_clicked);
            this.add_controller (controller);

            this.entry = new Gtk.Entry () {
                placeholder_text = entry_placeholder
            };

            this.bind_property ("value", entry.buffer, "text", BindingFlags.BIDIRECTIONAL);
            this.append (entry);
        }

        private void on_widget_clicked(int n_press, double x, double y) {
            assert (entry != null);

            if (x < get_width () && y < get_height ()) {
                this.entry.grab_focus ();
            }
        }
    }
}
