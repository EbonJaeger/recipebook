namespace RecipeBook.View {
    /**
     * Abstract view class that all of our views extend.
     */
    public abstract class AbstractView : Gtk.Box {
        /** The ID for this view. */
        public string id { get; construct; }
        /** The title of this view. */
        public string title { get; construct; }

        protected AbstractView(string id, string title) {
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0,
                id: id,
                title: title
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
