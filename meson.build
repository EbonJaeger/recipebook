project(
    'com.github.EbonJaeger.recipebook',
    ['vala', 'c'],
    version: '0.1.0',
    license: [ 'Apache-2.0' ],
    meson_version: '>= 0.57.0',
    default_options: [
        'b_lto=false',
        'c_std=gnu11',
        'buildtype=release',
        'optimization=3',
        'warning_level=3',
    ]
)

pkg = import('pkgconfig')
gnome = import('gnome')

vala_version_required = '0.52.5'
vala = meson.get_compiler('vala')

glib_version = '>= 2.64.0'

dep_glib = dependency('glib-2.0', version: glib_version)
dep_gio = dependency('gio-unix-2.0', version: glib_version)
dep_gtk = dependency('gtk4', version: '>= 4.6.0')
dep_sqlite3 = dependency('sqlite3')

common_deps = [
    dep_glib,
    dep_gio
]

prefix = get_option('prefix')
confdir = join_paths(prefix, get_option('sysconfdir'))
datadir = join_paths(prefix, get_option('datadir'))

add_project_arguments(
    ['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
    language: 'vala'
)

config_data = configuration_data()
config_data.set('version', meson.project_version())
config_data.set('app_name', meson.project_name())

config_file = configure_file(
    input: 'config.h.in',
    output: 'config.h',
    configuration: config_data
)

config_dep = declare_dependency(
    sources: config_file,
    include_directories: include_directories('.')
)

subdir('libcore')
subdir('src')
