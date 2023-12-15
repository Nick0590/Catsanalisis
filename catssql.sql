DROP TEMPORARY TABLE IF EXISTS cats_temp;

CREATE TEMPORARY TABLE cats_temp AS
SELECT animal_id, prey_p_month, animal_sex
   FROM cats_uk_reference;


/* Presas por sexo */
SELECT animal_sex, AVG(prey_p_month) as avg_prey_per_month
   FROM cats_temp
GROUP BY animal_sex;


/* Join por subconjuntos */
DROP TEMPORARY TABLE IF EXISTS temp_hunting_data;

CREATE TEMPORARY TABLE temp_hunting_data AS
   SELECT animal_id, prey_p_month
   FROM cats_uk_reference;
   
DROP TEMPORARY TABLE IF EXISTS temp_indoor_data;

CREATE TEMPORARY TABLE temp_indoor_data AS
SELECT animal_id, hrs_indoors
   FROM cats_uk_reference;

SELECT thd.animal_id, thd.prey_p_month, tid.hrs_indoors
   FROM temp_hunting_data thd
JOIN temp_indoor_data tid ON thd.animal_id = tid.animal_id;


/* Caza según animal */
SELECT animal_id,
       prey_p_month,
       AVG(prey_p_month) OVER (PARTITION BY animal_sex) as avg_prey_by_sex
   FROM cats_uk_reference;
