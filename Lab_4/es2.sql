CREATE OR REPLACE TRIGGER InerimentoBiglietto
AFTER INSERT ON TICKETS
FOR EACH ROW
WHEN (NEW.CARDNO IS NOT NULL)
DECLARE
    miglia number;
    migliaTot NUMBER;
    status varchar(10);
    flag number := 0;
    notifyNo number;
    newStatus varchar(10);
begin
  --passo 1
  select MILES
    into miglia
    from FLIGHTS
   where FLIGHTID=:NEW.FLIGHTID;

  insert into CREDITS (TICKETID, CARDNO, MILES)
  values (:NEW.TICKETID, :NEW.CARDNO, miglia);

  --passo 2
  select SUM(MILES)
    into migliaTot
    from CREDITS
   where CARDNO=:NEW.CARDNO;

   select STATUS
     into status
     from CARDS
    where CARDNO=:NEW.CARDNO;

   if status = 'SILVER' then
     if migliaTot > 30000 and migliaTot < 50000 then
       update CARDS
          set STATUS='GOLD'
        where CARDNO=:NEW.CARDNO;
        flag := 1;
        newStatus:='GOLD';
     else 
        if migliaTot > 50000 then
        update CARDS
            set STATUS='PREMIUM'
            where CARDNO=:NEW.CARDNO;
            flag := 1;
            newStatus:='PREMIUM';
        end if;
     end if;
   else 
    if status = 'GOLD' then
        if migliaTot > 50000 then
            update CARDS
                set STATUS='PREMIUM'
                where CARDNO=:NEW.CARDNO;
                flag := 1;
                newStatus:='PREMIUM';
        end if;
    end if; 
   end if;

   --passo 3
   if flag = 1 then
     
     select MAX(NOTIFYNO)
       into notifyNo
       from NOTIFY
    where CARDNO=:NEW.CARDNO;

    if notifyNo is not null then
        notifyNo := notifyNo + 1;
    else
        notifyNo := 1;
    end if;

    insert into NOTIFY (CARDNO, NOTIFYNO, NOTIFYDATE, OLDSTATUS, NEWSTATUS, TOTALMILES)
    values (:NEW.CARDNO, notifyNo, SYSDATE, status, newStatus, migliaTot);

   end if; 

end;