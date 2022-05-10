namespace RecipeBook.View.Widgets {
    /**
     * A widget containing a larger text area for multi-line
     * text input.
     */
    public class FormTextarea : Gtk.Box {
        public string value { get; construct set; default = ""; }

        public string? description { get; construct set; }
        public string? label_text { get; construct set; }

        private Gtk.Label? label = null;
        private Gtk.TextView? entry = null;

        public FormTextarea (string label, string description) {
            Object (
                value: "",
                label_text: label,
                description: description,
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

            var buffer = new Gtk.TextBuffer (null) {
                enable_undo = true
            };

            var scroller = new Gtk.ScrolledWindow () {
                has_frame = true,
                hscrollbar_policy = Gtk.PolicyType.NEVER,
                vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
                min_content_height = 96,
                max_content_height = 96
            };

            this.entry = new Gtk.TextView.with_buffer (buffer) {
                input_hints = Gtk.InputHints.SPELLCHECK&Gtk.InputHints.UPPERCASE_SENTENCES,
                input_purpose = Gtk.InputPurpose.FREE_FORM,
                height_request = 96,
                top_margin = 8,
                bottom_margin = 8,
                left_margin = 8,
                right_margin = 8,
                wrap_mode = Gtk.WrapMode.WORD_CHAR,
            };

            this.bind_property ("value", entry.buffer, "text", BindingFlags.BIDIRECTIONAL);

            scroller.set_child (entry);
            this.append (scroller);
        }

        private void on_widget_clicked(int n_press, double x, double y) {
            assert (entry != null);

            if (x < get_width () && y < get_height ()) {
                this.entry.grab_focus ();
            }
        }
    }
}
