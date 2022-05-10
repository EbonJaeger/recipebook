namespace RecipeBook.View.Widgets {
    /**
     * A widget that shows a picture (if set) and allows the user
     * to select a new picture to change it.
     */
    public class FormPictureChooser : Gtk.Box {
        public string? image_path { get; construct set; }

        public Gtk.Window? parent_window { get; construct; }

        public string? label_text { get; construct set; }

        private Gtk.Label? label;
        private Gtk.Image? image;
        private Gtk.Button? dialog_open_button;
        private Gtk.Button? remove_picture_button;
        private Gtk.FileChooserDialog? chooser_dialog;

        public signal void image_accepted (string image_path);
        public signal void image_removed (string image_path);

        public FormPictureChooser (Gtk.Window parent_window, string label, string? image_path = null) {
            Object (
                parent_window: parent_window,
                label_text: label,
                image_path: image_path,
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 4,
                hexpand: false,
                valign: Gtk.Align.START
            );
        }

        construct {
            this.label = new Gtk.Label ("<big>%s</big>".printf (label_text)) {
                use_markup = true,
                halign = Gtk.Align.START
            };

            this.append (label);

            // Create a container to hold all of our other widgets
            var container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            // Create our image widget
            this.image = new Gtk.Image () {
                pixel_size = 256
            };

            // Set the image from either a file, or an icon name
            if (image_path == null || image_path == "") {
                this.image.set_from_icon_name ("folder-pictures-symbolic");
            } else {
                try {
                    this.set_image_from_file (image_path);
                } catch (Error e) {
                    critical ("error setting image from file '%s': %s", image_path, e.message);
                }
            }

            // File filter for the chooser dialog
            var file_filter = new Gtk.FileFilter ();
            file_filter.add_pixbuf_formats ();

            // Create a file chooser dialog
            this.chooser_dialog = new Gtk.FileChooserDialog ("Choose Picture", parent_window, Gtk.FileChooserAction.OPEN, "Open", Gtk.ResponseType.ACCEPT, "Cancel", Gtk.ResponseType.CANCEL) {
                filter = file_filter,
                select_multiple = false
            };
            var pictures_dir = GLib.File.new_build_filename (Environment.get_home_dir (), "Pictures");

            // Try to set the dialog starting dir to the user's picture folder
            try {
                this.chooser_dialog.set_current_folder (pictures_dir);
            } catch (Error e) {
                critical ("error setting file chooser folder: %s", e.message);
            }

            this.chooser_dialog.response.connect (on_dialog_response);

            var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4) {
                hexpand = true
            };

            // Create a button to open the file dialog
            this.dialog_open_button = new Gtk.Button.with_label ("Open file") {
                //  halign = Gtk.Align.FILL,
                hexpand = true
            };
            this.dialog_open_button.clicked.connect (on_open_button_clicked);

            // Create a button to remove the current picture
            this.remove_picture_button = new Gtk.Button.with_label ("Remove image") {
                hexpand = true,
                sensitive = image_path != null && image_path != ""
            };
            this.remove_picture_button.clicked.connect (() => {
                debug ("removing recipe image");
                this.remove_picture_button.sensitive = false;
                var image_path_old = image_path.dup ();
                this.image_path = "";
                this.image.set_from_icon_name ("folder-pictures-symbolic");
                this.image_removed (image_path_old);
            });

            // Pack everything together
            button_box.append (dialog_open_button);
            button_box.append (remove_picture_button);

            container.append (image);
            container.append (button_box);
            this.append (container);
        }

        public void set_new_image_path (string path) throws Error {
            this.image_path = path;
            this.set_image_from_file (path);
        }

        private void on_open_button_clicked() {
            if (chooser_dialog.visible) {
                return;
            }

            this.dialog_open_button.sensitive = false;
            this.chooser_dialog.show ();
        }

        /**
         * Handles responses from a file chooser dialog.
         *
         * If an image is selected, it is coped to our local
         * config directory before updating the image in the
         * UI. This is done so we (hopefully) still have an
         * image to use if the original gets deleted.
         *
         * If the dialog should be closed, this simply closes
         * the dialog.
         */
        private void on_dialog_response (int id) {
            switch (id) {
                case Gtk.ResponseType.ACCEPT:
                    var file = chooser_dialog.get_file ();
                    assert (file != null);
                    debug ("file selected: '%s'", file.get_path ());

                    this.image_accepted (file.get_path ());

                    this.chooser_dialog.hide ();
                    this.dialog_open_button.sensitive = true;
                    this.remove_picture_button.sensitive = true;
                    break;
                case Gtk.ResponseType.CLOSE:
                case Gtk.ResponseType.CANCEL:
                    debug ("file chooser dialog closed");
                    this.chooser_dialog.hide ();
                    this.dialog_open_button.sensitive = true;
                    break;
                default:
                    critical ("unknown dialog response ID: %d", id);
                    break;
            }
        }

        /**
         * Set the image in the UI from a file at the given `path`.
         *
         * The image will be scaled to 256x256, preserving the
         * aspect ratio.
         */
        public void set_image_from_file (string path) throws Error {
            var pixbuf = new Gdk.Pixbuf.from_file_at_scale (path, 256, 256, true);
            this.image.set_from_pixbuf (pixbuf);
        }
    }
}
