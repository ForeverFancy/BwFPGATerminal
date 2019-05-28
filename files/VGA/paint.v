module paint(
    input [7:0] ascii,
    output [127:0] data
);

//96*128bit

dist_mem_gen_0 my_mem (.a(ascii), .spo(data));

endmodule // paint