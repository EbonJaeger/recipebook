using RecipeBook.View.Widgets;

namespace RecipeBook.View {
    public class EditRecipe : AbstractView {
        public Recipe recipe { get; private set; }

        private FormTextEntry? title_entry = null;
        private FormTextarea? description_entry = null;
        private FormTextEntry? prep_time_entry = null;
        private FormTextEntry? cook_time_entry = null;

        public EditRecipe () {
            base ("edit-recipe", "Editing");
        }
    
        protected override void build_view () {
            var form_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 4) {
                margin_start = 16,
                margin_end = 16
            };

            var upper_form_controls = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0) {
                hexpand = true
            };

            var upper_form_control_group = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);

            this.title_entry = new FormTextEntry ("Recipe Title", "Set the title of this recipe", "New Recipe");
            this.description_entry = new FormTextarea ("Description", "Description of this recipe");
            this.prep_time_entry = new FormTextEntry ("Prep Time", "How long it takes to prepare the ingredients", "15 mins");
            this.cook_time_entry = new FormTextEntry ("Cook Time", "How long the recipe takes to cook", "30 mins");

            upper_form_control_group.append (title_entry);
            upper_form_control_group.append (description_entry);
            upper_form_control_group.append (prep_time_entry);
            upper_form_control_group.append (cook_time_entry);

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
                this.title = "Editing - %s".printf (recipe.title);
            }
        }
    }
}