--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Debian 13.3-1.pgdg100+1)
-- Dumped by pg_dump version 13.3 (Ubuntu 13.3-1.pgdg18.04+1)

-- Started on 2021-07-23 21:34:47 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 16808)
-- Name: bookings; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bookings;


ALTER SCHEMA bookings OWNER TO postgres;

--
-- TOC entry 3039 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA bookings; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA bookings IS 'Airlines demo database schema';


--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3040 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 214 (class 1255 OID 16809)
-- Name: lang(); Type: FUNCTION; Schema: bookings; Owner: postgres
--

CREATE FUNCTION bookings.lang() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  RETURN current_setting('bookings.lang');
EXCEPTION
  WHEN undefined_object THEN
    RETURN NULL;
END;
$$;


ALTER FUNCTION bookings.lang() OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 16810)
-- Name: now(); Type: FUNCTION; Schema: bookings; Owner: postgres
--

CREATE FUNCTION bookings.now() RETURNS timestamp with time zone
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '2017-08-15 18:00:00'::TIMESTAMP AT TIME ZONE 'Europe/Moscow';$$;


ALTER FUNCTION bookings.now() OWNER TO postgres;

--
-- TOC entry 3041 (class 0 OID 0)
-- Dependencies: 215
-- Name: FUNCTION now(); Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON FUNCTION bookings.now() IS 'Point in time according to which the data are generated';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 201 (class 1259 OID 16811)
-- Name: aircrafts_data; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.aircrafts_data (
    aircraft_code character(3) NOT NULL,
    model jsonb NOT NULL,
    range integer NOT NULL,
    CONSTRAINT aircrafts_range_check CHECK ((range > 0))
);


ALTER TABLE bookings.aircrafts_data OWNER TO postgres;

--
-- TOC entry 3042 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE aircrafts_data; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.aircrafts_data IS 'Aircrafts (internal data)';


--
-- TOC entry 3043 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN aircrafts_data.aircraft_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.aircrafts_data.aircraft_code IS 'Aircraft code, IATA';


--
-- TOC entry 3044 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN aircrafts_data.model; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.aircrafts_data.model IS 'Aircraft model';


--
-- TOC entry 3045 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN aircrafts_data.range; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.aircrafts_data.range IS 'Maximal flying distance, km';


--
-- TOC entry 202 (class 1259 OID 16818)
-- Name: aircrafts; Type: VIEW; Schema: bookings; Owner: postgres
--

CREATE VIEW bookings.aircrafts AS
 SELECT ml.aircraft_code,
    (ml.model ->> bookings.lang()) AS model,
    ml.range
   FROM bookings.aircrafts_data ml;


ALTER TABLE bookings.aircrafts OWNER TO postgres;

--
-- TOC entry 3046 (class 0 OID 0)
-- Dependencies: 202
-- Name: VIEW aircrafts; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON VIEW bookings.aircrafts IS 'Aircrafts';


--
-- TOC entry 3047 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN aircrafts.aircraft_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.aircrafts.aircraft_code IS 'Aircraft code, IATA';


--
-- TOC entry 3048 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN aircrafts.model; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.aircrafts.model IS 'Aircraft model';


--
-- TOC entry 3049 (class 0 OID 0)
-- Dependencies: 202
-- Name: COLUMN aircrafts.range; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.aircrafts.range IS 'Maximal flying distance, km';


--
-- TOC entry 203 (class 1259 OID 16822)
-- Name: airports_data; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.airports_data (
    airport_code character(3) NOT NULL,
    airport_name jsonb NOT NULL,
    city jsonb NOT NULL,
    coordinates point NOT NULL,
    timezone text NOT NULL
);


ALTER TABLE bookings.airports_data OWNER TO postgres;

--
-- TOC entry 3050 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE airports_data; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.airports_data IS 'Airports (internal data)';


--
-- TOC entry 3051 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN airports_data.airport_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports_data.airport_code IS 'Airport code';


