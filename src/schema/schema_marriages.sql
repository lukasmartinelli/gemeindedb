-------------------------------------------
DROP TABLE IF EXISTS public.marriages CASCADE;
DROP TYPE IF EXISTS marriage_origin CASCADE;
CREATE TYPE marriage_origin AS ENUM ('Switzerland', 'Foreign country');

CREATE TABLE public.marriages (
    community_id integer NOT NULL,
    year integer NOT NULL,
    origin_man marriage_origin NOT NULL,
    origin_woman marriage_origin NOT NULL,
    marriages integer NOT NULL,
    PRIMARY KEY (community_id, year, origin_man, origin_woman),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.marriages
SELECT c.id as community_id,
       year,
       nationalität_mann::marriage_origin as origin_man,
       nationalität_frau::marriage_origin as origin_woman,
       marriages::integer
FROM values_by_year_1984_2014('import.marriages_1969_2014', 'marriages', 'region, nationalität_mann, nationalität_frau')
     f(region text, nationalität_mann text, nationalität_frau text, year integer, marriages text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);

-------------------------------------------
DROP TABLE IF EXISTS public.divorces CASCADE;
DROP TYPE IF EXISTS marriage_duration;
CREATE TYPE marriage_duration AS ENUM (
    '0-4 years', '5-9 years', '10-14 years',
    '15-19 years', '20 years or more'
);

CREATE TABLE public.divorces (
    community_id integer NOT NULL,
    year integer NOT NULL,
    duration marriage_duration NOT NULL,
    origin_man marriage_origin NOT NULL,
    origin_woman marriage_origin NOT NULL,
    divorces integer NOT NULL,
    PRIMARY KEY (community_id, year, duration, origin_man, origin_woman),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.divorces
SELECT c.id as community_id,
       year,
       dauer::marriage_duration as duration,
       nationalität_mann::marriage_origin as origin_man,
       nationalität_frau::marriage_origin origin_woman,
       divorces::integer
FROM values_by_year_1984_2014('import.scheidungen_1969_2014', 'divorces', 'region, dauer, nationalität_mann, nationalität_frau')
     f(region text, dauer text, nationalität_mann text, nationalität_frau text, year integer, divorces text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);
