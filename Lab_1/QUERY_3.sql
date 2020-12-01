SELECT MESE, SUM(CHIAMATE) AS TOT_CHIAMATE, RANK() OVER (ORDER BY SUM(CHIAMATE) DESC)
FROM TEMPO T, FATTI F
WHERE f.id_tempo=t.id_tempo AND ANNO=2003
GROUP BY MESE