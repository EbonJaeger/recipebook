# Recipe Book
![](https://img.shields.io/github/license/EbonJaeger/recipebook)

## Description

Recipe Book is a Linux application to manage your cooking recipes. Create your own categories for recipes for organization, or leave them uncategorized. It strives to be simple and easy to use, yet powerful enough to handle any sort of recipe and style. Your recipes, your way.

The application is powered by GTK 4 and GLib, backed by a SQLite database, all written in Vala.

# Dependencies

- GTK 4: `gtk4`
- GLib: `glib-2.0`
- SQLite: `sqlite3`
- Vala

# Building & Installation

Configure the project with `meson [OPTIONS] build`, e.g: 
```
meson --prefix=/usr build
```

Build with 
```
ninja -C build
```

Install with 
```
sudo ninja install -C build
```

## License

recipebook is licensed under Apache 2.0.
