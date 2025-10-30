/*--
コールセンター分析 with Snowflake Cortex - セットアップスクリプト
このスクリプトは、コールセンター分析ソリューションに必要なすべてのオブジェクトを作成します。
--*/

use role accountadmin;
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

USE WAREHOUSE call_center_analytics_wh;

-- Snowflake IntelligenceにAgentを作成できるようにする
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE;
CREATE SCHEMA  IF NOT EXISTS SNOWFLAKE_INTELLIGENCE.AGENTS;

GRANT USAGE ON SCHEMA SNOWFLAKE_INTELLIGENCE.AGENTS TO ROLE PUBLIC;

-- エージェントのマスタの作成
-- SUPPORT_AGENTS テーブルを作成
CREATE OR REPLACE TABLE CALL_CENTER_ANALYTICS_DB.ANALYTICS.SUPPORT_AGENTS (
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

-- -- テーブルの内容を確認するクエリ (オプション)
-- SELECT Agent_name FROM CALL_CENTER_ANALYTICS_DB.ANALYTICS.SUPPORT_AGENTS;



-- Display next steps
SELECT '1.' AS step, 
       'Upload mp3 files to audio_files stage' AS instruction
UNION ALL
SELECT '2.', 'Upload and run call_center_analytics.ipynb notebook'
UNION ALL
SELECT '3.', 'Upload and run cortex_analyst_setup.ipynb notebook'
;
