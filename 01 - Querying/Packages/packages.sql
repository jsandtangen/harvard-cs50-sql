-- At what type of address did the Lost Letter end up?: Residential
-- At what address did the Lost Letter end up?: 2 Finnigan Street 
SELECT * FROM packages WHERE from_address_id = 432
SELECT * FROM scans WHERE package_id = 384;
SELECT * FROM addresses WHERE id = 854;


-- At what type of address did the Devious Delivery end up?: Residential
-- What were the contents of the Devious Delivery?: Duck debugger
SELECT * FROM packages WHERE from_address_id IS NULL;
SELECT * FROM addresses WHERE id = 50;

-- What are the contents of the Forgotten Gift?: Flowers
-- Who has the Forgotten Gift?: Mikel
SELECT * FROM addresses WHERE address = '109 Tileston Street';
SELECT * FROM packages WHERE from_address_id = 9873;
SELECT * FROM scans WHERE package_id = 9523;
SELECT * FROM drivers WHERE id = 17;