create or replace trigger OnOffTelefono
after insert on STATE_CHANGE
for each row
when (NEW.ChangeType='O' or NEW.ChangeType='F')
declare
Cell number;

begin

    select CellId
        into Cell
        from CELL
       where :NEW.x >= x0 and :NEW.x < x1 and :NEW.y >= y0 and :NEW.y < y1;

    if :NEW.ChangeType='O'  then

       insert into TELEPHONE (PhoneNo, x, y, PhoneState)
       values (:NEW.PhoneNo, :NEW.x, :NEW.y, 'On');

       update CELL
          set CurrentPhone#=CurrentPhone#+1
        where CellId=Cell;

    else 

        delete from TELEPHONE
         where PhoneNo=:NEW.PhoneNo;

         update CELL
            set CurrentPhone#=CurrentPhone#-1
          where CellId=Cell;
      
    end if;
end;