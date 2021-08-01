module edge_detector
#(
    parameter TYPE = "RISING"
)
(
    input i_clk,
    input i_rst_n,
    input i_ena,
    input i_strobe,
    output reg o_edge
);

(* ASYNC_REG="TRUE" *) reg [1:0] sreg;

always @(posedge i_clk)
begin
    if (!i_rst_n)
        sreg <= 2'b0;
    else if (i_ena)
        sreg <= {sreg[0], i_strobe};
end

generate
    if (TYPE == "FALLING")
        always @(posedge i_clk)
        begin
            if (!i_rst_n)
                o_edge <= 0;
            else
                o_edge <= (sreg == 2'b01);
        end
    else
        always @(posedge i_clk)
        begin
            if (!i_rst_n)
                o_edge <= 0;
            else
                o_edge <= (sreg == 2'b10);
        end
endgenerate

endmodule