SELECT city, COUNT(*) AS num_schools
FROM schools
WHERE type = 'Public School'
GROUP BY city
HAVING COUNT(*) <= 3
ORDER BY num_schools DESC;