--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: decisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE decisions (
    id integer NOT NULL,
    doc_file character varying(255),
    promulgated_on date,
    html text,
    pdf_file character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    text text,
    original_filename character varying(255),
    appeal_number character varying(255),
    url character varying(255),
    tribunal_id integer,
    reported boolean,
    old_details_url character varying(255),
    starred boolean,
    panel boolean,
    country_guideline boolean,
    judges character varying(255)[] DEFAULT '{}'::character varying[],
    categories character varying(255)[] DEFAULT '{}'::character varying[],
    country character varying(255),
    claimant character varying(255),
    keywords character varying(255)[] DEFAULT '{}'::character varying[],
    case_notes character varying(255),
    case_name character varying(255),
    hearing_on date,
    ncn character varying(255)
);


--
-- Name: decisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE decisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: decisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE decisions_id_seq OWNED BY decisions.id;


--
-- Name: import_errors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE import_errors (
    id integer NOT NULL,
    error character varying(255),
    backtrace text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    decision_id integer
);


--
-- Name: import_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE import_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE import_errors_id_seq OWNED BY import_errors.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY decisions ALTER COLUMN id SET DEFAULT nextval('decisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY import_errors ALTER COLUMN id SET DEFAULT nextval('import_errors_id_seq'::regclass);


--
-- Name: decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY decisions
    ADD CONSTRAINT decisions_pkey PRIMARY KEY (id);


--
-- Name: import_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY import_errors
    ADD CONSTRAINT import_errors_pkey PRIMARY KEY (id);


--
-- Name: decisions_fts_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX decisions_fts_idx ON decisions USING gin (to_tsvector('english'::regconfig, text));


--
-- Name: decisions_fts_idx_after_jun1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX decisions_fts_idx_after_jun1 ON decisions USING gin (to_tsvector('english'::regconfig, text)) WHERE ((promulgated_on >= '2013-06-01'::date) OR (reported = true));


--
-- Name: index_decisions_on_country; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_country ON decisions USING btree (country);


--
-- Name: index_decisions_on_country_guideline; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_country_guideline ON decisions USING btree (country_guideline);


--
-- Name: index_decisions_on_judges; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_judges ON decisions USING btree (judges);


--
-- Name: index_decisions_on_promulgated_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_promulgated_on ON decisions USING btree (promulgated_on DESC);


--
-- Name: index_decisions_on_reported; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_decisions_on_reported ON decisions USING btree (reported);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130221154317');

INSERT INTO schema_migrations (version) VALUES ('20130227123458');

INSERT INTO schema_migrations (version) VALUES ('20130227124449');

INSERT INTO schema_migrations (version) VALUES ('20130307104637');

INSERT INTO schema_migrations (version) VALUES ('20130307105302');

INSERT INTO schema_migrations (version) VALUES ('20130308104302');

INSERT INTO schema_migrations (version) VALUES ('20130308120729');

INSERT INTO schema_migrations (version) VALUES ('20130312173409');

INSERT INTO schema_migrations (version) VALUES ('20130315173007');

INSERT INTO schema_migrations (version) VALUES ('20130315173212');

INSERT INTO schema_migrations (version) VALUES ('20130318113645');

INSERT INTO schema_migrations (version) VALUES ('20130318140942');

INSERT INTO schema_migrations (version) VALUES ('20130412104425');

INSERT INTO schema_migrations (version) VALUES ('20130412132257');

INSERT INTO schema_migrations (version) VALUES ('20130415111723');

INSERT INTO schema_migrations (version) VALUES ('20130416092328');

INSERT INTO schema_migrations (version) VALUES ('20130423122537');

INSERT INTO schema_migrations (version) VALUES ('20130711143547');

INSERT INTO schema_migrations (version) VALUES ('20130712131321');

INSERT INTO schema_migrations (version) VALUES ('20130724093005');

INSERT INTO schema_migrations (version) VALUES ('20130801162847');

INSERT INTO schema_migrations (version) VALUES ('20130801163401');

INSERT INTO schema_migrations (version) VALUES ('20130802112712');
