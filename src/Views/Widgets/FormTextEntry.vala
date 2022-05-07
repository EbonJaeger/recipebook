namespace RecipeBook.View.Widgets {
    /**
     * A widget containing a single-line text input.
     */
    public class FormTextEntry : FormControl {
        private string placeholder_text;

        private Gtk.Entry? entry = null;

        public FormTextEntry (string label, string description, string placeholder_text) {
            base (label, description);
            this.placeholder_text = placeholder_text;
        }

        construct {
            this.entry = new Gtk.Entry () {
                placeholder_text = placeholder_text
            };
            this.set_form_child (entry);
        }

        public override string get_value () {
            assert (entry != null);

            return this.entry.text;
        }

        protected override void on_widget_clicked(int n_press, double x, double y) {
            assert (entry != null);

            if (x < get_width () && y < get_height ()) {
                this.entry.grab_focus ();
            }
        }
    }
}