--
-- TOC entry 3052 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN airports_data.airport_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports_data.airport_name IS 'Airport name';


--
-- TOC entry 3053 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN airports_data.city; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports_data.city IS 'City';


--
-- TOC entry 3054 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN airports_data.coordinates; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports_data.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- TOC entry 3055 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN airports_data.timezone; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports_data.timezone IS 'Airport time zone';


--
-- TOC entry 204 (class 1259 OID 16828)
-- Name: airports; Type: VIEW; Schema: bookings; Owner: postgres
--

CREATE VIEW bookings.airports AS
 SELECT ml.airport_code,
    (ml.airport_name ->> bookings.lang()) AS airport_name,
    (ml.city ->> bookings.lang()) AS city,
    ml.coordinates,
    ml.timezone
   FROM bookings.airports_data ml;


ALTER TABLE bookings.airports OWNER TO postgres;

--
-- TOC entry 3056 (class 0 OID 0)
-- Dependencies: 204
-- Name: VIEW airports; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON VIEW bookings.airports IS 'Airports';


--
-- TOC entry 3057 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN airports.airport_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports.airport_code IS 'Airport code';


--
-- TOC entry 3058 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN airports.airport_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports.airport_name IS 'Airport name';


--
-- TOC entry 3059 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN airports.city; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports.city IS 'City';


--
-- TOC entry 3060 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN airports.coordinates; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- TOC entry 3061 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN airports.timezone; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.airports.timezone IS 'Airport time zone';


--
-- TOC entry 205 (class 1259 OID 16832)
-- Name: boarding_passes; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.boarding_passes (
    ticket_no character(13) NOT NULL,
    flight_id integer NOT NULL,
    boarding_no integer NOT NULL,
    seat_no character varying(4) NOT NULL
);


ALTER TABLE bookings.boarding_passes OWNER TO postgres;

--
-- TOC entry 3062 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE boarding_passes; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.boarding_passes IS 'Boarding passes';


--
-- TOC entry 3063 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN boarding_passes.ticket_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.boarding_passes.ticket_no IS 'Ticket number';


--
-- TOC entry 3064 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN boarding_passes.flight_id; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.boarding_passes.flight_id IS 'Flight ID';


--
-- TOC entry 3065 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN boarding_passes.boarding_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.boarding_passes.boarding_no IS 'Boarding pass number';


--
-- TOC entry 3066 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN boarding_passes.seat_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.boarding_passes.seat_no IS 'Seat number';


--
-- TOC entry 206 (class 1259 OID 16835)
-- Name: bookings; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.bookings (
    book_ref character(6) NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL
);


ALTER TABLE bookings.bookings OWNER TO postgres;

--
-- TOC entry 3067 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE bookings; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.bookings IS 'Bookings';


--
-- TOC entry 3068 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN bookings.book_ref; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.bookings.book_ref IS 'Booking number';


--
-- TOC entry 3069 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN bookings.book_date; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.bookings.book_date IS 'Booking date';


--
-- TOC entry 3070 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN bookings.total_amount; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.bookings.total_amount IS 'Total booking cost';


--
-- TOC entry 207 (class 1259 OID 16838)
-- Name: flights; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.flights (
    flight_id integer NOT NULL,
    flight_no character(6) NOT NULL,
    scheduled_departure timestamp with time zone NOT NULL,
    scheduled_arrival timestamp with time zone NOT NULL,
    departure_airport character(3) NOT NULL,
    arrival_airport character(3) NOT NULL,
    status character varying(20) NOT NULL,
    aircraft_code character(3) NOT NULL,
    actual_departure timestamp with time zone,
    actual_arrival timestamp with time zone,
    CONSTRAINT flights_check CHECK ((scheduled_arrival > scheduled_departure)),
    CONSTRAINT flights_check1 CHECK (((actual_arrival IS NULL) OR ((actual_departure IS NOT NULL) AND (actual_arrival IS NOT NULL) AND (actual_arrival > actual_departure)))),
    CONSTRAINT flights_status_check CHECK (((status)::text = ANY (ARRAY[('On Time'::character varying)::text, ('Delayed'::character varying)::text, ('Departed'::character varying)::text, ('Arrived'::character varying)::text, ('Scheduled'::character varying)::text, ('Cancelled'::character varying)::text])))
);


