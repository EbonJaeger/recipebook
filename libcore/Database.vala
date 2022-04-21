namespace RecipeBook {
    public class Database {
        protected static Sqlite.Database db;

        public Database() {
            try {
                open_recipes_db();
            } catch (IOError e) {
                critical("Unable to open recipes database: %s", e.message);
            }
        }

        public bool open_recipes_db() throws GLib.IOError {
            File home_dir = File.new_for_path(Environment.get_home_dir());
            File data_dir = home_dir.get_child(".config").get_child("recipebook");

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

        private bool initialize_tables() {
            // Create recipes table
            Sqlite.Statement create_recipes;
            int ret = db.prepare_v2("CREATE TABLE IF NOT EXISTS recipes (" +
                                        "id INTEGER PRIMARY KEY, " +
                                        "picture TEXT, " +
                                        "title TEXT NOT NULL, " +
                                        "description TEXT NOT NULL, " +
                                        "prep_time TEXT NOT NULL, " +
                                        "cook_time TEXT NOT NULL" +
                                    ");",
                                    -1,
                                    out create_recipes);

            assert(ret == Sqlite.OK);
            ret = create_recipes.step();

            if (ret != Sqlite.DONE) {
                critical("Unable to create recipes table: Code %d: %s", ret, db.errmsg());
                return false;
            }

            // Create ingredient section table
            Sqlite.Statement create_sections_stmt;
            ret = db.prepare_v2("CREATE TABLE IF NOT EXISTS ingredient_sections (" +
                                    "id INTEGER PRIMARY KEY, " +
                                    "recipe_id INTEGER, " +
                                    "title TEXT NOT NULL, " +
                                    "FOREIGN KEY(recipe_id) REFERENCES recipes(id)" +
                                ");",
                                -1,
                                out create_sections_stmt);

            assert(ret == Sqlite.OK);
            ret = create_sections_stmt.step();

            if (ret != Sqlite.DONE) {
                critical("Unable to create ingredient section table: Code %d: %s", ret, db.errmsg());
                return false;
            }

            // Create ingredients table
            Sqlite.Statement create_ingredients_stmt;
            ret = db.prepare_v2("CREATE TABLE IF NOT EXISTS ingredients (" +
                                    "id INTEGER PRIMARY KEY, " +
                                    "recipe_id INTEGER, " +
                                    "section_id INTEGER, " +
                                    "item TEXT NOT NULL, " +
                                    "FOREIGN KEY(recipe_id) REFERENCES recipes(id), " +
                                    "FOREIGN KEY(section_id) REFERENCES ingredient_sections(id)" +
                                ");",
                                -1,
                                out create_ingredients_stmt);

            assert(ret == Sqlite.OK);
            ret = create_ingredients_stmt.step();

            if (ret != Sqlite.DONE) {
                critical("Unable to create ingredients table: Code %d: %s", ret, db.errmsg());
                return false;
            }

            // Create directions section table
            Sqlite.Statement create_steps_sections_stmt;
            ret = db.prepare_v2("CREATE TABLE IF NOT EXISTS steps_sections (" +
                                    "id INTEGER PRIMARY KEY, " +
                                    "recipe_id INTEGER, " +
                                    "title TEXT NOT NULL, " +
                                    "FOREIGN KEY(recipe_id) REFERENCES recipes(id)" +
                                ");",
                                -1,
                                out create_steps_sections_stmt);

            assert(ret == Sqlite.OK);
            ret = create_steps_sections_stmt.step();

            if (ret != Sqlite.DONE) {
                critical("Unable to create steps section table: Code %d: %s", ret, db.errmsg());
                return false;
            }

            // Create ingredients table
            Sqlite.Statement create_steps_stmt;
            ret = db.prepare_v2("CREATE TABLE IF NOT EXISTS steps (" +
                                    "id INTEGER PRIMARY KEY, " +
                                    "recipe_id INTEGER, " +
                                    "section_id INTEGER, " +
                                    "item TEXT NOT NULL, " +
                                    "FOREIGN KEY(recipe_id) REFERENCES recipes(id), " +
                                    "FOREIGN KEY(section_id) REFERENCES ingredient_sections(id)" +
                                ");",
                                -1,
                                out create_steps_stmt);

            assert(ret == Sqlite.OK);
            ret = create_steps_stmt.step();

            if (ret != Sqlite.DONE) {
                critical("Unable to create steps table: Code %d: %s", ret, db.errmsg());
                return false;
            }

            return true;
        }
    }
}
