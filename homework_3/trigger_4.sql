create or replace trigger MinNumChiamate
after update on CELL
declare
TotMax number;
begin
  
    select sum(MaxCalls)
      into TotMax
      from CELL;
     
    if TotMax < 30 then
      
      raise_application_error(-20000, 'Too few MaxCalls');
      
    end if;

end;