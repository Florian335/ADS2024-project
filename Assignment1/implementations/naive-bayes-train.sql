-- Parse the RAW training data
CREATE OR REPLACE TABLE TRAINING_RAW AS
SELECT 
  CAST(PARSE_JSON(COL1):label AS INT) AS LABEL,
  CAST(PARSE_JSON(COL1):text AS VARCHAR) AS TEXT
FROM TRAINING
WHERE CAST(PARSE_JSON(COL1):label AS INT) IN (0, 1);

-- Tokenize the text
CREATE OR REPLACE TABLE TOKENIZED_DATA AS
SELECT
  t.LABEL,
  t2.VALUE AS TOKEN
FROM (
  SELECT LABEL, TEXT
  FROM TRAINING_RAW
  LIMIT 1000
) t,
LATERAL SPLIT_TO_TABLE(t.TEXT, ' ') t2;

-- Clean the tokens and lowercase all
CREATE OR REPLACE TABLE CLEAN_TOKENS AS
SELECT
  LABEL,
  LOWER(REGEXP_REPLACE(TOKEN, '[^a-zA-Z0-9]', '')) AS TOKEN
FROM TOKENIZED_DATA
WHERE TOKEN <> '';

-- Label frequency count
CREATE OR REPLACE TABLE LABEL_COUNTS AS
SELECT
  LABEL,
  COUNT(*) AS LABEL_COUNT
FROM CLEAN_TOKENS
GROUP BY LABEL;

-- Token frequency for each label
CREATE OR REPLACE TABLE FEATURE_LABEL_COUNTS AS
SELECT
  TOKEN AS FEATURE,
  LABEL,
  COUNT(*) AS FEATURE_LABEL_COUNT
FROM CLEAN_TOKENS
GROUP BY TOKEN, LABEL;

-- Compute Total Counts
CREATE OR REPLACE TABLE TOTAL_COUNT AS
SELECT SUM(LABEL_COUNT) AS TOTAL
FROM LABEL_COUNTS;

-- Compute Priors
CREATE OR REPLACE TABLE LABEL_PROBABILITIES AS
SELECT
  LABEL,
  (LABEL_COUNT * 1.0) / (SELECT TOTAL FROM TOTAL_COUNT) AS P_LABEL
FROM LABEL_COUNTS;

-- Compute the number of unique features (tokens)
CREATE OR REPLACE TABLE FEATURE_VOCABULARY AS
SELECT
  LABEL,
  COUNT(DISTINCT TOKEN) AS VOCAB_SIZE
FROM CLEAN_TOKENS
GROUP BY LABEL;

-- Compute conditional probabilities with Laplace smoothing
CREATE OR REPLACE TABLE FEATURE_PROBABILITIES AS
SELECT
    FL.FEATURE,
    FL.LABEL,
    (FL.FEATURE_LABEL_COUNT + 1.0) / (LC.LABEL_COUNT + FV.VOCAB_SIZE) AS P_FEATURE_LABEL
FROM FEATURE_LABEL_COUNTS FL
JOIN LABEL_COUNTS LC ON FL.LABEL = LC.LABEL
JOIN FEATURE_VOCABULARY FV ON FL.LABEL = FV.LABEL;

-- Add all the results to the table
CREATE OR REPLACE TABLE NB_MODEL (
    FEATURE VARCHAR(16777216),
    LABEL VARCHAR(16777216),
    PROBABILITY VARCHAR(16777216)
) AS
SELECT
    FEATURE,
    LABEL,
    TO_VARCHAR(P_FEATURE_LABEL) AS PROBABILITY
FROM FEATURE_PROBABILITIES;

-- Store priors in the same table
INSERT INTO NB_MODEL (FEATURE, LABEL, PROBABILITY)
SELECT
    '__PRIOR__' AS FEATURE,
    LABEL,
    TO_VARCHAR(P_LABEL) AS PROBABILITY
FROM LABEL_PROBABILITIES;