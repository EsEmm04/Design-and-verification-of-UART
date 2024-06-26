
class driver;

    mailbox gen2drive;
    virtual uart_intf vif;
    int no_of_tr_dri;
//   	trans t1;


    function new(virtual uart_intf vif, mailbox gen2drive);
        this.vif = vif;
        this.gen2drive = gen2drive;
        no_of_tr_dri = 0;
     
    endfunction //new()

  
  

    task main();
      forever
        begin
            transaction t1;
            gen2drive.get(t1);

          	wait(vif.en_tx);
            vif.data_tx = t1.data_tx;
          repeat(11) begin
            @(negedge vif.clk);
          end
            no_of_tr_dri++;
        end

    endtask

endclass //driver
