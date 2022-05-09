namespace RecipeBook.View.Widgets {
    /**
     * A widget that shows a picture (if set) and allows the user
     * to select a new picture to change it.
     */
    public class FormPictureChooser : FormControl {
        public string? image_path { get; construct set; }

        public Gtk.Window? parent_window { get; construct; }

        private Gtk.Image? image;
        private Gtk.Button? dialog_open_button;
        private Gtk.FileChooserDialog? chooser_dialog;

        public FormPictureChooser (Gtk.Window parent_window, string label, string description, string? image_path = null) {
            Object (
                parent_window: parent_window,
                label_text: label,
                description: description,
                image_path: image_path,
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 4,
                hexpand: false,
                valign: Gtk.Align.START
            );
        }

        construct {
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

            // Create a button to open the file dialog
            this.dialog_open_button = new Gtk.Button.with_label ("Open file") {
                halign = Gtk.Align.START,
                hexpand = false
            };
            this.dialog_open_button.clicked.connect (on_open_button_clicked);

            // Pack everything together
            container.append (image);
            container.append (dialog_open_button);
            this.set_form_child (container);
        }

        public override string get_value () {
            return this.image_path;
        }

        protected override void on_widget_clicked (int n_press, double x, double y) {
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
                    this.handle_file_accepted (file);
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

        private void handle_file_accepted(File? file) {
            assert (file != null);
            debug ("file selected: '%s'", file.get_path ());

            // Copy the image to our local config dir
            string? path = null;
            try {
                path = copy_image_to_conf (file);
            } catch (Error e) {
                critical ("error copying file from '%s': %s", file.get_path (), e.message);
            }

            assert (path != null);

            // Set our new image in the UI
            try {
                this.set_image_from_file (path);
            } catch (Error e) {
                critical ("error getting pixbuf from '%s': %s", file.get_path (), e.message);
            }

            this.image_path = path;
            this.chooser_dialog.hide ();
            this.dialog_open_button.sensitive = true;
        }

        /**
         * Copies a `file` to the application's config directory.
         *
         * If the file already exists, it will be overwritten.
         */
        private string? copy_image_to_conf(File file) throws Error {
            var out_file = File.new_build_filename (Environment.get_user_config_dir (), "recipebook", "images", file.get_basename ());

            // Make sure our parent dir exists
            if (!out_file.get_parent ().query_exists (null)) {
                out_file.get_parent ().make_directory (null);
            }

            var copy_flags = FileCopyFlags.ALL_METADATA|FileCopyFlags.OVERWRITE;
            file.copy (out_file, copy_flags, null, null);
            return out_file.get_path ();
        }

        /**
         * Set the image in the UI from a file at the given `path`.
         *
         * The image will be scaled to 256x256, preserving the
         * aspect ratio.
         */
        private void set_image_from_file (string path) throws Error {
            var pixbuf = new Gdk.Pixbuf.from_file_at_scale (path, 256, 256, true);
            this.image.set_from_pixbuf (pixbuf);
        }
    }
}
