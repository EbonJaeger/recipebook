namespace RecipeBook.View.Widgets {
    public abstract class FormControl : Gtk.Box {
        public string? label_text { get; construct set; }
        public string? description { get; construct set; }

        private Gtk.Label? label = null;
        private Gtk.Widget? child = null;

        protected FormControl (string? label_text = null, string? description = null) {
            Object (
                label_text: label_text,
                description: description,
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0,
                //  hexpand: true,
                width_request: 300
            );
        }

        construct {
            this.label = new Gtk.Label ("<big>%s</big>".printf (label_text)) {
                use_markup = true,
                halign = Gtk.Align.START
            };

            this.tooltip_text = description;
            this.append (label);
        }

        public abstract string get_value ();

        public void set_form_child (Gtk.Widget child) {
            // If we already have a child widget, remove it first
            if (this.child != null) {
                this.remove (this.child);
            }

            this.child = child;
            this.append (child);
        }
    }
}
