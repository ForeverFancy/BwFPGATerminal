module paint(
    input [7:0] ascii,
    output [127:0] data
);

//96*128bit

dist_mem_gen_0 ascii_rom (.a(ascii), .spo(data));

endmodule // paint