-- AWR-based segment space trend report
--
-- Example:
--   define p_owner = 'SCOTT'
--   define p_object_name = 'EMP'
--   define p_subobject_name = ''
--   define p_days_back = '7'
--   @C:\Users\cloudmedia\Desktop\Oracle\scripts\segment_space_trend_awr.sql

set pagesize 200
set linesize 240
set trimspool on
set verify off

column begin_time format a19
column end_time format a19
column owner format a20
column object_name format a30
column subobject_name format a30
column object_type format a18
column tablespace_name format a20
column used_mb format 999,999,999,990.00
column used_delta_mb format 999,999,999,990.00
column allocated_mb format 999,999,999,990.00
column allocated_delta_mb format 999,999,999,990.00

prompt
prompt Segment space trend from AWR
prompt owner=&&p_owner object=&&p_object_name subobject=&&p_subobject_name days_back=&&p_days_back
prompt

select to_char(sn.begin_interval_time, 'yyyy-mm-dd hh24:mi:ss') as begin_time,
       to_char(sn.end_interval_time,   'yyyy-mm-dd hh24:mi:ss') as end_time,
       so.owner,
       so.object_name,
       nvl(so.subobject_name, '-') as subobject_name,
       so.object_type,
       so.tablespace_name,
       round(ss.space_used_total / 1024 / 1024, 2) as used_mb,
       round(ss.space_used_delta / 1024 / 1024, 2) as used_delta_mb,
       round(ss.space_allocated_total / 1024 / 1024, 2) as allocated_mb,
       round(ss.space_allocated_delta / 1024 / 1024, 2) as allocated_delta_mb,
       ss.logical_reads_delta,
       ss.physical_reads_delta,
       ss.physical_writes_delta,
       ss.db_block_changes_delta
from   dba_hist_seg_stat ss
join   dba_hist_seg_stat_obj so
       on so.dbid = ss.dbid
      and so.ts# = ss.ts#
      and so.obj# = ss.obj#
      and so.dataobj# = ss.dataobj#
      and nvl(so.con_id, 0) = nvl(ss.con_id, 0)
join   dba_hist_snapshot sn
       on sn.snap_id = ss.snap_id
      and sn.dbid = ss.dbid
      and sn.instance_number = ss.instance_number
where  so.owner = upper(trim('&&p_owner'))
  and  so.object_name = upper(trim('&&p_object_name'))
  and  (
           trim('&&p_subobject_name') is null
        or upper(nvl(so.subobject_name, '-')) = upper(trim('&&p_subobject_name'))
       )
  and  sn.begin_interval_time >= systimestamp - numtodsinterval(to_number('&&p_days_back'), 'DAY')
order  by sn.begin_interval_time;
