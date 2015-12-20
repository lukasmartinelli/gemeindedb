-------------------------------------------
DROP TABLE IF EXISTS public.city_class;
DROP TABLE IF EXISTS public.municipalities;
DROP TABLE IF EXISTS public.districts;
DROP TABLE IF EXISTS public.cantons;

-------------------------------------------
CREATE TABLE public.cantons (
    id     integer PRIMARY KEY,
    name    varchar(30) NOT NULL
);

INSERT INTO public.cantons
SELECT id::integer, name FROM import.kantone;
-------------------------------------------
CREATE TABLE public.districts (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    name      varchar(30) NOT NULL
);

INSERT INTO public.districts
SELECT id::integer, kanton_id::integer as canton_id, name FROM import.bezirke;

-------------------------------------------
CREATE TABLE public.municipalities (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    name      varchar(30) NOT NULL
);

INSERT INTO public.municipalities
SELECT id::integer, kanton_id::integer as canton_id, name FROM import.gemeinden;

-------------------------------------------
CREATE TABLE public.city_class (
    municipality_id integer PRIMARY KEY,
    class           varchar(50) NOT NULL,
    FOREIGN KEY (municipality_id) REFERENCES public.municipalities (id)
);

INSERT INTO public.city_class
SELECT id::integer as municipality_id, name FROM import.gemeinde_stadt_charakteristika
WHERE id NOT LIKE 'AT_%'
  AND id NOT LIKE 'FR_%'
  AND id NOT LIKE 'IT_%'
  AND id not LIKE 'DE_%'
  AND id NOT LIKE 'LI_%'
  AND id::integer IN (SELECT id FROM public.municipalities);
