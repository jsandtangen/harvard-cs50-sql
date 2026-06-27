SELECT schools.name, graduation_rates.graduated
FROM graduation_rates
JOIN schools ON graduation_rates.school_id = schools.id
WHERE graduation_rates.graduated = 100;