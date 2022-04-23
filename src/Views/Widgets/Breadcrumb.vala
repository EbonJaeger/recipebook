namespace RecipeBook.View.Widgets {
    /**
     * This class represents a single crumb in a chain of
     * breadcrumbs.
     */
    public class Breadcrumb : Gtk.Button {
        public AbstractView view { get; construct; }

        /**
         * Create a new breadcrumb from the given `view`.
         */
        public Breadcrumb(AbstractView view) {
            Object(view: view, has_frame: false);
        }

        construct {
            label = view.title;
            tooltip_text = view.title;
        }

        /**
         * Dim the text in this label.
         */
        public void dim() {
            this.get_style_context().add_class("dim-label");
        }

        /**
         * Undim the text in this label.
         */
        public void undim() {
            this.get_style_context().remove_class("dim-label");
        }
    }
}
