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
CREATE OR REPLACE FUNCTION values_by_year_1995_2012(table_name text, column_name text)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY EXECUTE format(
        'SELECT region, 2012 as year, _2012 as %2$s FROM %1$s
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
        SELECT region, 1995 as year, _1995 as %2$s FROM %1$s',
        table_name, column_name);
END;
$$
LANGUAGE plpgsql;

-------------------------------------------
CREATE OR REPLACE FUNCTION values_by_year_1969_2014(table_name text, value_column text, other_columns text)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY EXECUTE format(
        'SELECT %3$s, 2014 as year, _2014 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2013 as year, _2013 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2012 as year, _2012 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2011 as year, _2011 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2010 as year, _2010 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2009 as year, _2009 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2008 as year, _2008 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2007 as year, _2007 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2006 as year, _2006 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2005 as year, _2005 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2004 as year, _2004 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2003 as year, _2003 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2002 as year, _2002 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2001 as year, _2001 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 2000 as year, _2000 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1999 as year, _1999 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1998 as year, _1998 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1997 as year, _1997 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1996 as year, _1996 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1995 as year, _1995 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1994 as year, _1994 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1993 as year, _1993 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1992 as year, _1992 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1991 as year, _1991 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1990 as year, _1990 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1989 as year, _1989 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1988 as year, _1988 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1987 as year, _1987 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1986 as year, _1986 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1985 as year, _1985 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1984 as year, _1984 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1983 as year, _1983 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1982 as year, _1982 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1981 as year, _1981 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1980 as year, _1980 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1979 as year, _1979 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1978 as year, _1978 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1977 as year, _1977 as %2$s FROM %1$s 
        UNION ALL
        SELECT %3$s, 1976 as year, _1976 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1975 as year, _1975 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1974 as year, _1974 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1973 as year, _1973 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1972 as year, _1972 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1971 as year, _1971 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1970 as year, _1970 as %2$s FROM %1$s
        UNION ALL
        SELECT %3$s, 1969 as year, _1969 as %2$s FROM %1$s',
        table_name, value_column, other_columns);
END;
$$
LANGUAGE plpgsql;
