create or replace trigger ChangeMaxCalls
before update on CELL
for each row
declare
TellAttivi number;
begin
  
select count(*)
    into TellAttivi
    from TELEPHONE
   where x >= :NEW.x0 and x < :NEW.x1 and y >= :NEW.y0 and y < :NEW.y1 and PhoneState='ACTIVE';

   if TellAttivi is NULL then
     TellAttivi:=0;
   end if;

if TellAttivi > :NEW.MaxCalls then
    
    :NEW.MaxCalls := TellAttivi;

end if;

end;