cmake_minimum_required (VERSION 3.26)

project (gcovr_parallel_call)

#[[ note that in real project you shall NEVER do this ]]
file (GLOB_RECURSE source_files src/*cc)

add_executable (gcovr_parallel_call)
target_sources (gcovr_parallel_call PRIVATE ${source_files})
target_compile_options (gcovr_parallel_call PRIVATE --coverage)
target_link_options (gcovr_parallel_call PRIVATE --coverage)

add_custom_target (run COMMAND gcovr_parallel_call)
