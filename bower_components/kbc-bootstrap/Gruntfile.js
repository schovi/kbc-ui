module.exports = function(grunt) {
    grunt.initConfig({

        less: {
            development: {
                options: {
                    paths: ["css"]
                },
                files: {"dist/css/kbc.css": "less/kbc.less"}
            },
            production: {
                options: {
                    paths: ["dist/css"],
                    cleancss: true,
                    compress: true
                },
                files: {"dist/css/kbc.css": "less/kbc.less"}
            }
        },

        copy: {
            font_awesome: {
                expand: true,
                flatten: true,
                src: ['bower_components/font-awesome/fonts/*'],
                dest: 'dist/fonts'
            },
            kbc_icons: {
                expand: true,
                flatten: true,
                src: ['fonts/*'],
                dest: 'dist/fonts'
            }
        },

        watch: {
            scripts: {
                files: ['**/*.less'],
                tasks: ['less:development'],
                options: {
                    spawn: false
                }
            }
        }
    });
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('default', ['less', 'copy']);
};