ALTER TABLE bookings.flights OWNER TO postgres;

--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE flights; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.flights IS 'Flights';


--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.flight_id; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.flight_id IS 'Flight ID';


--
-- TOC entry 3073 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.flight_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.flight_no IS 'Flight number';


--
-- TOC entry 3074 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.scheduled_departure IS 'Scheduled departure time';


--
-- TOC entry 3075 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.scheduled_arrival IS 'Scheduled arrival time';


--
-- TOC entry 3076 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.departure_airport; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.departure_airport IS 'Airport of departure';


--
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.arrival_airport; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.arrival_airport IS 'Airport of arrival';


--
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.status; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.status IS 'Flight status';


--
-- TOC entry 3079 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.aircraft_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.aircraft_code IS 'Aircraft code, IATA';


--
-- TOC entry 3080 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.actual_departure; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.actual_departure IS 'Actual departure time';


--
-- TOC entry 3081 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN flights.actual_arrival; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights.actual_arrival IS 'Actual arrival time';


--
-- TOC entry 208 (class 1259 OID 16844)
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: bookings; Owner: postgres
--

CREATE SEQUENCE bookings.flights_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bookings.flights_flight_id_seq OWNER TO postgres;

--
-- TOC entry 3082 (class 0 OID 0)
-- Dependencies: 208
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: bookings; Owner: postgres
--

ALTER SEQUENCE bookings.flights_flight_id_seq OWNED BY bookings.flights.flight_id;


--
-- TOC entry 209 (class 1259 OID 16846)
-- Name: flights_v; Type: VIEW; Schema: bookings; Owner: postgres
--

CREATE VIEW bookings.flights_v AS
 SELECT f.flight_id,
    f.flight_no,
    f.scheduled_departure,
    timezone(dep.timezone, f.scheduled_departure) AS scheduled_departure_local,
    f.scheduled_arrival,
    timezone(arr.timezone, f.scheduled_arrival) AS scheduled_arrival_local,
    (f.scheduled_arrival - f.scheduled_departure) AS scheduled_duration,
    f.departure_airport,
    dep.airport_name AS departure_airport_name,
    dep.city AS departure_city,
    f.arrival_airport,
    arr.airport_name AS arrival_airport_name,
    arr.city AS arrival_city,
    f.status,
    f.aircraft_code,
    f.actual_departure,
    timezone(dep.timezone, f.actual_departure) AS actual_departure_local,
    f.actual_arrival,
    timezone(arr.timezone, f.actual_arrival) AS actual_arrival_local,
    (f.actual_arrival - f.actual_departure) AS actual_duration
   FROM bookings.flights f,
    bookings.airports dep,
    bookings.airports arr
  WHERE ((f.departure_airport = dep.airport_code) AND (f.arrival_airport = arr.airport_code));


ALTER TABLE bookings.flights_v OWNER TO postgres;

--
-- TOC entry 3083 (class 0 OID 0)
-- Dependencies: 209
-- Name: VIEW flights_v; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON VIEW bookings.flights_v IS 'Flights (extended)';


--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.flight_id; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.flight_id IS 'Flight ID';


--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.flight_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.flight_no IS 'Flight number';


--
-- TOC entry 3086 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.scheduled_departure IS 'Scheduled departure time';


--
-- TOC entry 3087 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.scheduled_departure_local; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.scheduled_departure_local IS 'Scheduled departure time, local time at the point of departure';


--
-- TOC entry 3088 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.scheduled_arrival IS 'Scheduled arrival time';


--
-- TOC entry 3089 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.scheduled_arrival_local; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.scheduled_arrival_local IS 'Scheduled arrival time, local time at the point of destination';


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.scheduled_duration; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.scheduled_duration IS 'Scheduled flight duration';


