-------------------------------------------
DROP TABLE IF EXISTS public.cantons CASCADE;
CREATE TABLE public.cantons (
    id     integer PRIMARY KEY,
    name    varchar(30) NOT NULL
);

INSERT INTO public.cantons
SELECT regions_id::integer as id, regionsname as name
FROM import._134_die_26_kantone_der_schweiz_de;

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
FROM import._18838_die_2324_gemeinden_der_schweiz_am_1_1_2015_de;

-------------------------------------------
DROP TABLE IF EXISTS public.population CASCADE;
CREATE TABLE public.population (
    community_id integer PRIMARY KEY,
    population_2012 integer NOT NULL, --the latest population count is required
    population_2011 integer,
    population_2010 integer,
    population_2009 integer,
    population_2008 integer,
    population_2007 integer,
    population_2000 integer,
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.population
SELECT c.id as community_id,
       p2012.einwohnerzahl_am_jahresende::integer as population_2012,
       p2011.einwohnerzahl_am_jahresende::integer as population_2011,
       p2010.einwohnerzahl_am_jahresende::integer as population_2010,
       p2009.einwohnerzahl_am_jahresende::integer as population_2009,
       p2008.einwohnerzahl_am_jahresende::integer as population_2008,
       p2007.einwohnerzahl_am_jahresende::integer as population_2007,
       p2000.einwohnerzahl_am_jahresende::integer as population_2000
FROM public.communities AS c
INNER JOIN import._15934_staendige_wohnbevoelkerung_2012_de AS p2012
     ON c.id = p2012.regions_id::integer
LEFT JOIN import._15161_staendige_wohnbevoelkerung_2011_de AS p2011
     ON c.id = p2011.regions_id::integer
LEFT JOIN import._10621_staendige_wohnbevoelkerung_2010_de AS p2010
     ON c.id = p2010.regions_id::integer
LEFT JOIN import._7061_staendige_wohnbevoelkerung_2009_de AS p2009
     ON c.id = p2009.regions_id::integer
LEFT JOIN import._2877_staendige_wohnbevoelkerung_2008_de AS p2008
     ON c.id = p2008.regions_id::integer
LEFT JOIN import._11_staendige_wohnbevoelkerung_2007_de AS p2007
     ON c.id = p2007.regions_id::integer
LEFT JOIN import._12_staendige_wohnbevoelkerung_2000_de AS p2000
     ON c.id = p2000.regions_id::integer;
-------------------------------------------
DROP TABLE IF EXISTS public.tax_burden_single_80k CASCADE;
CREATE TABLE public.tax_burden_single_80k (
    community_id integer PRIMARY KEY,
    burden_2013 decimal,
    burden_2012 decimal,
    burden_2011 decimal,
    burden_2010 decimal,
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.tax_burden_single_80k
SELECT c.id as community_id,
    s80k_2013.anteil_der_steuerbelastung_am_bruttoarbeitseinkommen_in_::decimal AS burden_80k_2013,
    s80k_2012.anteil_der_steuerbelastung_am_bruttoarbeitseinkommen_in_::decimal AS burden_80k_2012,
    s80k_2010.anteil_der_steuerbelastung_am_bruttoarbeitseinkommen_in_::decimal AS burden_80k_2010
FROM public.communities AS c
LEFT JOIN import._17730_steuerbelastung_von_ledigen_bruttoeinkommen_von_80_000_franken_2013_de AS s80k_2013
     ON c.id = s80k_2013.regions_id::integer
LEFT JOIN import._16334_steuerbelastung_von_ledigen_bruttoeinkommen_von_80_000_franken_2012_de AS s80k_2012
     ON c.id = s80k_2012.regions_id::integer
LEFT JOIN import._15546_steuerbelastung_von_ledigen_bruttoeinkommen_von_80_000_franken_2010_de AS s80k_2010
     ON c.id = s80k_2010.regions_id::integer
--LEFT JOIN import._17729_steuerbelastung_von_ledigen_bruttoeinkommen_von_150_000_franken_2013_de AS s150k_2013
     ON c.id = s150k_2013.regions_id::integer
--LEFT JOIN import._16346_steuerbelastung_von_ledigen_bruttoeinkommen_von_150_000_franken_2012_de AS s150k_2012
     ON c.id = s150k_2012.regions_id::integer
--LEFT JOIN import._15461_steuerbelastung_von_ledigen_bruttoeinkommen_von_150_000_franken_2011_de AS s150k_2011
     ON c.id = s150k_2011.regions_id::integer
--LEFT JOIN import._15547_steuerbelastung_von_ledigen_bruttoeinkommen_von_150_000_franken_2010_de AS s150k_2010
     ON c.id = s150k_2010.regions_id::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.tax_burden_married_two_kids_80k CASCADE;
CREATE TABLE public.tax_burden_married_two_kids_80k (
    community_id integer PRIMARY KEY,
    burden_80k_2013 decimal,
    burden_80k_2011 decimal,
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.tax_burden_married_two_kids_80k
SELECT c.id as community_id,
    m80k_2013.anteil_der_steuerbelastung_am_bruttoarbeitseinkommen_in_::decimal AS burden_80k_2013,
    m80k_2011.anteil_der_steuerbelastung_am_bruttoarbeitseinkommen_in_::decimal AS burden_80k_2011
)
FROM public.communities AS c
LEFT JOIN import._17727_steuerbelastung_von_verheirateten_mit_zwei_kindern_bruttoeinkommen_von_80_000_franken_2013_de AS m80k_2013 AS
     ON c.id = m80k_2013.regions_id::integer
LEFT JOIN import._15459_steuerbelastung_von_verheirateten_mit_zwei_kindern_bruttoeinkommen_von_80_000_franken_2011_de AS m80k_2011
     ON c.id = m80k_2011.regions_id::integer
--LEFT JOIN import._17728_steuerbelastung_von_verheirateten_mit_zwei_kindern_bruttoeinkommen_von_150_000_franken_2013_de AS m150k_2013
     ON c.id = m150k_2013.regions_id::integer
--LEFT JOIN import._15460_steuerbelastung_von_verheirateten_mit_zwei_kindern_bruttoeinkommen_von_150_000_franken_2011_de as m150k_2011
     ON c.id = m150k_2011.regions_id::integer
--LEFT JOIN import._16348_steuerbelastung_von_verheirateten_mit_zwei_kindern_bruttoeinkommen_von_150_000_franken_2012_de AS m150k_2010
     ON c.id = m150k_2010.regions_id::integer;
-------------------------------------------
