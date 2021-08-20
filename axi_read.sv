task axi_read;
    input  logic [31:0] addr;
    output logic [31:0] data;
begin
    s0_axi_rready = 0;
    fork
        //--- Read address channel
        begin
            s0_axi_arprot = 0;
            s0_axi_araddr = addr;
            s0_axi_arvalid = 1;
            while (!s0_axi_arready) begin
                @(negedge s0_axi_aclk);
            end
            @(posedge s0_axi_aclk);
            s0_axi_arvalid = 0;
        end
        //--- Read data channel
        begin
            while (!s0_axi_rvalid) begin
                @(negedge s0_axi_aclk);
            end
            @(posedge s0_axi_aclk);
            s0_axi_rready = 1;
        end
    join
    $display("rresp = %0d", s0_axi_rresp);
    data = s0_axi_rdata;
    @(posedge s0_axi_aclk);
    s0_axi_rready = 0;
end
endtask