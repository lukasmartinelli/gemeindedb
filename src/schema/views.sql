-------------------------------------------
CREATE OR REPLACE VIEW public.communities_search AS (
    SELECT c.id, c.name AS name, z.zip
    FROM public.communities AS c
    INNER JOIN public.zipcode AS z ON z.community_id = c.id
);
-------------------------------------------
CREATE OR REPLACE VIEW public.communities_detail AS (
    SELECT
        c.id AS community_id,
        c.name AS name,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, births FROM public.births
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS births,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, deaths FROM public.deaths
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS deaths,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, population FROM public.residential_population
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS residential_population,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, language FROM public.language_areas
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS language_areas,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, share FROM public.housing_estate_share
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS housing_estate_share,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, commuters, balance_per_100_workers FROM public.commuter_balance
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS commuter_balance,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, cinemas FROM public.cinemas
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS cinemas,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT * FROM public.population_age_group
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS population_by_age_groups,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, immigration FROM public.immigration
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS immigration,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, emigration FROM public.emigration
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS emigration,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, immigration FROM public.immigration_from_same_canton
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS immigration_from_same_canton,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, immigration FROM public.immigration_from_other_canton
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS immigration_from_other_canton,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, emigration FROM public.emigration_from_same_canton
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS emigration_from_same_canton,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, emigration FROM public.emigration_from_other_canton
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS emigration_from_other_canton,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, surplus FROM public.birth_surplus
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS birth_surplus,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, balance FROM public.migration_balance
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS migration_balance,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, citizenships FROM public.new_citizenships
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS new_citizenships,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, distance_km FROM public.commute_distance
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS commute_distance,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, people FROM public.population_birth_place_switzerland
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS population_birth_place_switzerland,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, people FROM public.population_birth_place_abroad
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS population_birth_place_abroad,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, sector, workplaces, workers FROM public.workplaces_by_sector
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS workplaces_by_sector,
        (
            SELECT array_to_json(array_agg(t)) FROM (
                SELECT year, workplace_size, workplaces, workers FROM public.workplaces_by_size
                WHERE community_id = c.id
                ORDER BY year ASC
            ) AS t
        ) AS workplaces_by_size
    FROM public.communities AS c
);
