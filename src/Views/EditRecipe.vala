using RecipeBook.View.Widgets;

namespace RecipeBook.View {
    public class EditRecipe : AbstractView {
        public Recipe? recipe { get; private set; default = null; }

        private FormPictureChooser? picture_changer = null;
        private FormTextEntry? title_entry = null;
        private FormTextarea? description_entry = null;
        private FormTextEntry? prep_time_entry = null;
        private FormTextEntry? cook_time_entry = null;

        private bool is_bound = false;

        private Binding? title_bind = null;
        private Binding? description_bind = null;
        private Binding? image_path_bind = null;
        private Binding? prep_time_bind = null;
        private Binding? cook_time_bind = null;

        public EditRecipe (Window parent_window) {
            base (parent_window, "edit-recipe", "Editing");
        }
    
        protected override void build_view () {
            var form_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 4) {
                margin_start = 16,
                margin_end = 16
            };

            var upper_form_controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
                hexpand = true
            };

            this.picture_changer = new FormPictureChooser (parent_window, "Recipe Picture", null);
            this.picture_changer.image_accepted.connect (on_image_accepted);
            this.picture_changer.image_removed.connect (on_image_removed);

            var upper_form_control_group = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);

            this.title_entry = new FormTextEntry ("Recipe Title", "Set the title of this recipe", "New Recipe");
            this.description_entry = new FormTextarea ("Description", "Description of this recipe");
            this.prep_time_entry = new FormTextEntry ("Prep Time", "How long it takes to prepare the ingredients", "15 mins");
            this.cook_time_entry = new FormTextEntry ("Cook Time", "How long the recipe takes to cook", "30 mins");

            upper_form_control_group.append (title_entry);
            upper_form_control_group.append (description_entry);
            upper_form_control_group.append (prep_time_entry);
            upper_form_control_group.append (cook_time_entry);

            upper_form_controls.append (picture_changer);
            upper_form_controls.append (upper_form_control_group);
            form_box.append (upper_form_controls);

            this.append (form_box);
        }
    
        protected override void connect_signals () {
        }

        /**
         * Updates the form values from a `recipe`.
         */
        public void update_from_recipe (Recipe recipe) {
            this.recipe = recipe;

            if (recipe.title != "") {
                this.title = "Editing %s".printf (recipe.title);
            } else {
                this.title = "Editing New Recipe";
            }

            this.title_entry.value = recipe.title;
            this.description_entry.value = recipe.description;
            this.prep_time_entry.value = recipe.prep_time;
            this.cook_time_entry.value = recipe.cook_time;

            if (recipe.image_path != null || recipe.image_path != "") {
                try {
                    this.picture_changer.set_new_image_path (recipe.image_path);
                } catch (Error e) {
                    critical ("error setting form control picture: %s", e.message);
                }
            }

            // Rebind all of the properties
            this.unbind_all ();
            this.title_bind = title_entry.bind_property ("value", recipe, "title", BindingFlags.DEFAULT);
            this.description_bind = description_entry.bind_property ("value", recipe, "description", BindingFlags.DEFAULT);
            this.image_path_bind = picture_changer.bind_property ("image-path", recipe, "image-path", BindingFlags.DEFAULT);
            this.prep_time_bind = prep_time_entry.bind_property ("value", recipe, "prep-time", BindingFlags.DEFAULT);
            this.cook_time_bind = cook_time_entry.bind_property ("value", recipe, "cook-time", BindingFlags.DEFAULT);
            this.is_bound = true;
        }

        private void on_image_accepted(string image_path) {
            var file = File.new_for_path (image_path);

            // Copy the image to our local config dir
            string? path = null;
            try {
                path = parent_window.copy_image_to_conf (file);
                // Set the prop on the changer, since that'll get
                // propagated to the recipe via the binding.
                this.picture_changer.set_new_image_path (path);
            } catch (Error e) {
                critical ("error setting new image: %s", e.message);
            }
        }

        /**
         * Handles when the button to remove this recipe's image is clicked.
         *
         * If the image isn't in use by any other recipes, the file in our
         * config directory will be deleted.
         */
        private void on_image_removed (string image_path) {
            // TODO: Remove the image from this recipe in the database.
            //       We have to do this to make the count unambiguous.
            var db = Database.@get ();

            // Check if this image is in use in another recipe first
            int image_uses = 0;
            try {
                image_uses = db.count_image_uses (Path.get_basename (image_path));
            } catch (IOError e) {
                critical ("error checking if image is in use: %s", e.message);
            }

            if (image_uses > 0) {
                return;
            }

            // Delete the file
            var file = File.new_for_path (image_path);
            try {
                file.delete (null);
            } catch (Error e) {
                warning ("unable to delete recipe image '%s': %s", image_path, e.message);
            }
        }

        private void unbind_all() {
            if (!is_bound) {
                return;
            }

            title_bind.unbind ();
            description_bind.unbind ();
            image_path_bind.unbind ();
            prep_time_bind.unbind ();
            cook_time_bind.unbind ();

            this.is_bound = false;
        }
    }
}