--
-- TOC entry 3091 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.departure_airport; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.departure_airport IS 'Deprature airport code';


--
-- TOC entry 3092 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.departure_airport_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.departure_airport_name IS 'Departure airport name';


--
-- TOC entry 3093 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.departure_city; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.departure_city IS 'City of departure';


--
-- TOC entry 3094 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.arrival_airport; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.arrival_airport IS 'Arrival airport code';


--
-- TOC entry 3095 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.arrival_airport_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.arrival_airport_name IS 'Arrival airport name';


--
-- TOC entry 3096 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.arrival_city; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.arrival_city IS 'City of arrival';


--
-- TOC entry 3097 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.status; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.status IS 'Flight status';


--
-- TOC entry 3098 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.aircraft_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.aircraft_code IS 'Aircraft code, IATA';


--
-- TOC entry 3099 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.actual_departure; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.actual_departure IS 'Actual departure time';


--
-- TOC entry 3100 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.actual_departure_local; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.actual_departure_local IS 'Actual departure time, local time at the point of departure';


--
-- TOC entry 3101 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.actual_arrival; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.actual_arrival IS 'Actual arrival time';


--
-- TOC entry 3102 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.actual_arrival_local; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.actual_arrival_local IS 'Actual arrival time, local time at the point of destination';


--
-- TOC entry 3103 (class 0 OID 0)
-- Dependencies: 209
-- Name: COLUMN flights_v.actual_duration; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.flights_v.actual_duration IS 'Actual flight duration';


--
-- TOC entry 210 (class 1259 OID 16851)
-- Name: routes; Type: VIEW; Schema: bookings; Owner: postgres
--

CREATE VIEW bookings.routes AS
 WITH f3 AS (
         SELECT f2.flight_no,
            f2.departure_airport,
            f2.arrival_airport,
            f2.aircraft_code,
            f2.duration,
            array_agg(f2.days_of_week) AS days_of_week
           FROM ( SELECT f1.flight_no,
                    f1.departure_airport,
                    f1.arrival_airport,
                    f1.aircraft_code,
                    f1.duration,
                    f1.days_of_week
                   FROM ( SELECT flights.flight_no,
                            flights.departure_airport,
                            flights.arrival_airport,
                            flights.aircraft_code,
                            (flights.scheduled_arrival - flights.scheduled_departure) AS duration,
                            (to_char(flights.scheduled_departure, 'ID'::text))::integer AS days_of_week
                           FROM bookings.flights) f1
                  GROUP BY f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week
                  ORDER BY f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week) f2
          GROUP BY f2.flight_no, f2.departure_airport, f2.arrival_airport, f2.aircraft_code, f2.duration
        )
 SELECT f3.flight_no,
    f3.departure_airport,
    dep.airport_name AS departure_airport_name,
    dep.city AS departure_city,
    f3.arrival_airport,
    arr.airport_name AS arrival_airport_name,
    arr.city AS arrival_city,
    f3.aircraft_code,
    f3.duration,
    f3.days_of_week
   FROM f3,
    bookings.airports dep,
    bookings.airports arr
  WHERE ((f3.departure_airport = dep.airport_code) AND (f3.arrival_airport = arr.airport_code));


ALTER TABLE bookings.routes OWNER TO postgres;

--
-- TOC entry 3104 (class 0 OID 0)
-- Dependencies: 210
-- Name: VIEW routes; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON VIEW bookings.routes IS 'Routes';


--
-- TOC entry 3105 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.flight_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.flight_no IS 'Flight number';


--
-- TOC entry 3106 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.departure_airport; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.departure_airport IS 'Code of airport of departure';


--
-- TOC entry 3107 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.departure_airport_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.departure_airport_name IS 'Name of airport of departure';


--
-- TOC entry 3108 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.departure_city; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.departure_city IS 'City of departure';


--
-- TOC entry 3109 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.arrival_airport; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.arrival_airport IS 'Code of airport of arrival';


