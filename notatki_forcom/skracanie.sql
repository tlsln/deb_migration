-- 'weryfikacja zajêtoœci poszczególnych tabel posegregowana od najwiêkszej wartoœci, odpalamy na sys'
select DE.owner, DE.tablespace_name, DE.segment_type, DE.Segment_name, DDF.file_name, DDF.file_id, (SUM(DE.Bytes)/1024/1024)SIZE_MB
from dba_extents DE, dba_data_files DDF
where DE.tablespace_name = 'USERS' and
DDF.file_id = DE.file_id
group by DE.owner, DE.tablespace_name, DE.segment_type, DE.segment_name, DDF.file_name, DDF.file_id
order by 7 desc ;

delete from textlog where RowID in (select RowID from textlog where rownum <= 1000);

truncate table market_user.textlogpoz;

truncate table market_user.textlog;

alter table market_user.textlog enable row movement;
alter table market_user.textlog shrink space cascade;
alter table market_user.textlog disable row movement;

alter table picture enable row movement;
alter table picture shrink space cascade;
alter table picture disable row movement;

--wolne miejsce 5 plików bazodanowych, na sys:
select b.tablespace_name, tbs_size SizeMb, a.free_space FreeMb from
(select tablespace_name, round(sum(bytes)/1024/1024 ,2) as free_space
from dba_free_space group by tablespace_name) a,
(select tablespace_name, sum(bytes)/1024/1024 as tbs_size
from dba_data_files group by tablespace_name UNION
select tablespace_name, sum(bytes)/1024/1024 tbs_size
from dba_temp_files group by tablespace_name ) b
where a.tablespace_name(+)=b.tablespace_name;

---Sprawdzenie rozmiaru bazy---------

SELECT
        tablespace_name
        , owner
        , trunc(sum(bytes)/1024/1024) MB
FROM
(
        SELECT segment_name table_name, owner, bytes, tablespace_name
        FROM dba_segments
        WHERE segment_type = 'TABLE'
        UNION ALL
        SELECT i.table_name, i.owner, s.bytes, s.tablespace_name
        FROM dba_indexes i, dba_segments s
        WHERE s.segment_name = i.index_name
        AND   s.owner = i.owner
        AND   s.segment_type = 'INDEX'
        UNION ALL
        SELECT l.table_name, l.owner, s.bytes, s.tablespace_name
        FROM dba_lobs l, dba_segments s
        WHERE s.segment_name = l.segment_name
        AND   s.owner = l.owner
        AND   s.segment_type = 'LOBSEGMENT'
        UNION ALL
        SELECT l.table_name, l.owner, s.bytes, s.tablespace_name
        FROM dba_lobs l, dba_segments s
        WHERE s.segment_name = l.index_name
        AND   s.owner = l.owner
        AND   s.segment_type = 'LOBINDEX'
)
GROUP BY rollup(tablespace_name, owner);

------- Rozmiar tabel

SELECT
   table_name, TRUNC(sum(tabele)/1024/1024) tabele, TRUNC(sum(indeksy)/1024/1024) indeksy
FROM
   (
   SELECT
       segment_name table_name, owner, bytes tabele, 0 indeksy
   FROM dba_segments
   WHERE segment_type = 'TABLE'
   UNION ALL
   SELECT
       i.table_name, i.owner, 0 tabele, s.bytes indeksy
   FROM dba_indexes i, dba_segments s
   WHERE s.segment_name = i.index_name
       AND s.owner = i.owner
       AND s.segment_type = 'INDEX'
   UNION ALL
   SELECT
       l.table_name, l.owner, s.bytes tabele, 0 indeksy
   FROM dba_lobs l, dba_segments s
   WHERE s.segment_name = l.segment_name
       AND s.owner = l.owner
       AND s.segment_type = 'LOBSEGMENT'
   UNION ALL
   SELECT
       l.table_name, l.owner, 0 tabele, s.bytes indeksy
   FROM dba_lobs l, dba_segments s
   WHERE s.segment_name = l.index_name
       AND s.owner = l.owner
       AND s.segment_type = 'LOBINDEX'
   )
WHERE owner in UPPER('MARKET3_USER')
GROUP BY table_name, owner
order by 2 desc;

---------- sprawdzenie kompresji tabel------
SELECT count(*), COMPRESSION FROM all_tables WHERE OWNER ='MARKET3_USER' AND TABLE_NAME NOT LIKE 'ARC%' AND TABLE_NAME NOT LIKE '%TEMP%' GROUP BY COMPRESSION ;

---------- sprawdzenie kompresji indeksów 
SELECT count(*), COMPRESSION FROM ALL_INDEXES WHERE OWNER ='MARKET3_USER' AND TABLE_NAME NOT LIKE 'ARC%' AND TABLE_NAME NOT LIKE '%TEMP%' GROUP BY COMPRESSION ;

---------- ARC i TEMP nie mo¿na w³¹czyæ kompresji----------

SELECT * FROM all_tables WHERE OWNER ='MARKET3_USER' AND COMPRESSION ='DISABLED' ;
