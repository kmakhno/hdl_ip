module sync_chain
(
    input i_clk,
    input i_async,
    output o_sync
);

(* ASYNC_REG="TRUE" *) reg [1:0] sreg;

always @(posedge i_clk)
begin
    sreg <= {sreg[0], i_async};
end

assign o_sync = sreg;

endmodule