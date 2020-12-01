create or replace NONEDITIONABLE trigger UpdateJob
after update of JOB or insert on IMP
for each row
begin
        UPDATE SUMMARY
        SET NUM=NUM+1
        WHERE JOB=:NEW.JOB;

        UPDATE SUMMARY
        SET NUM=NUM-1
        WHERE JOB=:OLD.JOB;
 
end;