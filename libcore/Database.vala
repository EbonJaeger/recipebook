namespace RecipeBook {
    public class Database : Object {
        private enum RecipeColumns {
            ID = 0,
            TITLE = 1,
            DESCRIPTION = 2,
            PICTURE = 3,
            PREP_TIME = 4,
            COOK_TIME = 5
        }

        private static Database _instance;

        protected Sqlite.Database db;

        private Database() {
            try {
                open_recipes_db();
            } catch (IOError e) {
                critical("Unable to open recipes database: %s", e.message);
            }
        }

        public static new Database @get() {
            if (_instance == null) {
                _instance = new Database();
            }

            return _instance;
        }

        private bool open_recipes_db() throws GLib.IOError {
            File data_dir = File.new_build_filename(Environment.get_user_config_dir(), "recipebook");

            try {
                if (!data_dir.query_exists(null)) {
                    data_dir.make_directory_with_parents(null);
                }
            } catch (Error e) {
                throw new GLib.IOError.FAILED("Unable to create data directory %s: %s", data_dir.get_path(), e.message);
            }

            var db_path = data_dir.get_child("recipes.db").get_path();
            debug("Recipe database path: %s", db_path);

            return open_db(db_path);
        }

        public bool open_db(string path) {
            int rc = Sqlite.Database.open_v2(path, out db, Sqlite.OPEN_READWRITE | Sqlite.OPEN_CREATE, null);

            if (rc != Sqlite.OK) {
                warning("Unable to open database %s: Code %d: %s", path, rc, db.errmsg());
                return false;
            }

            rc = db.exec("PRAGMA synchronous=off;");

            if (rc != Sqlite.OK) {
                warning("Unable to set synchronous mode to off: Code %d: %s", rc, db.errmsg());
            }

            return initialize_tables();
        }

        /**
         * Count the number of times that an `image` is used.
         */
        public int count_image_uses (string image) throws IOError {
            Sqlite.Statement stmt;
            var sql = "SELECT COUNT(id) FROM recipes WHERE picture = $NAME;";
            int ret = db.prepare_v2 (sql, sql.length, out stmt);

            if (ret != Sqlite.OK) {
                throw new GLib.IOError.FAILED ("error counting images: code: %d: %s", ret, db.errmsg ());
            }

            // Bind the statement params
            int parameter_pos = stmt.bind_parameter_index ("$NAME");
            assert (parameter_pos > 0);
            stmt.bind_text (parameter_pos, image);

            // Execute the query
            stmt.step ();
            return stmt.column_int(0);
        }

        /**
         * Re-populates a `ListStore` with all of the current categories in the
         * database.
         */
        public void rebuild_categories(ListStore store) throws IOError {
            store.remove_all();

            // Create the statement
            Sqlite.Statement stmt;
            var sql = "SELECT * FROM categories;";
            int ret = db.prepare_v2(sql, sql.length, out stmt);

            if (ret != Sqlite.OK) {
                throw new GLib.IOError.FAILED("error getting categories: code: %d: %s", ret, db.errmsg());
            }

            // Execute the statement and get the data
            int cols = stmt.column_count();
            while (stmt.step() == Sqlite.ROW) {
                string id = null, name = null, description = null;
                string? picture = null;

                // Get the text from each column in this row
                for (int i = 0; i < cols; i++) {
                    var text = stmt.column_text(i);

                    // Figure out what column we're on
                    switch (i) {
                        case 0:
                            id = text;
                            break;
                        case 1:
                            name = text;
                            break;
                        case 2:
                            description = text;
                            break;
                        case 3:
                            picture = text;
                            break;
                        default:
                            critical("Unknown column index: %d", i);
                            continue;
                    }
                }

                // Add the category
                store.append(new Category(id, name, description, picture));
            }
        }

        public Gee.LinkedList<Recipe> rebuild_recipes(Category category) throws IOError {
            Gee.LinkedList<Recipe> recipes = new Gee.LinkedList<Recipe>();

            // Create the statement
            Sqlite.Statement stmt;
            var sql = """
                SELECT id,title,description,picture,prep_time,cook_time
                FROM recipes
                WHERE category = $CATEGORY;
            """;
            int ret = db.prepare_v2(sql, sql.length, out stmt);
            if (ret != Sqlite.OK) {
                throw new GLib.IOError.FAILED("error getting recipes in category '%s': code: %d: %s", category.name, ret, db.errmsg());
            }

            // Bind the sql parameters
            int parameter_pos = stmt.bind_parameter_index("$CATEGORY");
            assert(parameter_pos > 0);
            stmt.bind_text(parameter_pos, category.id);

            // Execute the query and get the data
            int cols = stmt.column_count();
            while (stmt.step() == Sqlite.ROW) {
                int id = 0;
                string title = null, description = null;
                string? image_path = null, prep_time = null, cook_time = null;

                for (int i = 0; i < cols; i++) {
                    switch (i) {
                        case RecipeColumns.ID:
                            id = stmt.column_int(i);
                            break;
                        case RecipeColumns.TITLE:
                            title = stmt.column_text(i);
                            break;
                        case RecipeColumns.DESCRIPTION:
                            description = stmt.column_text(i);
                            break;
                        case RecipeColumns.PICTURE:
                            image_path = stmt.column_text(i);
                            break;
                        case RecipeColumns.PREP_TIME:
                            prep_time = stmt.column_text(i);
                            break;
                        case RecipeColumns.COOK_TIME:
                            cook_time = stmt.column_text(i);
                            break;
                        default:
                            critical("Unknown column index: %d", i);
                            continue;
                    }
                }

                // TODO: Get the ingredients and steps

                recipes.add(new Recipe(category, id, title, description, image_path, prep_time, cook_time));
            }

            return recipes;
        }

        private bool initialize_tables() {
            var query = """
                CREATE TABLE IF NOT EXISTS categories (
                    id TEXT PRIMARY KEY,
                    name TEXT NOT NULL,
                    description TEXT NOT NULL,
                    picture TEXT
                );

                INSERT OR IGNORE INTO categories (id, name, description, picture) 
                VALUES(
                    'unorganized', 'Unorganized', 'Recipes that don''t fit in any other category', 'document-new-symbolic'
                );

                INSERT OR IGNORE INTO categories (id, name, description, picture) 
                VALUES(
                    'add-category', 'Add Category', 'Create a new catetory of recipes', 'document-new-symbolic'
                );

                CREATE TABLE IF NOT EXISTS recipes (
                    id INTEGER PRIMARY KEY,
                    category TEXT,
                    picture TEXT,
                    title TEXT NOT NULL,
                    description TEXT NOT NULL,
                    prep_time TEXT NOT NULL,
                    cook_time TEXT NOT NULL,
                    FOREIGN KEY(category) REFERENCES categories(id)
                );

                CREATE TABLE IF NOT EXISTS ingredient_sections (
                    id INTEGER PRIMARY KEY,
                    recipe_id INTEGER,
                    title TEXT NOT NULL,
                    FOREIGN KEY(recipe_id) REFERENCES recipes(id)
                );

                CREATE TABLE IF NOT EXISTS ingredients (
                    id INTEGER PRIMARY KEY,
                    recipe_id INTEGER,
                    section_id INTEGER,
                    item TEXT NOT NULL,
                    FOREIGN KEY(recipe_id) REFERENCES recipes(id),
                    FOREIGN KEY(section_id) REFERENCES ingredient_sections(id)
                );

                CREATE TABLE IF NOT EXISTS steps_sections (
                    id INTEGER PRIMARY KEY,
                    recipe_id INTEGER,
                    title TEXT NOT NULL,
                    FOREIGN KEY(recipe_id) REFERENCES recipes(id)
                );

                CREATE TABLE IF NOT EXISTS steps (
                    id INTEGER PRIMARY KEY,
                    recipe_id INTEGER,
                    section_id INTEGER,
                    item TEXT NOT NULL,
                    FOREIGN KEY(recipe_id) REFERENCES recipes(id),
                    FOREIGN KEY(section_id) REFERENCES ingredient_sections(id)
                );
            """;

            string? errmsg;
            int ret = db.exec(query, null, out errmsg);
            if (ret != Sqlite.OK) {
                critical("Error initializing database information: %s", errmsg);
                return false;
            }

            return true;
        }
    }
}
