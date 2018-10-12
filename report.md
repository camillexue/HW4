## Register Circuit Diagrams
![Register Diagram](https://raw.githubusercontent.com/camillexue/HW4/master/register_circuit_diagrams(1).jpg)

## Decoder Explanation
A decoder works by setting one specific output high based on an address, which can be done with vbehavioral verilog. Since in Verilog `x<<y` means the number x will be left shifted by y places (filled with 0s), the value of `enable` will be shifted by `address` places. If `enable` is zero everything is zero. If `enable` is 1 then it will be shifted by the appropriate amount based on the address. For example, if the address was 3 it would shift from `..000001` to `..001000` which puts the 1 in the correct location so that `out[address] = out[3] = 1` and all other outputs are 0.
