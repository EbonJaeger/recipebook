namespace RecipeBook.View.Widgets {
    public class FormTextarea : FormControl {
        private Gtk.TextView? entry = null;

        public FormTextarea (string label, string description) {
            base (label, description);
        }

        construct {
            var buffer = new Gtk.TextBuffer (null) {
                enable_undo = true
            };
            this.entry = new Gtk.TextView.with_buffer (buffer) {
                input_hints = Gtk.InputHints.SPELLCHECK&Gtk.InputHints.UPPERCASE_SENTENCES,
                input_purpose = Gtk.InputPurpose.FREE_FORM,
                height_request = 96
            };
            this.set_form_child (entry);
        }

        public override string get_value () {
            assert (entry != null);

            return this.entry.buffer.text;
        }
    }
}
