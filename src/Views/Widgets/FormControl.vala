namespace RecipeBook.View.Widgets {
    /**
     * An abstract form control consisting of at minimum a label
     * and an input of some sort.
     */
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
                spacing: 4,
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

            var controller = new Gtk.GestureClick ();
            controller.pressed.connect (on_widget_clicked);
            this.add_controller (controller);
        }

        /**
         * Get the value of the inner entry of this form control.
         */
        public abstract string get_value ();

        /**
         * Handles the pressed event from a `Gtk.GestureClick`.
         *
         * When any part of the widget is clicked, make the inner
         * form input focused.
         */
        protected abstract void on_widget_clicked(int n_press, double x, double y);

        /**
         * Set the inner input `child` for this form control.
         */
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
