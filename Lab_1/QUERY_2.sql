SELECT MESE, SUM(PREZZO) AS TOT_PREZZO, SUM(CHIAMATE) AS TOT_CHIAMATE, RANK() OVER (ORDER BY SUM(PREZZO) DESC) AS RANK
FROM TEMPO T, FATTI F
WHERE f.id_tempo=t.id_tempo
GROUP BY MESE