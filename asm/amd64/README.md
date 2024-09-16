# assemble and link
`$ yasm -f elf64 <file.asm>`
`$ ld file.o -o file`
`$ ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 /lib64/crt1.o /lib64/crti.o hilbert.o asm_io.o /lib64/crtn.o -lc -o hilbert `

# ref
- https://www.vikaskumar.org/amd64/index.html
