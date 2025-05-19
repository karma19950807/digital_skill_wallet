-- Create the database
CREATE DATABASE digital_skill_wallet_db;

USE digital_skill_wallet_db;

-- Create the tables
-- Master Users table (central login)
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('student', 'school') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for School (linked to users)
CREATE TABLE school (
  school_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  school_name VARCHAR(100) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Table for Student (linked to users)
CREATE TABLE student (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  school_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
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

INSERT INTO users (email, password, role) VALUES
('zshs@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'school'),
('brshs@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'school'),
('gss@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'school'),
('ks@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'student'),
('tc@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'student'),
('tt@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'student'),
('pc@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'student'),
('tb@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'student'),
('kms@school.com', '$2b$12$Ti5KxN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxIu6271Uy', 'student');

INSERT INTO school (school_id, user_id, school_name) VALUES 
(1, 1, 'Zillmere State High School'),
(2, 2, 'Bracken Ridge State High School'),
(3, 3, 'Geebung State School');

INSERT INTO student (student_id, user_id, name, school_id) VALUES 
(1, 4, 'Karma Samdrup', 2),
(2, 5, 'Tshewang Chophel', 1),
(3, 6, 'Tshewang Tenzin', 3),
(4, 7, 'Phuntsho Choden', 2),
(5, 8, 'Tandin Bidha', 2),
(6, 9, 'Kala Maya Sanyasi', 3);

INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES 
(1, 'CRT-2025-001', 'Digital Skills', 68, 98, 80, 79, 9, TRUE),
(2, 'CRT-2025-002', 'Digital Skills', 98, 79, 61, 96, 12, TRUE),
(3, 'CRT-2025-003', 'Digital Skills', 73, 80, 72, 63, 12, TRUE),
(4, 'CRT-2025-004', 'Digital Skills', 92, 78, 63, 75, 12, TRUE),
(5, 'CRT-2025-005', 'Digital Skills', 67, 94, 89, 69, 12, TRUE),
(6, 'CRT-2025-006', 'Digital Skills', 78, 65, 88, 90, 11, TRUE);

INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES 
(1, 'CRT-2025-001', 9, '{"student_id": "1", "test_id": "CRT-2025-001", "grade_level": 9, "skills": {"logical": 68, "analysis": 98, "problem": 80, "digital_tools": 79}, "artefact_hash": "QmArtefactHash1"}', 'QmArtefactHash1', 'staged'),
(2, 'CRT-2025-002', 12, '{"student_id": "2", "test_id": "CRT-2025-002", "grade_level": 12, "skills": {"logical": 98, "analysis": 79, "problem": 61, "digital_tools": 96}, "artefact_hash": "QmArtefactHash2"}', 'QmArtefactHash2', 'staged'),
(3, 'CRT-2025-003', 12, '{"student_id": "3", "test_id": "CRT-2025-003", "grade_level": 12, "skills": {"logical": 73, "analysis": 80, "problem": 72, "digital_tools": 63}, "artefact_hash": "QmArtefactHash3"}', 'QmArtefactHash3', 'staged'),
(4, 'CRT-2025-004', 12, '{"student_id": "4", "test_id": "CRT-2025-004", "grade_level": 12, "skills": {"logical": 92, "analysis": 78, "problem": 63, "digital_tools": 75}, "artefact_hash": "QmArtefactHash4"}', 'QmArtefactHash4', 'staged'),
(5, 'CRT-2025-005', 12, '{"student_id": "5", "test_id": "CRT-2025-005", "grade_level": 12, "skills": {"logical": 67, "analysis": 94, "problem": 89, "digital_tools": 69}, "artefact_hash": "QmArtefactHash5"}', 'QmArtefactHash5', 'staged'),
(6, 'CRT-2025-006', 11, '{"student_id": "6", "test_id": "CRT-2025-006", "grade_level": 11, "skills": {"logical": 78, "analysis": 65, "problem": 88, "digital_tools": 90}, "artefact_hash": "QmArtefactHash6"}', 'QmArtefactHash6', 'staged');