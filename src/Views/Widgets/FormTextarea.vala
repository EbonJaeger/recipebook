namespace RecipeBook.View.Widgets {
    /**
     * A widget containing a larger text area for multi-line
     * text input.
     */
    public class FormTextarea : FormControl {
        private Gtk.TextView? entry = null;

        public FormTextarea (string label, string description) {
            base (label, description);
        }

        construct {
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

            scroller.set_child (entry);
            this.set_form_child (scroller);
        }

        public override string get_value () {
            assert (entry != null);

            return this.entry.buffer.text;
        }

        protected override void on_widget_clicked(int n_press, double x, double y) {
            assert (entry != null);

            if (x < get_width () && y < get_height ()) {
                this.entry.grab_focus ();
            }
        }
    }
}
