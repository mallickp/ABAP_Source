DATA: wa_collectoraction TYPE zcollectoraction,
  it_collectoraction LIKE STANDARD TABLE OF zcollectoraction.

SELECT bukrs kunnr yearmonth MAX( dat ) AS dat
FROM zcollectoraction
  INTO CORRESPONDING FIELDS OF TABLE it_collectoraction
WHERE bukrs IN so_bukrs AND
      kunnr IN so_kunnr AND
      dat   IN so_date
GROUP BY bukrs kunnr yearmonth.

LOOP AT it_collectoraction INTO wa_collectoraction.
PERFORM progress_bar USING 'Retrieving data...'(035)
                           sy-tabix
                           i_tab_lines.
"Get the MAX TIME for all lines in order to cover the case we have more than 1 line."
SELECT SINGLE * FROM zcollectoraction
    INTO CORRESPONDING FIELDS OF wa_collectoraction
  WHERE bukrs = wa_collectoraction-bukrs AND
        kunnr = wa_collectoraction-kunnr AND
        dat   = wa_collectoraction-dat   AND
        time  = ( SELECT MAX( time ) AS time
                    FROM zcollectoraction
                    WHERE bukrs = wa_collectoraction-bukrs AND
                          kunnr = wa_collectoraction-kunnr AND
                          dat   = wa_collectoraction-dat ).
MODIFY it_collectoraction FROM wa_collectoraction.
ENDLOOP.
