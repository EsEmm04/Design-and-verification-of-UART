`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
  
virtual uart_intf vif;
mailbox gen2drive;
mailbox mon2scb;
  
function new(virtual uart_intf vif);
    this.vif = vif;
//     this.gen2drive = gen2drive;
  gen2drive=new();
  mon2scb=new();
    drv = new(vif, gen2drive);
    gen = new(gen2drive);
  mon=new(vif,mon2scb);
  scb=new(mon2scb,gen.no_of_tr);
endfunction


task test;
    fork
      	gen.main();
        drv.main();
      mon.main();
      scb.main();
    join_any
endtask

  task post_test();
    wait(gen.no_of_tr==scb.count);
          if(scb.flag) $display("<<<<<<<<<<<<<<<<<<<[Result]:: Passed>>>>>>>>>>>>>>>");
      else $display("<<<<<<<<<<<<<<<<<<<<<<<<<[Result]:: Failed>>>>>>>>>>>>>>>>>>>>>>>>>");
  endtask


task run;
    test();
  post_test();
  	$finish;
endtask

endclass
