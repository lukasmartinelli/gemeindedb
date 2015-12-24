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
