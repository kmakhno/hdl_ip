task axi_write;
input logic [31:0]  addr;
input logic [31:0] data;
input logic [3:0]  strb;
logic [1:0]  resp;
begin
    s0_axi_bready = 0;
    fork
        begin
            //--- Write address channel
            s0_axi_awprot = 0;
            s0_axi_awvalid = 1;
            s0_axi_awaddr = addr;
            while (!s0_axi_awready) begin
                @(negedge s0_axi_aclk);
            end
            @(posedge s0_axi_aclk);
            s0_axi_awvalid = 0;
            //-------------------------
        end

        begin
            //--- Write data channel
            s0_axi_wvalid = 1;
            s0_axi_wstrb = strb;
            s0_axi_wdata = data;
            while (!s0_axi_wready) begin
                @(negedge s0_axi_aclk);
            end
            @(posedge s0_axi_aclk);
            s0_axi_wvalid = 0;
            //----------------------
        end
    join
    //--- Write response channel
    while (!s0_axi_bvalid) begin
        @(negedge s0_axi_aclk);
    end
    @(posedge s0_axi_aclk);
    s0_axi_bready = 1;
    @(posedge s0_axi_aclk);
    resp = s0_axi_bresp;
    s0_axi_bready = 0;
    $display("resp=%0d", resp);
end
endtask