#!/bin/bash


cat <<EOM
SELECT
	pid,
	age(clock_timestamp(), query_start),
	usename as username,
	query
FROM pg_stat_activity
WHERE
	query != '<IDLE>'
	AND query NOT ILIKE '%pg_stat_activity%'
ORDER BY query_start desc;

EOM
