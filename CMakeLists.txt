cmake_minimum_required(VERSION 4.0)
enable_language(ASM-ATT)
set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
set(CMAKE_ASM_NASM_LINK_EXECUTABLE "ld <CMAKE_ASM_NASM_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_NASM_FLAGS_DEBUG "-g -Fdwarf")

set(SOURCE_FILES
    main.asm
    graphics.asm
)
set_source_files_properties(${SOURCE_FILES} PROPERTIES LANGUAGE ASM-ATT)

add_executable(asm_game
    ${SOURCE_FILES}
)

target_link_libraries(asm_game c glfw)
target_link_options(asm_game PRIVATE --dynamic-linker /lib64/ld-linux-x86-64.so.2)
