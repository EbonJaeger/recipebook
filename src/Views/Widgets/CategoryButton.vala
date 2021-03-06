namespace RecipeBook.View.Widgets {
    /**
     * This class is a button for use in the category view to navigate
     * to the various categories that a user might have set up.
     */
    public class CategoryButton : Gtk.Button {
        public Category category { get; construct; }

        private Gtk.Image image;
        private Gtk.Label name_label;

        /**
         * Create a new CategoryButton from a `category` object.
         */
        public CategoryButton (Category category) {
            Object (
                category: category,
                width_request: 96,
                height_request: 96
            );
        }

        construct {
            build_widget ();
        }

        private void build_widget () {
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 4);

            this.image = new Gtk.Image () {
                icon_size = Gtk.IconSize.LARGE,
                margin_top = 16,
                margin_bottom = 16
            };

            if (category.image_path != null && category.image_path.has_prefix ("/")) {
                this.image.set_from_file (category.image_path);
            } else {
                this.image.set_from_icon_name (category.image_path ?? "document-open-symbolic");
            }

            this.name_label = new Gtk.Label (category.name) {
                ellipsize = Pango.EllipsizeMode.END,
                max_width_chars = 64
            };

            this.set_tooltip_text (category.description);

            box.prepend (image);
            box.append (name_label);

            this.set_child (box);
        }
    }
}
