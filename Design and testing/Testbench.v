module top();

     bit clk; //clock
     bit [7:0]data_tx; //input from main bus or other module
     bit en_tx; //enable signal to Tx UART 
    logic u_tx_done; //Tx is done
    logic [7:0]data_rx;  //output to main bus or other module
    bit en_rx; //enable signal to Rx UART
    logic u_rx_done; //Rx is done

    wire tx_rx;

    uart_master u1(
        .clk(clk),
        .data(data_tx),
        .en_tx(en_tx),
        .u_tx(tx_rx),
        .u_tx_done(u_tx_done)
    );

    uart_slave u2(
        .clk(clk),
        .u_rx(tx_rx),
        .en_rx(en_rx),
        .data(data_rx),
        .u_rx_done(u_rx_done)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top);
    end

    initial begin
        fork
            clkgen();
            test_sequence();
        join_any
        #500 $finish;
    end

    task clkgen;
        begin
            clk = 0;
            forever #5 clk = ~clk; // 10ns period clock
        end
    endtask

    task test_sequence;
        begin
            en_rx = 1;
            en_tx = 1;
            data_tx = 8'b00011001;
            #10
            
            wait(u_tx_done);
            en_tx = 0;
            wait(u_rx_done);
            en_rx = 0;
          
            $monitor("Received data: %h", data_rx);
        end
    endtask

endmodule