--
-- TOC entry 3110 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.arrival_airport_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.arrival_airport_name IS 'Name of airport of arrival';


--
-- TOC entry 3111 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.arrival_city; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.arrival_city IS 'City of arrival';


--
-- TOC entry 3112 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.aircraft_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.aircraft_code IS 'Aircraft code, IATA';


--
-- TOC entry 3113 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.duration; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.duration IS 'Scheduled duration of flight';


--
-- TOC entry 3114 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN routes.days_of_week; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.routes.days_of_week IS 'Days of week on which flights are scheduled';


--
-- TOC entry 211 (class 1259 OID 16856)
-- Name: seats; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.seats (
    aircraft_code character(3) NOT NULL,
    seat_no character varying(4) NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    CONSTRAINT seats_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


ALTER TABLE bookings.seats OWNER TO postgres;

--
-- TOC entry 3115 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE seats; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.seats IS 'Seats';


--
-- TOC entry 3116 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN seats.aircraft_code; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.seats.aircraft_code IS 'Aircraft code, IATA';


--
-- TOC entry 3117 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN seats.seat_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.seats.seat_no IS 'Seat number';


--
-- TOC entry 3118 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN seats.fare_conditions; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.seats.fare_conditions IS 'Travel class';


--
-- TOC entry 212 (class 1259 OID 16860)
-- Name: ticket_flights; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.ticket_flights (
    ticket_no character(13) NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    amount numeric(10,2) NOT NULL,
    CONSTRAINT ticket_flights_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT ticket_flights_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


ALTER TABLE bookings.ticket_flights OWNER TO postgres;

--
-- TOC entry 3119 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE ticket_flights; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.ticket_flights IS 'Flight segment';


--
-- TOC entry 3120 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN ticket_flights.ticket_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.ticket_flights.ticket_no IS 'Ticket number';


--
-- TOC entry 3121 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN ticket_flights.flight_id; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.ticket_flights.flight_id IS 'Flight ID';


--
-- TOC entry 3122 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN ticket_flights.fare_conditions; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.ticket_flights.fare_conditions IS 'Travel class';


--
-- TOC entry 3123 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN ticket_flights.amount; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.ticket_flights.amount IS 'Travel cost';


--
-- TOC entry 213 (class 1259 OID 16865)
-- Name: tickets; Type: TABLE; Schema: bookings; Owner: postgres
--

CREATE TABLE bookings.tickets (
    ticket_no character(13) NOT NULL,
    book_ref character(6) NOT NULL,
    passenger_id character varying(20) NOT NULL,
    passenger_name text NOT NULL,
    contact_data jsonb
);


ALTER TABLE bookings.tickets OWNER TO postgres;

--
-- TOC entry 3124 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE tickets; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON TABLE bookings.tickets IS 'Tickets';


--
-- TOC entry 3125 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN tickets.ticket_no; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.tickets.ticket_no IS 'Ticket number';


--
-- TOC entry 3126 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN tickets.book_ref; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.tickets.book_ref IS 'Booking number';


--
-- TOC entry 3127 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN tickets.passenger_id; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.tickets.passenger_id IS 'Passenger ID';


--
-- TOC entry 3128 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN tickets.passenger_name; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.tickets.passenger_name IS 'Passenger name';


--
-- TOC entry 3129 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN tickets.contact_data; Type: COMMENT; Schema: bookings; Owner: postgres
--

COMMENT ON COLUMN bookings.tickets.contact_data IS 'Passenger contact information';


--
-- TOC entry 2854 (class 2604 OID 16871)
-- Name: flights flight_id; Type: DEFAULT; Schema: bookings; Owner: postgres
--

ALTER TABLE ONLY bookings.flights ALTER COLUMN flight_id SET DEFAULT nextval('bookings.flights_flight_id_seq'::regclass);


--
-- TOC entry 3025 (class 0 OID 16811)
-- Dependencies: 201
-- Data for Name: aircrafts_data; Type: TABLE DATA; Schema: bookings; Owner: postgres
--