-- Istatistikler ne zamandan beri toplaniyor
SELECT
    datname,
    stats_reset,
    now() - stats_reset AS observation_period
FROM pg_stat_database
WHERE datname = current_database();

-- Bir tablonun index kullanımı
SELECT
    s.schemaname,
    s.relname AS table_name,
    s.indexrelname AS index_name,

    pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,

    s.idx_scan,
    s.idx_tup_read,
    s.idx_tup_fetch,

    CASE
        WHEN s.idx_scan = 0 THEN 'KULLANILMAMIS'
        WHEN s.idx_scan < 10 THEN 'COK AZ KULLANILMIS'
        WHEN s.idx_scan < 100 THEN 'AZ KULLANILMIS'
        ELSE 'KULLANILIYOR'
    END AS usage_status

FROM pg_stat_user_indexes s
WHERE s.schemaname = 'usermng'
  AND s.relname = 'user_info_log'
  -- AND s.indexrelname IN (
  --       'index_1',
  --       'index_2'
  -- )
ORDER BY s.idx_scan DESC;

-- İkinci olarak indexlerin yapısını karşılaştıralım. İki index birbirinin tekrarı veya kapsayan versiyonu olabilir:

SELECT
    ui.schemaname,
    ui.relname AS table_name,
    ui.indexrelname AS index_name,

    pg_size_pretty(pg_relation_size(ui.indexrelid)) AS index_size,

    ui.idx_scan,
    ui.idx_tup_read,
    ui.idx_tup_fetch,

    sio.idx_blks_read,
    sio.idx_blks_hit,

    i.indisunique,
    i.indisprimary,
    i.indisvalid,
    i.indisready,

    pg_get_indexdef(ui.indexrelid) AS index_definition

FROM pg_stat_user_indexes ui

JOIN pg_index i
    ON i.indexrelid = ui.indexrelid

LEFT JOIN pg_statio_user_indexes sio
    ON sio.indexrelid = ui.indexrelid

WHERE ui.schemaname = 'SCHEMA_NAME'
  AND ui.relname = 'TABLE_NAME'
  AND ui.indexrelname IN (
      'INDEX_1',
      'INDEX_2',
		  'INDEX_3'
  )

ORDER BY ui.idx_scan DESC;


--------

#  Execution Plan

-- Execution Plani gör
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT
    id,
    rev,
    user_name,
    last_login_date,
    previous_login_date,
    days_since_last_login
FROM TABLE_NAME
WHERE id > 20658164
  AND id <= 20659164
LIMIT 1000;
