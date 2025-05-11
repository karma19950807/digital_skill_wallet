-- Create a database
CREATE DATABASE digital_skill_wallet_db;

USE digital_skill_wallet_db;

-- Table for School
CREATE TABLE school (
  school_id INT AUTO_INCREMENT PRIMARY KEY,
  school_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL
);

-- Table for Student
CREATE TABLE student (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  school_id INT NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  FOREIGN KEY (school_id) REFERENCES school(school_id)
);

-- Table for Test Score
CREATE TABLE test_score_staging (
  test_score_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  test_id VARCHAR(50) NOT NULL,
  course_name VARCHAR(100),
  logical_thinking INT,
  critical_analysis INT,
  problem_solving INT,
  digital_tools INT,
  grade_level INT,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_ready BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (student_id) REFERENCES student(student_id)
);

-- Table for Artefact
CREATE TABLE artefact (
  artefact_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  test_id VARCHAR(50) NOT NULL,
  artefact_json TEXT,
  artefact_hash TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES student(student_id)
);

-- Table for Skill Wallet
CREATE TABLE skill_wallet_temp (
  wallet_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  test_id VARCHAR(50),
  grade_level INT,
  skillcoin_json TEXT,
  artefact_hash TEXT,
  status ENUM('staged', 'endorsed', 'submitted', 'committed') DEFAULT 'staged',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES student(student_id)
);

SHOW Tables;

DESCRIBE school;

-- Insert in shool table
INSERT INTO school (school_id, school_name, email, password) VALUES 
(1, 'Zillmere State High School', 'zshs@school.com', 'pass123');
INSERT INTO school (school_id, school_name, email, password) VALUES 
(2, 'Bracken Ridge State High School', 'brshs@school.com', 'pass123');
INSERT INTO school (school_id, school_name, email, password) VALUES 
(3, 'Geebung State School', 'gss@school.com', 'pass123');

-- Insert in student table
INSERT INTO student (student_id, name, school_id, email, password) VALUES (1, 'Karma Samdrup', 2, 'ks@school.com', 'pass123');
INSERT INTO student (student_id, name, school_id, email, password) VALUES (2, 'Tshewang Chophel', 1, 'tc@school.com', 'pass123');
INSERT INTO student (student_id, name, school_id, email, password) VALUES (3, 'Tshewang Tenzin', 3, 'tt@school.com', 'pass123');
INSERT INTO student (student_id, name, school_id, email, password) VALUES (4, 'Phuntsho Choden', 2, 'pc@school.com', 'pass123');
INSERT INTO student (student_id, name, school_id, email, password) VALUES (5, 'Tandin Bidha', 2, 'tb@school.com', 'pass123');
INSERT INTO student (student_id, name, school_id, email, password) VALUES (6, 'Kala Maya Sanyasi', 3, 'kms@school.com', 'pass123');

-- Insert in Test score
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (1, 'CRT-2025-001', 'Digital Skills', 68, 98, 80, 79, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (2, 'CRT-2025-002', 'Digital Skills', 98, 79, 61, 96, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (3, 'CRT-2025-003', 'Digital Skills', 73, 80, 72, 63, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (4, 'CRT-2025-004', 'Digital Skills', 92, 78, 63, 75, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (5, 'CRT-2025-005', 'Digital Skills', 67, 94, 89, 69, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (6, 'CRT-2025-006', 'Digital Skills', 78, 65, 88, 90, 11, TRUE);

-- Insert in Artefact table
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES (1, 'CRT-2025-001', '{"rubric": "scale 10", "questions": ["Q1", "Q2"], "answers": ["A", "B"]}', 'QmArtefactHash1');
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES (2, 'CRT-2025-002', '{"rubric": "scale 10", "questions": ["Q1", "Q2"], "answers": ["A", "B"]}', 'QmArtefactHash2');
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES (3, 'CRT-2025-003', '{"rubric": "scale 10", "questions": ["Q1", "Q2"], "answers": ["A", "B"]}', 'QmArtefactHash3');
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES (4, 'CRT-2025-004', '{"rubric": "scale 10", "questions": ["Q1", "Q2"], "answers": ["A", "B"]}', 'QmArtefactHash4');
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES (5, 'CRT-2025-005', '{"rubric": "scale 10", "questions": ["Q1", "Q2"], "answers": ["A", "B"]}', 'QmArtefactHash5');
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES (6, 'CRT-2025-006', '{"rubric": "scale 10", "questions": ["Q1", "Q2"], "answers": ["A", "B"]}', 'QmArtefactHash6');

-- Insert the skill wallet
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES (1, 'CRT-2025-001', 9, '{"student_id": "1", "test_id": "CRT-2025-001", "grade_level": 9, "skills": {"logical": 68, "analysis": 98, "problem": 80, "digital_tools": 79}, "artefact_hash": "QmArtefactHash1"}', 'QmArtefactHash1', 'staged');
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES (2, 'CRT-2025-002', 12, '{"student_id": "2", "test_id": "CRT-2025-002", "grade_level": 12, "skills": {"logical": 98, "analysis": 79, "problem": 61, "digital_tools": 96}, "artefact_hash": "QmArtefactHash2"}', 'QmArtefactHash2', 'staged');
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES (3, 'CRT-2025-003', 12, '{"student_id": "3", "test_id": "CRT-2025-003", "grade_level": 12, "skills": {"logical": 73, "analysis": 80, "problem": 72, "digital_tools": 63}, "artefact_hash": "QmArtefactHash3"}', 'QmArtefactHash3', 'staged');
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES (4, 'CRT-2025-004', 12, '{"student_id": "4", "test_id": "CRT-2025-004", "grade_level": 12, "skills": {"logical": 92, "analysis": 78, "problem": 63, "digital_tools": 75}, "artefact_hash": "QmArtefactHash4"}', 'QmArtefactHash4', 'staged');
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES (5, 'CRT-2025-005', 12, '{"student_id": "5", "test_id": "CRT-2025-005", "grade_level": 12, "skills": {"logical": 67, "analysis": 94, "problem": 89, "digital_tools": 69}, "artefact_hash": "QmArtefactHash5"}', 'QmArtefactHash5', 'staged');
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES (6, 'CRT-2025-006', 11, '{"student_id": "6", "test_id": "CRT-2025-006", "grade_level": 11, "skills": {"logical": 78, "analysis": 65, "problem": 88, "digital_tools": 90}, "artefact_hash": "QmArtefactHash6"}', 'QmArtefactHash6', 'staged');