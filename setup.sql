/*--
コールセンター分析 with Snowflake Cortex - セットアップスクリプト
このスクリプトは、コールセンター分析ソリューションに必要なすべてのオブジェクトを作成します。
--*/

USE ROLE accountadmin;

-- Create custom role for call center analytics
CREATE OR REPLACE ROLE call_center_analytics_role
    COMMENT = 'Role for call center analytics with AI_TRANSCRIBE and Cortex Agents';

-- Create warehouse for call center analytics
CREATE OR REPLACE WAREHOUSE call_center_analytics_wh
    WAREHOUSE_SIZE = 'medium'
    WAREHOUSE_TYPE = 'standard'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for call center analytics with Cortex LLM';

-- Grant warehouse usage to custom role
GRANT USAGE ON WAREHOUSE call_center_analytics_wh TO ROLE call_center_analytics_role;
GRANT OPERATE ON WAREHOUSE call_center_analytics_wh TO ROLE call_center_analytics_role;

USE WAREHOUSE call_center_analytics_wh;

-- assign Query Tag to Session. This helps with performance monitoring and troubleshooting
ALTER SESSION SET query_tag = '{"origin":"sf_sit-is","name":"call_center_analytics_2","version":{"major":1, "minor":0},"attributes":{"is_quickstart":1, "source":"sql"}}';

-- Create database and schemas
CREATE DATABASE IF NOT EXISTS call_center_analytics_db;
CREATE OR REPLACE SCHEMA call_center_analytics_db.analytics;

-- Grant database and schema access to custom role
GRANT USAGE ON DATABASE call_center_analytics_db TO ROLE call_center_analytics_role;
GRANT USAGE ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT USAGE ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;

-- Grant create privileges on schemas
GRANT CREATE TABLE ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT CREATE VIEW ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT CREATE STAGE ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT CREATE FILE FORMAT ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT CREATE FUNCTION ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT CREATE TABLE ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT CREATE VIEW ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT CREATE STAGE ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT CREATE FILE FORMAT ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT CREATE FUNCTION ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT CREATE STREAMLIT ON SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;

-- Grant CORTEX_USER role for Cortex functions access
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE call_center_analytics_role;

-- role hierarchy
GRANT ROLE call_center_analytics_role TO ROLE sysadmin;

-- Create stages for data and audio files
CREATE OR REPLACE STAGE call_center_analytics_db.analytics.audio_files_ja
    DIRECTORY = (ENABLE = TRUE)
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
    COMMENT = 'Stage for call center audio files';

-- Grant stage access to custom role
GRANT READ ON STAGE call_center_analytics_db.analytics.audio_files_ja TO ROLE call_center_analytics_role;
GRANT WRITE ON STAGE call_center_analytics_db.analytics.audio_files_ja TO ROLE call_center_analytics_role;

GRANT READ ON STAGE call_center_analytics_db.analytics.audio_files_ja TO ROLE call_center_analytics_role;
GRANT WRITE ON STAGE call_center_analytics_db.analytics.audio_files_ja TO ROLE call_center_analytics_role;

-- Grant SELECT privileges on all tables for Cortex Analyst semantic models
GRANT SELECT ON ALL TABLES IN SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT SELECT ON ALL TABLES IN SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;

-- Grant SELECT privileges on all views for Cortex Analyst semantic models
GRANT SELECT ON ALL VIEWS IN SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT SELECT ON ALL VIEWS IN SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA call_center_analytics_db.public TO ROLE call_center_analytics_role;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA call_center_analytics_db.analytics TO ROLE call_center_analytics_role;


-- Grant Create Seamntic View & Agent
GRANT USAGE ON DATABASE CALL_CENTER_ANALYTICS_DB TO ROLE call_center_analytics_role;
GRANT USAGE, CREATE SEMANTIC VIEW
  ON SCHEMA CALL_CENTER_ANALYTICS_DB.ANALYTICS TO ROLE call_center_analytics_role;

GRANT SELECT
  ON TABLE CALL_CENTER_ANALYTICS_DB.ANALYTICS.COMPREHENSIVE_CALL_ANALYSIS_JA
  TO ROLE call_center_analytics_role;

GRANT USAGE, CREATE AGENT ON SCHEMA CALL_CENTER_ANALYTICS_DB.ANALYTICS TO ROLE call_center_analytics_role;


-- Snowflake IntelligenceにAgentを作成できるようにする
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE;
CREATE SCHEMA  IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS;

GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE PUBLIC;
GRANT CREATE AGENT ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE call_center_analytics_role;


-- エージェントのマスタの作成
-- SalesAgents テーブルを作成
CREATE TABLE CALL_CENTER_ANALYTICS_DB.ANALYTICS.SUPPORT_AGENTS (
    Agent_name VARCHAR(100) NOT NULL PRIMARY KEY
);

-- データを挿入
INSERT INTO CALL_CENTER_ANALYTICS_DB.ANALYTICS.SUPPORT_AGENTS (Agent_name) VALUES
('Amanda Williams'),
('Emily Davis'),
('Sarah Chen'),
('Robert Kim'),
('Michael Rodriguez'),
('Christopher Lee'),
('David Thompson'),
('Lisa Johnson'),
('Nicole Taylor'),
('James Martinez'),
('Rachel Green'),
('Daniel Garcia'),
('Kevin Wong'),
('Ashley Brown'),
('Kelly Smith'),
('Steve Johnson'),
('Tony Garcia'),
('Mike Thompson'),
('Tina Davis'),
('Brian Wilson');

-- テーブルの内容を確認するクエリ (オプション)
SELECT Agent_name FROM CALL_CENTER_ANALYTICS_DB.ANALYTICS.SUPPORT_AGENTS;



-- Display next steps
SELECT '1.' AS step, 
       'Upload mp3 files to audio_files stage' AS instruction
UNION ALL
SELECT '2.', 'Upload and run call_center_analytics.ipynb notebook'
UNION ALL
SELECT '3.', 'Upload and run cortex_analyst_setup.ipynb notebook'
;


ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';
