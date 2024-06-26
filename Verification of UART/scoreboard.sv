class scoreboard;

    mailbox mon2scb;
    int count;
  	int flag;
  	int test_count;

  function new(mailbox mon2scb,int test_count);
        this.mon2scb = mon2scb;
    	this.test_count=test_count;
        count=0;
      	flag=0;
    endfunction

    task main;
        transaction tr;
        forever begin
            mon2scb.get(tr);
            count++;
          if (tr.data_tx==tr.data_rx) begin
            $display("[Test: %0d/%0d] Correct",count,test_count);
            tr.display("SCB");
              flag=1;
            end
            else begin
              $display("[Test: %0d/%0d] Incorrect",count,test_count);
              flag=0;
              tr.display("SCB");
            end
        end
    endtask
endclass
