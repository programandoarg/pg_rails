# # frozen_string_literal: true

# # # frozen_string_literal: true

# if Rails.env.development?
#   Annotate.set_defaults(
#     # 'show_migration' => 'true',
#     'show_foreign_keys' => 'true',
#     'show_indexes' => 'true',
#     'exclude_controllers' => 'true',
#     'exclude_helpers' => 'true',
#     'exclude_tests' => 'true',
#     'classified_sort' => 'true',
#     'with_comment' => 'true',

#     'models' => 'true'
#   )

#   # Annotate models
#   task :annotate do
#     puts 'Annotating models...'
#     system 'bundle exec annotate'
#   end

#   # Run annotate task after db:migrate
#   #  and db:rollback tasks
#   Rake::Task['db:migrate'].enhance do
#     Rake::Task['annotate'].invoke
#   end

#   Rake::Task['db:rollback'].enhance do
#     Rake::Task['annotate'].invoke
#   end
# end
