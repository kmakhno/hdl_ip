package axi_rw_pkg;

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

    
endpackage