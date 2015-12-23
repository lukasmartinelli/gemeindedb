-------------------------------------------
DROP FUNCTION IF EXISTS is_community(str TEXT) CASCADE;
CREATE FUNCTION is_community(str TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN str LIKE '......%';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-------------------------------------------
DROP FUNCTION IF EXISTS extract_community_id(str TEXT) CASCADE;
CREATE FUNCTION extract_community_id(str TEXT)
RETURNS INTEGER AS $$
BEGIN
    RETURN SUBSTRING(str, '\d{4}')::integer;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-------------------------------------------
CREATE OR REPLACE FUNCTION values_by_year(table_name text, column_name text)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY EXECUTE format(
        'SELECT region, 2014 as year, _2014 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2013 as year, _2013 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2012 as year, _2012 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2011 as year, _2011 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2010 as year, _2010 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2009 as year, _2009 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2008 as year, _2008 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2007 as year, _2007 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2006 as year, _2006 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2005 as year, _2005 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2004 as year, _2004 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2003 as year, _2003 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2002 as year, _2002 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2001 as year, _2001 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2000 as year, _2000 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1999 as year, _1999 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1998 as year, _1998 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1997 as year, _1997 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1996 as year, _1996 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1995 as year, _1995 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1994 as year, _1994 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1993 as year, _1993 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1992 as year, _1992 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1991 as year, _1991 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1990 as year, _1990 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1989 as year, _1989 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1988 as year, _1988 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1987 as year, _1987 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1986 as year, _1986 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1985 as year, _1985 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1984 as year, _1984 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1983 as year, _1983 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1982 as year, _1982 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1981 as year, _1981 as %2$s FROM %1$s',
        table_name, column_name);
END;
$$
LANGUAGE plpgsql;

-------------------------------------------
DROP TABLE IF EXISTS public.cantons CASCADE;
CREATE TABLE public.cantons (
    id     integer PRIMARY KEY,
    name    varchar(30) NOT NULL
);

INSERT INTO public.cantons
SELECT regions_id::integer as id, regionsname as name
FROM import.kantone_1997;

-------------------------------------------
DROP TABLE IF EXISTS public.communities CASCADE;
CREATE TABLE public.communities (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    name      varchar(30) NOT NULL
);

INSERT INTO public.communities
SELECT regions_id::integer,
       substring("kantonszugehörigkeit" FROM '\((.*)\)+$')::integer as canton_id,
       regionsname as name
FROM import.politische_gemeinden_2015;

-------------------------------------------
DROP TABLE IF EXISTS public.zipcode CASCADE;
CREATE TABLE public.zipcode (
    community_id integer NOT NULL,
    zip integer NOT NULL,
    PRIMARY KEY (community_id, zip),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.zipcode
SELECT gdenr::integer, plz4::integer as zip
FROM import.postleitzahlen_2015
INNER JOIN public.communities AS c ON c.id = gdenr::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.population_birth_place_switzerland CASCADE;
CREATE TABLE public.population_birth_place_switzerland (
    community_id integer NOT NULL,
    year integer NOT NULL,
    people integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.population_birth_place_switzerland
SELECT c.id as community_id,
       year as year,
       people::integer
FROM values_by_year('import.mittlere_bevoelkerung_schweiz_1981_2014', 'people')
     f(region text, year integer, people text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);

-------------------------------------------
DROP TABLE IF EXISTS public.population_birth_place_abroad CASCADE;
CREATE TABLE public.population_birth_place_abroad (
    community_id integer NOT NULL,
    year integer NOT NULL,
    people integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.population_birth_place_abroad
SELECT c.id as community_id,
       year as year,
       people::integer
FROM values_by_year('import.mittlere_bevoelkerung_ausland_1981_2014', 'people')
     f(region text, year integer, people text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);

-------------------------------------------
DROP TABLE IF EXISTS public.residential_population CASCADE;
CREATE TABLE public.residential_population (
    community_id integer NOT NULL,
    year integer NOT NULL,
    population integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.residential_population
SELECT extract_community_id(region),
       year,
       population::integer
FROM values_by_year('import.mittlere_wohnbevoelkerung_1981_2014', 'population')
     f(region text, year integer, population text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.deaths CASCADE;
CREATE TABLE public.deaths (
    community_id integer NOT NULL,
    year integer NOT NULL,
    deaths integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.deaths
SELECT extract_community_id(region),
       year,
       deaths::integer
FROM values_by_year('import.todesfaelle_1981_2014', 'deaths')
     f(region text, year integer, deaths text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.births CASCADE;
CREATE TABLE public.births (
    community_id integer NOT NULL,
    year integer NOT NULL,
    births integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.births
SELECT extract_community_id(region),
       year,
       births::integer
FROM values_by_year('import.geburt_1981_2014', 'births')
     f(region text, year integer, births text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.immigration CASCADE;
CREATE TABLE public.immigration (
    community_id integer NOT NULL,
    year integer NOT NULL,
    immigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.immigration
SELECT extract_community_id(region),
       year,
       immigration::integer
FROM values_by_year('import.einwanderung_1981_2014', 'immigration')
     f(region text, year integer, immigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.emigration CASCADE;
CREATE TABLE public.emigration (
    community_id integer NOT NULL,
    year integer NOT NULL,
    emigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.emigration
SELECT extract_community_id(region),
       year,
       emigration::integer
FROM values_by_year('import.auswanderung_1981_2014', 'emigration')
     f(region text, year integer, emigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.new_citizenships CASCADE;
CREATE TABLE public.new_citizenships (
    community_id integer NOT NULL,
    year integer NOT NULL,
    citizenships integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.new_citizenships
SELECT extract_community_id(region),
       year,
       citizenships::integer
FROM values_by_year('import.buergerrecht_erwerb_1981_2014', 'citizenships')
     f(region text, year integer, citizenships text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.birth_surplus CASCADE;
CREATE TABLE public.birth_surplus (
    community_id integer NOT NULL,
    year integer NOT NULL,
    surplus integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.birth_surplus
SELECT extract_community_id(region),
       year,
       surplus::integer
FROM values_by_year('import.geburtenueberschuss_1981_2014', 'surplus')
     f(region text, year integer, surplus text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.migration_balance CASCADE;
CREATE TABLE public.migration_balance (
    community_id integer NOT NULL,
    year integer NOT NULL,
    balance integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.migration_balance
SELECT extract_community_id(region),
       year,
       balance::integer
FROM values_by_year('import.wanderungssaldo_1981_2014', 'balance')
     f(region text, year integer, balance text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.immigration_from_other_canton CASCADE;
CREATE TABLE public.immigration_from_other_canton (
    community_id integer NOT NULL,
    year integer NOT NULL,
    immigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.immigration_from_other_canton
SELECT extract_community_id(region),
       year,
       immigration::integer
FROM values_by_year('import.wanderung_interkantonal_zuzug_1981_2014', 'immigration')
     f(region text, year integer, immigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.emigration_from_other_canton CASCADE;
CREATE TABLE public.emigration_from_other_canton (
    community_id integer NOT NULL,
    year integer NOT NULL,
    emigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.emigration_from_other_canton
SELECT extract_community_id(region),
       year,
       emigration::integer
FROM values_by_year('import.wanderung_interkantonal_wegzug_1981_2014', 'emigration')
     f(region text, year integer, emigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.immigration_from_same_canton CASCADE;
CREATE TABLE public.immigration_from_same_canton (
    community_id integer NOT NULL,
    year integer NOT NULL,
    immigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.immigration_from_same_canton
SELECT extract_community_id(region),
       year,
       immigration::integer
FROM values_by_year('import.wanderung_intrakantonal_zuzug_1981_2014', 'immigration')
     f(region text, year integer, immigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.emigration_from_same_canton CASCADE;
CREATE TABLE public.emigration_from_same_canton (
    community_id integer NOT NULL,
    year integer NOT NULL,
    emigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.emigration_from_same_canton
SELECT extract_community_id(region),
       year,
       emigration::integer
FROM values_by_year('import.wanderung_intrakantonal_wegzug_1981_2014', 'emigration')
     f(region text, year integer, emigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.population_end_of_year CASCADE;
CREATE TABLE public.population_end_of_year (
    community_id integer NOT NULL,
    year integer NOT NULL,
    population integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.population_end_of_year
SELECT extract_community_id(region),
       year,
       population::integer
FROM values_by_year('import.bevoelkerung_bestand_1981_2014', 'population')
     f(region text, year integer, population text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.empty_flats CASCADE;
CREATE TABLE public.empty_flats (
    community_id integer NOT NULL,
    year integer NOT NULL,
    rooms text NOT NULL,
    flats integer NOT NULL,
    PRIMARY KEY (community_id, year, rooms),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.empty_flats
SELECT extract_community_id(f15.region),
       2015 as year,
       f15.rooms,
       f15.flats::integer
FROM (
    SELECT region, '1' as rooms, _1_wohnraum as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '2' as rooms, _2_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '3' as rooms, _3_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '4' as rooms, _4_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '5' as rooms, _5_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '6+' as rooms, _6_wohnräume_und_mehr as flats FROM import.leerstehende_wohnungen_2015
) AS f15
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);


-------------------------------------------
DROP TABLE IF EXISTS public.population_age_group CASCADE;
CREATE TABLE public.population_age_group (
    community_id integer NOT NULL,
    year integer NOT NULL,
    sex text NOT NULL,
    population_5_9_years integer NOT NULL,
    population_10_14_years integer NOT NULL,
    population_15_19_years integer NOT NULL,
    population_20_24_years integer NOT NULL,
    population_25_29_years integer NOT NULL,
    population_30_34_years integer NOT NULL,
    population_35_39_years integer NOT NULL,
    population_40_44_years integer NOT NULL,
    population_45_49_years integer NOT NULL,
    population_50_54_years integer NOT NULL,
    population_55_59_years integer NOT NULL,
    population_60_64_years integer NOT NULL,
    population_65_69_years integer NOT NULL,
    population_70_74_years integer NOT NULL,
    population_75_79_years integer NOT NULL,
    population_80_84_years integer NOT NULL,
    population_85_89_years integer NOT NULL,
    population_90_94_years integer NOT NULL,
    population_95_99_years integer NOT NULL,
    population_100_years_or_older integer NOT NULL,
    PRIMARY KEY (community_id, year, sex),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.population_age_group
SELECT extract_community_id(region),
       2014 as year,
       'male' as sex,
        _5_9_years::integer AS population_5_9_years,
        _10_14_years::integer AS population_10_14_years,
        _15_19_years::integer AS population_15_19_years,
        _20_24_years::integer AS population_20_24_years,
        _25_29_years::integer AS population_25_29_years,
        _30_34_years::integer AS population_30_34_years,
        _35_39_years::integer AS population_35_39_years,
        _40_44_years::integer AS population_40_44_years,
        _45_49_years::integer AS population_45_49_years,
        _50_54_years::integer AS population_50_54_years,
        _55_59_years::integer AS population_55_59_years,
        _60_64_years::integer AS population_60_64_years,
        _65_69_years::integer AS population_65_69_years,
        _70_74_years::integer AS population_70_74_years,
        _75_79_years::integer AS population_75_79_years,
        _80_84_years::integer AS population_80_84_years,
        _85_89_years::integer AS population_85_89_years,
        _90_94_years::integer AS population_90_94_years,
        _95_99_years::integer AS population_95_99_years,
        _100_years_or_older::integer AS population_100_years_or_older
FROM import.staendinge_bevoelkerung_alter_maennlich_2014
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

INSERT INTO public.population_age_group
SELECT extract_community_id(region),
       2014 as year,
       'female' as sex,
        _5_9_years::integer AS population_5_9_years,
        _10_14_years::integer AS population_10_14_years,
        _15_19_years::integer AS population_15_19_years,
        _20_24_years::integer AS population_20_24_years,
        _25_29_years::integer AS population_25_29_years,
        _30_34_years::integer AS population_30_34_years,
        _35_39_years::integer AS population_35_39_years,
        _40_44_years::integer AS population_40_44_years,
        _45_49_years::integer AS population_45_49_years,
        _50_54_years::integer AS population_50_54_years,
        _55_59_years::integer AS population_55_59_years,
        _60_64_years::integer AS population_60_64_years,
        _65_69_years::integer AS population_65_69_years,
        _70_74_years::integer AS population_70_74_years,
        _75_79_years::integer AS population_75_79_years,
        _80_84_years::integer AS population_80_84_years,
        _85_89_years::integer AS population_85_89_years,
        _90_94_years::integer AS population_90_94_years,
        _95_99_years::integer AS population_95_99_years,
        _100_years_or_older::integer AS population_100_years_or_older
FROM import.staendinge_bevoelkerung_alter_weiblich_2014
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.cinemas CASCADE;
CREATE TABLE public.cinemas (
    community_id integer NOT NULL,
    year integer NOT NULL,
    cinemas integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.cinemas
SELECT regions_id::integer as community_id,
        2014 as year,
        anzahl_kinos::integer as cinemas
FROM import.kinos_2014
INNER JOIN public.communities AS c ON c.id = regions_id::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.commute_distance CASCADE;
CREATE TABLE public.commute_distance (
    community_id integer NOT NULL,
    year integer NOT NULL,
    distance_km decimal NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.commute_distance
SELECT regions_id::integer as community_id,
       2012 as year,
       durchschnittliche_länge_des_arbeitswegs_in_km::decimal as distance_km
FROM import.laenge_arbeitsweg_2010_2012
INNER JOIN public.communities AS c ON c.id = regions_id::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.housing_estate_share CASCADE;
CREATE TABLE public.housing_estate_share (
    community_id integer NOT NULL,
    year integer NOT NULL,
    share decimal NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.housing_estate_share
SELECT regions_id::integer as community_id,
       2004 as year,
       anteil_der_siedlungsflächen_an_der_gesamtfläche_in_::decimal as share
FROM import.anteil_siedlungsflaeche_2004
INNER JOIN public.communities AS c ON c.id = regions_id::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.commuter_balance CASCADE;
CREATE TABLE public.commuter_balance (
    community_id integer NOT NULL,
    year integer NOT NULL,
    commuters integer NOT NULL,
    balance_per_100_workers decimal NOT NULL,
    PRIMARY KEY (community_id),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.commuter_balance
SELECT regions_id::integer as community_id,
       2000 as year,
       pendlersaldo_in_personen::integer as commuters,
       bilanz_der_zu__und_wegpendler_pro_100_erwerbstätige_sowie_sch::decimal as balance_per_100_workers
FROM import.pendlersaldo_2000
INNER JOIN public.communities AS c ON c.id = regions_id::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.language_areas CASCADE;
CREATE TABLE public.language_areas (
    community_id integer NOT NULL,
    year integer NOT NULL,
    language text NOT NULL,
    PRIMARY KEY (community_id),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.language_areas
SELECT regions_id::integer as community_id,
        2000 AS year,
       Sprachgebiete as language
FROM import.sprachgebiete_2000
INNER JOIN public.communities AS c ON c.id = regions_id::integer;

-------------------------------------------
CREATE OR REPLACE VIEW public.communities_detail AS (
    SELECT
        c.id AS community_id,
        c.name AS name,
        (
            SELECT array_to_json(array_agg(bi)) FROM (
                SELECT year, births FROM public.births
                WHERE community_id = c.id
            ) AS bi
        ) AS births,
        (
            SELECT array_to_json(array_agg(de)) FROM (
                SELECT year, deaths FROM public.deaths
                WHERE community_id = c.id
            ) AS de
        ) AS deaths,
        (
            SELECT array_to_json(array_agg(re)) FROM (
                SELECT year, population FROM public.residential_population
                WHERE community_id = c.id
            ) AS re
        ) AS residential_population,
        (
            SELECT array_to_json(array_agg(la)) FROM (
                SELECT year, language FROM public.language_areas
                WHERE community_id = c.id
            ) AS la
        ) AS language_areas,
        (
            SELECT array_to_json(array_agg(ho)) FROM (
                SELECT year, share FROM public.housing_estate_share
                WHERE community_id = c.id
            ) AS ho
        ) AS housing_estate_share,
        (
            SELECT array_to_json(array_agg(co)) FROM (
                SELECT year, commuters, balance_per_100_workers FROM public.commuter_balance
                WHERE community_id = c.id
            ) AS co
        ) AS commuter_balance,
        (
            SELECT array_to_json(array_agg(ci)) FROM (
                SELECT year, cinemas FROM public.cinemas
                WHERE community_id = c.id
            ) AS ci
        ) AS cinemas,
        (
            SELECT array_to_json(array_agg(pag)) FROM (
                SELECT * FROM public.population_age_group
                WHERE community_id = c.id
            ) AS pag
        ) AS population_by_age_groups,
        (
            SELECT array_to_json(array_agg(im)) FROM (
                SELECT year, immigration FROM public.immigration
                WHERE community_id = c.id
            ) AS im
        ) AS immigration,
        (
            SELECT array_to_json(array_agg(em)) FROM (
                SELECT year, emigration FROM public.emigration
                WHERE community_id = c.id
            ) AS em
        ) AS emigration,
        (
            SELECT array_to_json(array_agg(im)) FROM (
                SELECT year, immigration FROM public.immigration_from_same_canton
                WHERE community_id = c.id
            ) AS im
        ) AS immigration_from_same_canton,
        (
            SELECT array_to_json(array_agg(im)) FROM (
                SELECT year, immigration FROM public.immigration_from_other_canton
                WHERE community_id = c.id
            ) AS im
        ) AS immigration_from_other_canton,
        (
            SELECT array_to_json(array_agg(em)) FROM (
                SELECT year, emigration FROM public.emigration_from_same_canton
                WHERE community_id = c.id
            ) AS em
        ) AS emigration_from_same_canton,
        (
            SELECT array_to_json(array_agg(em)) FROM (
                SELECT year, emigration FROM public.emigration_from_other_canton
                WHERE community_id = c.id
            ) AS em
        ) AS emigration_from_other_canton,
        (
            SELECT array_to_json(array_agg(bs)) FROM (
                SELECT year, surplus FROM public.birth_surplus
                WHERE community_id = c.id
            ) AS bs
        ) AS birth_surplus,
        (
            SELECT array_to_json(array_agg(mb)) FROM (
                SELECT year, balance FROM public.migration_balance
                WHERE community_id = c.id
            ) AS mb
        ) AS migration_balance,
        (
            SELECT array_to_json(array_agg(cs)) FROM (
                SELECT year, citizenships FROM public.new_citizenships
                WHERE community_id = c.id
            ) AS cs
        ) AS new_citizenships,
        (
            SELECT array_to_json(array_agg(cd)) FROM (
                SELECT year, distance_km FROM public.commute_distance
                WHERE community_id = c.id
            ) AS cd
        ) AS commute_distance,
        (
            SELECT array_to_json(array_agg(bp)) FROM (
                SELECT year, people FROM public.population_birth_place_switzerland
                WHERE community_id = c.id
            ) AS bp
        ) AS population_birth_place_switzerland,
        (
            SELECT array_to_json(array_agg(bp)) FROM (
                SELECT year, people FROM public.population_birth_place_abroad
                WHERE community_id = c.id
            ) AS bp
        ) AS population_birth_place_abroad
    FROM public.communities AS c
);

