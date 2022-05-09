namespace RecipeBook.View {
    /**
     * Abstract view class that all of our views extend.
     */
    public abstract class AbstractView : Gtk.Box {
        /** The ID for this view. */
        public string id { get; construct; }
        /** The title of this view. */
        public string title { get; construct set; }
        /** The parent window of this view. */
        public Gtk.Window? parent_window { get; construct; }

        protected AbstractView(Gtk.Window parent_window, string id, string title) {
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0,
                id: id,
                title: title,
                parent_window: parent_window
            );
        }

        construct {
            build_view();
            connect_signals();
        }

        protected abstract void build_view();
        protected abstract void connect_signals();
    }
}
