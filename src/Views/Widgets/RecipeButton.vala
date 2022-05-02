namespace RecipeBook.View.Widgets {
    /**
     * This class is a button for navigating to a recipe inside of
     * a category.
     */
    public class RecipeButton : Gtk.Button {
        public string image_name { get; construct set; }
        public string recipe_name { get; construct set; }
        public string description { get; construct set; }

        private Gtk.Image image;
        private Gtk.Label name_label;
        private Gtk.Label description_label;

        public RecipeButton(string name, string description, string? image_name) {
            Object(
                image_name: image_name ?? "camera-photo-symbolic",
                recipe_name: name,
                description: description,
                width_request: 256,
                height_request: 96,
                hexpand: false
            );
        }

        construct {
            this.build_widget();
        }

        private void build_widget() {
            var container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

            this.image = new Gtk.Image.from_icon_name(image_name) {
                icon_size = Gtk.IconSize.LARGE,
                margin_start = 16,
                margin_end = 16,
                width_request = 64,
                height_request = 64
            };

            var text_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12) {
                halign = Gtk.Align.START,
                hexpand = true,
                margin_top = 16
            };

            this.name_label = new Gtk.Label("<big>%s</big>".printf(recipe_name)) {
                halign = Gtk.Align.START,
                use_markup = true
            };

            this.description_label = new Gtk.Label(description) {
                ellipsize = Pango.EllipsizeMode.END,
                wrap_mode = Pango.WrapMode.WORD_CHAR,
                lines = 2,
                max_width_chars = 48
            };
            this.description_label.get_style_context().add_class("dim-label");

            text_box.append(name_label);
            text_box.append(description_label);

            container.append(image);
            container.append(text_box);
            this.set_child(container);
        }
    }
}
