/*
Rossman skracanie bazy w przypadku przerosu 12G, zapytania podesłane przez Damiana
*/

delete MARKET3_USER.receiptinfo ri where ri.RECEIPTID < (select max(receiptid) from MARKET3_USER.receipt r where r.RECEIPTDATE < sysdate - 720); 
delete  from market3_user.CASHIERSHIFTOPERATIONALLOG  where operationtime < sysdate - 720;
delete from CASHREGISTERSERVER.receiptsprocessed;

truncate table CASHREGISTERSERVER.CASHIERSHIFTOPERATIONALLOG drop storage;
truncate table market3_user.receiptrawdata drop storage;

alter table "MARKET3_USER"."RECEIPTINFO" enable row movement; 
alter table "MARKET3_USER"."RECEIPTINFO" shrink space COMPACT; 
alter table "MARKET3_USER"."RECEIPTINFO" shrink space; 
alter table "MARKET3_USER"."RECEIPTINFO" disable row movement; 

alter index "MARKET3_USER"."RECEIPTINFO_IX_RECEIPTID" enable row movement;
alter index "MARKET3_USER"."RECEIPTINFO_IX_RECEIPTID" shrink space COMPACT; 
alter index "MARKET3_USER"."RECEIPTINFO_IX_RECEIPTID" shrink space;
alter index "MARKET3_USER"."RECEIPTINFO_IX_RECEIPTID" disable row movement; 

alter index "MARKET3_USER"."RECEIPTINFO_PK_ID" enable row movement;
alter index "MARKET3_USER"."RECEIPTINFO_PK_ID" shrink space COMPACT; 
alter index "MARKET3_USER"."RECEIPTINFO_PK_ID" shrink space; 
alter index "MARKET3_USER"."RECEIPTINFO_PK_ID" disable row movement;

alter table "MARKET3_USER"."CASHIERSHIFTOPERATIONALLOG" enable row movement; 
alter table "MARKET3_USER"."CASHIERSHIFTOPERATIONALLOG" shrink space COMPACT; 
alter table "MARKET3_USER"."CASHIERSHIFTOPERATIONALLOG" shrink space; 
alter table "MARKET3_USER"."CASHIERSHIFTOPERATIONALLOG" disable row movement; 
 
alter table CASHREGISTERSERVER.receiptsprocessed enable row movement; 
alter table CASHREGISTERSERVER.receiptsprocessed shrink space COMPACT; 
alter table CASHREGISTERSERVER.receiptsprocessed shrink space; 
alter table CASHREGISTERSERVER.receiptsprocessed disable row movement; 

alter table CASHREGISTERSERVER.CASHIERSHIFTOPERATIONALLOG enable row movement; 
alter table CASHREGISTERSERVER.CASHIERSHIFTOPERATIONALLOG shrink space COMPACT; 
alter table CASHREGISTERSERVER.CASHIERSHIFTOPERATIONALLOG shrink space; 
alter table CASHREGISTERSERVER.CASHIERSHIFTOPERATIONALLOG disable row movement; 

alter table "MARKET3_USER"."RECEIPTRAWDATA" enable row movement; 
alter table "MARKET3_USER"."RECEIPTRAWDATA" shrink space COMPACT; 
alter table "MARKET3_USER"."RECEIPTRAWDATA" shrink space; 
alter table "MARKET3_USER"."RECEIPTRAWDATA" disable row movement; 