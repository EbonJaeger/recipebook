namespace RecipeBook.View.Widgets {
    public class CategoryButton : Gtk.Button {
        public string id { get; construct set; }

        private string? _display_name = null;
        public string? display_name {
            get { return _display_name; }
            construct set {
                this._display_name = value;
                this.set_label(value);
            }
        }

        private string? _image_source = null;
        public string? image_source {
            get { return _image_source; }
            set {
                this._image_source = value;
                this.set_image_from_name(value);
            }
        }

        private Gtk.Image image;
        private Gtk.Label name_label;

        public CategoryButton(string id, string display_name) {
            Object(
                id: id,
                display_name: display_name,
                width_request: 96,
                height_request: 96
            );
        }

        construct {
            build_widget();
        }

        private void build_widget() {
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 4);

            if (this.image == null) {
                this.image = new Gtk.Image.from_icon_name("document-open-symbolic") {
                    icon_size = Gtk.IconSize.LARGE,
                    margin_top = 16,
                    margin_bottom = 16
                };
            }
            
            box.prepend(image);
            box.append(name_label);

            this.set_child(box);
        }

        public new void set_label(string display_name) {
            if (this.name_label == null) {
                this.name_label = new Gtk.Label(display_name) {
                    ellipsize = Pango.EllipsizeMode.END,
                    max_width_chars = 64
                };

                this.set_tooltip_text(display_name);
            } else {
                this.name_label.set_text(display_name);
            }
        }

        public void set_image_from_name(string name) {
            if (this.image == null) {
                this.image = new Gtk.Image.from_icon_name(name) {
                    icon_size = Gtk.IconSize.LARGE,
                    margin_top = 16,
                    margin_bottom = 16
                };
            } else {
                this.image.set_from_icon_name(name);
            }
        }
    }
}
