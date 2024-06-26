class monitor;
  
  mailbox mon2scb;
  virtual uart_intf vif;
  
  function new(virtual uart_intf vif, mailbox mon2scb);
    this.vif=vif;
    this.mon2scb=mon2scb;
  endfunction
  
  task main;
    forever begin
      transaction t1;
      t1=new();
          	wait(vif.en_tx);
            t1.data_tx=vif.data_tx;
          repeat(11) begin
            @(negedge vif.clk);
          end
            t1.data_rx = vif.data_rx;
            t1.__done=(vif.rx_done);
      mon2scb.put(t1);
    end
  endtask
  
endclass
