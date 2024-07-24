                                                                                                                                                                                          SELECT event_name
      ,count_star
      ,SUM_TIMER_WAIT/1000000000000 AS sum_timer_wait
      ,AVG_TIMER_WAIT/1000000000000 AS avg_timer_wait
      ,MAX_TIMER_WAIT/1000000000000 AS max_timer_wait
FROM performance_schema.events_waits_summary_global_by_event_name
ORDER BY AVG_TIMER_WAIT DESC LIMIT 10; 
