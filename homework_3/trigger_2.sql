create or replace trigger Chiamata
after insert on STATE_CHANGE
for each row
when (NEW.ChangeType='C')
declare
Cell number;
x_0 number;
y_0 number;
x_1 number;
y_1 number;
NumChiamate number;
MaxChiamate number;
Cont number;
begin
  
   select CellId, x0, y0, x1, y1, MaxCalls
    into Cell, x_0, y_0, x_1, y_1, MaxChiamate
    from CELL
    where :NEW.x >= x0 and :NEW.x < x1 and :NEW.y >= y0 and :NEW.y < y1;

    select COUNT(*)
      into NumChiamate
      from TELEPHONE
     where PhoneState='ACTIVE' and x >= x_0 and x < x_1 and y >= y_0 and y < y_1;

     if NumChiamate is NULL then
       NumChiamate=0;
     end if;

     if NumChiamate+1 > MaxChiamate then

        select MAX(ExId)
          into Cont
          from EXCEPTION_LOG
          where CellId=Cell;

        if Cont is NULL then
            Cont = 1;
        end if;
         
         insert into EXCEPTION_LOG (ExId, CellId, ExceptionType)
         values (Cont+1, Cell, 'E');

    else

        update TELEPHONE
           set PhoneState='ACTIVE'
         where PhoneNo=:NEW.PhoneNo;
         
     end if;
end;