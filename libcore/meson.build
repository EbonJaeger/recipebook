recipebook_core_name = 'recipebook-core'

recipebook_core_deps = [
    common_deps,
    dep_sqlite3
]

recipebook_core_files = files(
    'Database.vala',
    'Resources.vala'
)

recipebook_core_c_dep = vala.find_library('recipebook-core-C', dirs: join_paths(meson.current_source_dir()))

recipebook_core_library = shared_library(
    recipebook_core_name,
    recipebook_core_files,
    dependencies : [ recipebook_core_deps, recipebook_core_c_dep ],
    install: true,
    install_dir: [join_paths(prefix, get_option('includedir'), recipebook_core_name)],
    version: meson.project_version(),
)

recipebook_core_dep = declare_dependency(
    link_with: recipebook_core_library,
    include_directories: include_directories('.'),
    dependencies : [ recipebook_core_deps, recipebook_core_c_dep ],
)

recipebook_core_pkgconfig = pkg.generate(
    recipebook_core_library,
    subdirs: recipebook_core_name,
    filebase: recipebook_core_name,
    name: 'Recipe Book Core Library',
    description: 'Core library used by com.github.EbonJaeger.recipebook',
    version: meson.project_version(),
)
