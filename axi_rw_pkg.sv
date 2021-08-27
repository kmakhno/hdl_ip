package axi_rw_pkg;

    localparam  C_S0_AXI_DATA_WIDTH = 32;
    localparam  C_S0_AXI_ADDR_WIDTH = 5;

    logic                                   s0_axi_aclk;
    logic                                   s0_axi_aresetn;
    logic [C_S0_AXI_ADDR_WIDTH-1 : 0]       s0_axi_awaddr;
    logic [2 : 0]                           s0_axi_awprot;
    logic                                   s0_axi_awvalid;
    logic                                   s0_axi_awready;
    logic [C_S0_AXI_DATA_WIDTH-1 : 0]       s0_axi_wdata;
    logic [(C_S0_AXI_DATA_WIDTH/8)-1 : 0]   s0_axi_wstrb;
    logic                                   s0_axi_wvalid;
    logic                                   s0_axi_wready;
    logic [1 : 0]                           s0_axi_bresp;
    logic                                   s0_axi_bvalid;
    logic                                   s0_axi_bready;
    logic [C_S0_AXI_ADDR_WIDTH-1 : 0]       s0_axi_araddr;
    logic [2 : 0]                           s0_axi_arprot;
    logic                                   s0_axi_arvalid;
    logic                                   s0_axi_arready;
    logic [C_S0_AXI_DATA_WIDTH-1 : 0]       s0_axi_rdata;
    logic [1 : 0]                           s0_axi_rresp;
    logic                                   s0_axi_rvalid;
    logic                                   s0_axi_rready;


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