# Pipelined-CPU-with-Cache
Computer Architecture, Fall 2021, combined version of HW4, Lab1 & 2

## Introduction
-	Realized RISC-V pipelined CPU with L1 cache that supports 11 instructions:
    - `and`
    - `xor`
    - `sll`
    - `add`
    - `sub`
    - `mul`
    - `addi`
    - `srai`
    - `lw`
    - `sw`
    - `beq`

- Pipelined CPU with:
    - Forwarding unit
    - Hazard detection unit

- L1 Cache:
    - 2-way associative
    - LRU replacement policy
    - Write miss policy: write allocate; write hit policy: write back

## How to Run
- Put the input file (named `instruction.txt`) into `./codes` directory. For the format of `instruction.txt`, please refer to `instruction1.txt` ~ `instruction4.txt` in the `./testdata` directory

- Compile with `iverilog` and run. This will generate 2 output files, `output.txt` and `cache.txt`:
    - `output.txt`: Dump registers and data memory status
    - `cache.txt`: Record cache hit/miss status
```
$ cd codes/
$ iverilog -o CPU.out *.v
$ vvp CPU.out
```
