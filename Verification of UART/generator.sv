class generator;
  
 rand transaction tr;
 mailbox gen2drive;
 int no_of_tr;
  
   event _end;
   
    function new(mailbox gen2drive);
        this.gen2drive = gen2drive;
    endfunction

    task main();
        repeat(no_of_tr) begin
            tr = new();
            tr.randomize();
            gen2drive.put(tr);
        end
      -> _end;
    endtask
  
endclass
