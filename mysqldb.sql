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

INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES 
(1, 'CRT-2025-001', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact1"}', 'QmArtefactHash1'),
(2, 'CRT-2025-002', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact2"}', 'QmArtefactHash2'),
(3, 'CRT-2025-003', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact3"}', 'QmArtefactHash3'),
(4, 'CRT-2025-004', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact4"}', 'QmArtefactHash4'),
(5, 'CRT-2025-005', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact5"}', 'QmArtefactHash5'),
(6, 'CRT-2025-006', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact6"}', 'QmArtefactHash6');

INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES 
(1, 'CRT-2025-001', 9, '{"student_id": "1", "test_id": "CRT-2025-001", "grade_level": 9, "skills": {"logical": 68, "analysis": 98, "problem": 80, "digital_tools": 79}, "artefact_hash": "QmArtefactHash1"}', 'QmArtefactHash1', 'staged'),
(2, 'CRT-2025-002', 12, '{"student_id": "2", "test_id": "CRT-2025-002", "grade_level": 12, "skills": {"logical": 98, "analysis": 79, "problem": 61, "digital_tools": 96}, "artefact_hash": "QmArtefactHash2"}', 'QmArtefactHash2', 'staged'),
(3, 'CRT-2025-003', 12, '{"student_id": "3", "test_id": "CRT-2025-003", "grade_level": 12, "skills": {"logical": 73, "analysis": 80, "problem": 72, "digital_tools": 63}, "artefact_hash": "QmArtefactHash3"}', 'QmArtefactHash3', 'staged'),
(4, 'CRT-2025-004', 12, '{"student_id": "4", "test_id": "CRT-2025-004", "grade_level": 12, "skills": {"logical": 92, "analysis": 78, "problem": 63, "digital_tools": 75}, "artefact_hash": "QmArtefactHash4"}', 'QmArtefactHash4', 'staged'),
(5, 'CRT-2025-005', 12, '{"student_id": "5", "test_id": "CRT-2025-005", "grade_level": 12, "skills": {"logical": 67, "analysis": 94, "problem": 89, "digital_tools": 69}, "artefact_hash": "QmArtefactHash5"}', 'QmArtefactHash5', 'staged'),
(6, 'CRT-2025-006', 11, '{"student_id": "6", "test_id": "CRT-2025-006", "grade_level": 11, "skills": {"logical": 78, "analysis": 65, "problem": 88, "digital_tools": 90}, "artefact_hash": "QmArtefactHash6"}', 'QmArtefactHash6', 'staged');

Use digital_skill_wallet_db;

-- Create rubric table
CREATE TABLE rubric (
  rubric_id INT AUTO_INCREMENT PRIMARY KEY,
  range_start DECIMAL(5,2) NOT NULL,
  range_end DECIMAL(5,2) NOT NULL,
  point DECIMAL(4,2) NOT NULL
);

-- Insert general score bands
INSERT INTO rubric (range_start, range_end, point) VALUES
(100, 95, 10.0),
(95, 90, 9.5),
(90, 85, 9.0),
(85, 80, 8.5),
(80, 75, 8.0),
(75, 70, 7.5),
(70, 65, 7.0),
(65, 60, 6.5),
(60, 55, 6.0),
(55, 50, 5.5),
(50, 45, 5.0),
(45, 40, 4.5),
(40, 35, 4.0),
(35, 30, 3.5),
(30, 25, 3.0),
(25, 20, 2.5),
(20, 15, 2.0),
(15, 10, 1.5),
(10, 5, 1.0),
(5, 0, 0.5);

Use digital_Skill_wallet_db;

-- Backup first (optional but recommended)
CREATE TABLE skill_wallet_temp_backup AS SELECT * FROM skill_wallet_temp;

ALTER TABLE skill_wallet_temp
MODIFY status ENUM('staged', 'endorsed', 'submitted', 'committed', 'Verified', 'Not Verified') DEFAULT 'staged';


-- Update all records where verified = true in skillcoin_json → set status = 'Verified'
UPDATE skill_wallet_temp
SET status = 'Verified'
WHERE JSON_EXTRACT(skillcoin_json, '$.verified') = true;

-- Update all other records (or NULL) to 'Not Verified'
UPDATE skill_wallet_temp
SET status = 'Not Verified'
WHERE status NOT IN ('Verified');

TRUNCATE TABLE test_score_staging;
TRUNCATE TABLE skill_wallet_temp;
TRUNCATE TABLE artefact;
TRUNCATE TABLE users;
TRUNCATE TABLE school;
TRUNCATE TABLE student;

SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO school (school_id, user_id, school_name) VALUES
(1, 1, 'Everest High School'),
(2, 2, 'Riverdale Academy'),
(3, 3, 'Lakeside College'),
(4, 4, 'Hilltop Secondary'),
(5, 5, 'Sunrise Institute');

INSERT INTO student (student_id, user_id, name, school_id) VALUES
-- Everest High School (school_id 1)
(1, 6, 'Sonam Dema', 1),
(2, 7, 'Pema Dorji', 1),
(3, 8, 'Tashi Wangchuk', 1),
(4, 9, 'Kinley Wangmo', 1),
(5, 10, 'Jigme Dorji', 1),
(6, 11, 'Sangay Lhamo', 1),
(7, 12, 'Namgay Tshering', 1),
(8, 13, 'Sonam Tenzin', 1),
(9, 14, 'Pema Choden', 1),
(10, 15, 'Kezang Dema', 1),
(11, 16, 'Tshering Dorji', 1),
(12, 17, 'Karma Phuntsho', 1),
(13, 18, 'Dawa Dema', 1),
(14, 19, 'Thinley Wangmo', 1),
(15, 20, 'Tshering Lhamo', 1),
(16, 21, 'Namgay Wangchuk', 1),
(17, 22, 'Sonam Zangmo', 1),
(18, 23, 'Jigme Wangdi', 1),
(19, 24, 'Kinley Dorji', 1),
(20, 25, 'Sangay Dorji', 1),

-- Riverdale Academy (school_id 2)
(21, 26, 'Pema Wangdi', 2),
(22, 27, 'Jigme Choden', 2),
(23, 28, 'Sangay Wangmo', 2),
(24, 29, 'Sonam Dorji', 2),
(25, 30, 'Tashi Zangmo', 2),
(26, 31, 'Namgay Dorji', 2),
(27, 32, 'Pema Lhamo', 2),
(28, 33, 'Kinley Zangmo', 2),
(29, 34, 'Dawa Wangdi', 2),
(30, 35, 'Tshering Wangmo', 2),
(31, 36, 'Jigme Wangchuk', 2),
(32, 37, 'Sangay Choden', 2),
(33, 38, 'Sonam Wangdi', 2),
(34, 39, 'Tashi Dorji', 2),
(35, 40, 'Namgay Wangmo', 2),
(36, 41, 'Pema Wangmo', 2),
(37, 42, 'Kinley Choden', 2),
(38, 43, 'Dawa Dorji', 2),
(39, 44, 'Tshering Dorji', 2),
(40, 45, 'Jigme Lhamo', 2),

-- Lakeside College (school_id 3)
(41, 46, 'Sangay Wangdi', 3),
(42, 47, 'Sonam Choden', 3),
(43, 48, 'Tashi Wangmo', 3),
(44, 49, 'Namgay Wangdi', 3),
(45, 50, 'Pema Dorji', 3),
(46, 51, 'Kinley Wangchuk', 3),
(47, 52, 'Dawa Zangmo', 3),
(48, 53, 'Tshering Choden', 3),
(49, 54, 'Jigme Dorji', 3),
(50, 55, 'Sangay Dorji', 3),
(51, 56, 'Sonam Wangchuk', 3),
(52, 57, 'Tashi Choden', 3),
(53, 58, 'Namgay Dorji', 3),
(54, 59, 'Pema Wangchuk', 3),
(55, 60, 'Kinley Lhamo', 3),
(56, 61, 'Dawa Wangchuk', 3),
(57, 62, 'Tshering Wangchuk', 3),
(58, 63, 'Jigme Wangmo', 3),
(59, 64, 'Sangay Wangchuk', 3),
(60, 65, 'Sonam Zangmo', 3),

-- Hilltop Secondary (school_id 4)
(61, 66, 'Tashi Dorji', 4),
(62, 67, 'Namgay Choden', 4),
(63, 68, 'Pema Lhamo', 4),
(64, 69, 'Kinley Dorji', 4),
(65, 70, 'Dawa Lhamo', 4),
(66, 71, 'Tshering Zangmo', 4),
(67, 72, 'Jigme Wangdi', 4),
(68, 73, 'Sangay Zangmo', 4),
(69, 74, 'Sonam Dorji', 4),
(70, 75, 'Tashi Wangchuk', 4),
(71, 76, 'Namgay Lhamo', 4),
(72, 77, 'Pema Choden', 4),
(73, 78, 'Kinley Wangmo', 4),
(74, 79, 'Dawa Dorji', 4),
(75, 80, 'Tshering Lhamo', 4),
(76, 81, 'Jigme Wangchuk', 4),
(77, 82, 'Sangay Wangmo', 4),
(78, 83, 'Sonam Wangmo', 4),
(79, 84, 'Tashi Wangmo', 4),
(80, 85, 'Namgay Wangmo', 4),

-- Sunrise Institute (school_id 5)
(81, 86, 'Pema Wangmo', 5),
(82, 87, 'Kinley Choden', 5),
(83, 88, 'Dawa Zangmo', 5),
(84, 89, 'Tshering Wangchuk', 5),
(85, 90, 'Jigme Dorji', 5),
(86, 91, 'Sangay Wangdi', 5),
(87, 92, 'Sonam Wangchuk', 5),
(88, 93, 'Tashi Choden', 5),
(89, 94, 'Namgay Wangchuk', 5),
(90, 95, 'Pema Dorji', 5),
(91, 96, 'Kinley Wangchuk', 5),
(92, 97, 'Dawa Wangmo', 5),
(93, 98, 'Tshering Dorji', 5),
(94, 99, 'Jigme Wangchuk', 5),
(95, 100, 'Sangay Choden', 5),
(96, 101, 'Sonam Wangdi', 5),
(97, 102, 'Tshering Dorji', 5),
(98, 103, 'Jigme Wangchuk', 5),
(99, 104, 'Sangay Choden', 5),
(100, 105, 'Sonam Wangdi', 5);


-- Insert school admin users
INSERT INTO users (user_id, email, password, role, created_at) VALUES
(1, 'ehs@school.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'school', '2025-05-15 00:45:03'),
(2, 'ra@school.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'school', '2025-05-15 00:45:03'),
(3, 'lc@school.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'school', '2025-05-15 00:45:03'),
(4, 'hs@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'school', '2025-05-15 00:45:03'),
(5, 'si@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'school', '2025-05-15 00:45:03'),
(6, 'student3@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(7, 'student4@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(8, 'student5@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(9, 'student6@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(10, 'student7@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(11, 'student8@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(12, 'student9@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(13, 'student10@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(14, 'student11@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(15, 'student12@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(16, 'student13@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(17, 'student14@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(18, 'student15@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(19, 'student16@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(20, 'student17@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(21, 'student18@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(22, 'student19@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(23, 'student20@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(24, 'student21@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(25, 'student22@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(26, 'student23@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(27, 'student24@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(28, 'student25@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(29, 'student26@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(30, 'student27@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(31, 'student28@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(32, 'student29@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(33, 'student30@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(34, 'student31@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(35, 'student32@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(36, 'student33@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(37, 'student34@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(38, 'student35@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(39, 'student36@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(40, 'student37@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(41, 'student38@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(42, 'student39@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(43, 'student40@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(44, 'student41@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(45, 'student42@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(46, 'student43@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(47, 'student44@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(48, 'student45@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(49, 'student46@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(50, 'student47@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(51, 'student48@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(52, 'student49@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(53, 'student50@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(54, 'student51@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(55, 'student52@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(56, 'student53@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(57, 'student54@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(58, 'student55@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(59, 'student56@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(60, 'student57@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(61, 'student58@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(62, 'student59@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(63, 'student60@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(64, 'student61@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(65, 'student62@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(66, 'student63@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(67, 'student64@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(68, 'student65@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(69, 'student66@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(70, 'student67@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(71, 'student68@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(72, 'student69@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(73, 'student70@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(74, 'student71@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(75, 'student72@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(76, 'student73@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(77, 'student74@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(78, 'student75@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(79, 'student76@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(80, 'student77@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(81, 'student78@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(82, 'student79@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(83, 'student80@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(84, 'student81@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(85, 'student82@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(86, 'student83@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(87, 'student84@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(88, 'student85@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(89, 'student86@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(90, 'student87@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(91, 'student88@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(92, 'student89@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(93, 'student90@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(94, 'student91@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(95, 'student92@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(96, 'student93@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(97, 'student94@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(98, 'student95@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(99, 'student96@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(100, 'student97@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(101, 'student98@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(102, 'student99@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(103, 'student100@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(104, 'student101@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03'),
(105, 'student102@student.com', '$2b$12$Ti5kN83o7O42dEc9B0hZeNnth/1ImAGk53kSlhSuZdtxU6271Uy', 'student', '2025-05-15 00:45:03');


-- Insert artefact records for 100 students
INSERT INTO artefact (student_id, test_id, artefact_json, artefact_hash) VALUES
(1, 'CRT-2025-001', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact1"}', 'QmArtefactHash1'),
(2, 'CRT-2025-002', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact2"}', 'QmArtefactHash2'),
(3, 'CRT-2025-003', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact3"}', 'QmArtefactHash3'),
(4, 'CRT-2025-004', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact4"}', 'QmArtefactHash4'),
(5, 'CRT-2025-005', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact5"}', 'QmArtefactHash5'),
(6, 'CRT-2025-006', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact6"}', 'QmArtefactHash6'),
(7, 'CRT-2025-007', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact7"}', 'QmArtefactHash7'),
(8, 'CRT-2025-008', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact8"}', 'QmArtefactHash8'),
(9, 'CRT-2025-009', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact9"}', 'QmArtefactHash9'),
(10, 'CRT-2025-010', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact10"}', 'QmArtefactHash10'),
(11, 'CRT-2025-011', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact11"}', 'QmArtefactHash11'),
(12, 'CRT-2025-012', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact12"}', 'QmArtefactHash12'),
(13, 'CRT-2025-013', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact13"}', 'QmArtefactHash13'),
(14, 'CRT-2025-014', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact14"}', 'QmArtefactHash14'),
(15, 'CRT-2025-015', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact15"}', 'QmArtefactHash15'),
(16, 'CRT-2025-016', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact16"}', 'QmArtefactHash16'),
(17, 'CRT-2025-017', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact17"}', 'QmArtefactHash17'),
(18, 'CRT-2025-018', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact18"}', 'QmArtefactHash18'),
(19, 'CRT-2025-019', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact19"}', 'QmArtefactHash19'),
(20, 'CRT-2025-020', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact20"}', 'QmArtefactHash20'),
(21, 'CRT-2025-021', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact21"}', 'QmArtefactHash21'),
(22, 'CRT-2025-022', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact22"}', 'QmArtefactHash22'),
(23, 'CRT-2025-023', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact23"}', 'QmArtefactHash23'),
(24, 'CRT-2025-024', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact24"}', 'QmArtefactHash24'),
(25, 'CRT-2025-025', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact25"}', 'QmArtefactHash25'),
(26, 'CRT-2025-026', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact26"}', 'QmArtefactHash26'),
(27, 'CRT-2025-027', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact27"}', 'QmArtefactHash27'),
(28, 'CRT-2025-028', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact28"}', 'QmArtefactHash28'),
(29, 'CRT-2025-029', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact29"}', 'QmArtefactHash29'),
(30, 'CRT-2025-030', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact30"}', 'QmArtefactHash30'),
(31, 'CRT-2025-031', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact31"}', 'QmArtefactHash31'),
(32, 'CRT-2025-032', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact32"}', 'QmArtefactHash32'),
(33, 'CRT-2025-033', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact33"}', 'QmArtefactHash33'),
(34, 'CRT-2025-034', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact34"}', 'QmArtefactHash34'),
(35, 'CRT-2025-035', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact35"}', 'QmArtefactHash35'),
(36, 'CRT-2025-036', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact36"}', 'QmArtefactHash36'),
(37, 'CRT-2025-037', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact37"}', 'QmArtefactHash37'),
(38, 'CRT-2025-038', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact38"}', 'QmArtefactHash38'),
(39, 'CRT-2025-039', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact39"}', 'QmArtefactHash39'),
(40, 'CRT-2025-040', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact40"}', 'QmArtefactHash40'),
(41, 'CRT-2025-041', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact41"}', 'QmArtefactHash41'),
(42, 'CRT-2025-042', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact42"}', 'QmArtefactHash42'),
(43, 'CRT-2025-043', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact43"}', 'QmArtefactHash43'),
(44, 'CRT-2025-044', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact44"}', 'QmArtefactHash44'),
(45, 'CRT-2025-045', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact45"}', 'QmArtefactHash45'),
(46, 'CRT-2025-046', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact46"}', 'QmArtefactHash46'),
(47, 'CRT-2025-047', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact47"}', 'QmArtefactHash47'),
(48, 'CRT-2025-048', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact48"}', 'QmArtefactHash48'),
(49, 'CRT-2025-049', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact49"}', 'QmArtefactHash49'),
(50, 'CRT-2025-050', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact50"}', 'QmArtefactHash50'),
(51, 'CRT-2025-051', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact51"}', 'QmArtefactHash51'),
(52, 'CRT-2025-052', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact52"}', 'QmArtefactHash52'),
(53, 'CRT-2025-053', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact53"}', 'QmArtefactHash53'),
(54, 'CRT-2025-054', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact54"}', 'QmArtefactHash54'),
(55, 'CRT-2025-055', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact55"}', 'QmArtefactHash55'),
(56, 'CRT-2025-056', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact56"}', 'QmArtefactHash56'),
(57, 'CRT-2025-057', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact57"}', 'QmArtefactHash57'),
(58, 'CRT-2025-058', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact58"}', 'QmArtefactHash58'),
(59, 'CRT-2025-059', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact59"}', 'QmArtefactHash59'),
(60, 'CRT-2025-060', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact60"}', 'QmArtefactHash60'),
(61, 'CRT-2025-061', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact61"}', 'QmArtefactHash61'),
(62, 'CRT-2025-062', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact62"}', 'QmArtefactHash62'),
(63, 'CRT-2025-063', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact63"}', 'QmArtefactHash63'),
(64, 'CRT-2025-064', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact64"}', 'QmArtefactHash64'),
(65, 'CRT-2025-065', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact65"}', 'QmArtefactHash65'),
(66, 'CRT-2025-066', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact66"}', 'QmArtefactHash66'),
(67, 'CRT-2025-067', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact67"}', 'QmArtefactHash67'),
(68, 'CRT-2025-068', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact68"}', 'QmArtefactHash68'),
(69, 'CRT-2025-069', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact69"}', 'QmArtefactHash69'),
(70, 'CRT-2025-070', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact70"}', 'QmArtefactHash70'),
(71, 'CRT-2025-071', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact71"}', 'QmArtefactHash71'),
(72, 'CRT-2025-072', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact72"}', 'QmArtefactHash72'),
(73, 'CRT-2025-073', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact73"}', 'QmArtefactHash73'),
(74, 'CRT-2025-074', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact74"}', 'QmArtefactHash74'),
(75, 'CRT-2025-075', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact75"}', 'QmArtefactHash75'),
(76, 'CRT-2025-076', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact76"}', 'QmArtefactHash76'),
(77, 'CRT-2025-077', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact77"}', 'QmArtefactHash77'),
(78, 'CRT-2025-078', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact78"}', 'QmArtefactHash78'),
(79, 'CRT-2025-079', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact79"}', 'QmArtefactHash79'),
(80, 'CRT-2025-080', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact80"}', 'QmArtefactHash80'),
(81, 'CRT-2025-081', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact81"}', 'QmArtefactHash81'),
(82, 'CRT-2025-082', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact82"}', 'QmArtefactHash82'),
(83, 'CRT-2025-083', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact83"}', 'QmArtefactHash83'),
(84, 'CRT-2025-084', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact84"}', 'QmArtefactHash84'),
(85, 'CRT-2025-085', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact85"}', 'QmArtefactHash85'),
(86, 'CRT-2025-086', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact86"}', 'QmArtefactHash86'),
(87, 'CRT-2025-087', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact87"}', 'QmArtefactHash87'),
(88, 'CRT-2025-088', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact88"}', 'QmArtefactHash88'),
(89, 'CRT-2025-089', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact89"}', 'QmArtefactHash89'),
(90, 'CRT-2025-090', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact90"}', 'QmArtefactHash90'),
(91, 'CRT-2025-091', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact91"}', 'QmArtefactHash91'),
(92, 'CRT-2025-092', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact92"}', 'QmArtefactHash92'),
(93, 'CRT-2025-093', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact93"}', 'QmArtefactHash93'),
(94, 'CRT-2025-094', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact94"}', 'QmArtefactHash94'),
(95, 'CRT-2025-095', '{"project": "Online Quiz Submission", "submitted": true, "link": "https://example.com/artefact95"}', 'QmArtefactHash95'),
(96, 'CRT-2025-096', '{"project": "Practical Task", "submitted": true, "link": "https://example.com/artefact96"}', 'QmArtefactHash96'),
(97, 'CRT-2025-097', '{"project": "Final Presentation", "submitted": true, "link": "https://example.com/artefact97"}', 'QmArtefactHash97'),
(98, 'CRT-2025-098', '{"project": "Report PDF", "submitted": true, "link": "https://example.com/artefact98"}', 'QmArtefactHash98'),
(99, 'CRT-2025-099', '{"project": "Prototype Demo", "submitted": true, "link": "https://example.com/artefact99"}', 'QmArtefactHash99'),
(100, 'CRT-2025-100', '{"project": "Skill Showcase", "submitted": true, "link": "https://example.com/artefact100"}', 'QmArtefactHash100');




-- Insert skill_wallet_temp records for 100 students
INSERT INTO skill_wallet_temp (student_id, test_id, grade_level, skillcoin_json, artefact_hash, status) VALUES 
(1, 'CRT-2025-001', 11, '{"student_id": "1", "test_id": "CRT-2025-001", "grade_level": 11, "skills": {"logical": 82, "analysis": 95, "problem": 94, "digital_tools": 86}, "artefact_hash": "QmArtefactHash1"}', 'QmArtefactHash1', 'Verified'),
(2, 'CRT-2025-002', 11, '{"student_id": "2", "test_id": "CRT-2025-002", "grade_level": 11, "skills": {"logical": 64, "analysis": 78, "problem": 60, "digital_tools": 95}, "artefact_hash": "QmArtefactHash2"}', 'QmArtefactHash2', 'Verified'),
(3, 'CRT-2025-003', 9, '{"student_id": "3", "test_id": "CRT-2025-003", "grade_level": 9, "skills": {"logical": 95, "analysis": 97, "problem": 73, "digital_tools": 78}, "artefact_hash": "QmArtefactHash3"}', 'QmArtefactHash3', 'Verified'),
(4, 'CRT-2025-004', 9, '{"student_id": "4", "test_id": "CRT-2025-004", "grade_level": 9, "skills": {"logical": 87, "analysis": 70, "problem": 80, "digital_tools": 80}, "artefact_hash": "QmArtefactHash4"}', 'QmArtefactHash4', 'Verified'),
(5, 'CRT-2025-005', 9, '{"student_id": "5", "test_id": "CRT-2025-005", "grade_level": 9, "skills": {"logical": 95, "analysis": 97, "problem": 71, "digital_tools": 63}, "artefact_hash": "QmArtefactHash5"}', 'QmArtefactHash5', 'Verified'),
(6, 'CRT-2025-006', 9, '{"student_id": "6", "test_id": "CRT-2025-006", "grade_level": 9, "skills": {"logical": 83, "analysis": 91, "problem": 99, "digital_tools": 72}, "artefact_hash": "QmArtefactHash6"}', 'QmArtefactHash6', 'Verified'),
(7, 'CRT-2025-007', 10, '{"student_id": "7", "test_id": "CRT-2025-007", "grade_level": 10, "skills": {"logical": 82, "analysis": 69, "problem": 85, "digital_tools": 100}, "artefact_hash": "QmArtefactHash7"}', 'QmArtefactHash7', 'Verified'),
(8, 'CRT-2025-008', 9, '{"student_id": "8", "test_id": "CRT-2025-008", "grade_level": 9, "skills": {"logical": 87, "analysis": 89, "problem": 76, "digital_tools": 87}, "artefact_hash": "QmArtefactHash8"}', 'QmArtefactHash8', 'Verified'),
(9, 'CRT-2025-009', 9, '{"student_id": "9", "test_id": "CRT-2025-009", "grade_level": 9, "skills": {"logical": 67, "analysis": 60, "problem": 67, "digital_tools": 77}, "artefact_hash": "QmArtefactHash9"}', 'QmArtefactHash9', 'Verified'),
(10, 'CRT-2025-010', 9, '{"student_id": "10", "test_id": "CRT-2025-010", "grade_level": 9, "skills": {"logical": 75, "analysis": 86, "problem": 93, "digital_tools": 65}, "artefact_hash": "QmArtefactHash10"}', 'QmArtefactHash10', 'Verified'),
(11, 'CRT-2025-011', 11, '{"student_id": "11", "test_id": "CRT-2025-011", "grade_level": 11, "skills": {"logical": 67, "analysis": 87, "problem": 99, "digital_tools": 92}, "artefact_hash": "QmArtefactHash11"}', 'QmArtefactHash11', 'Verified'),
(12, 'CRT-2025-012', 11, '{"student_id": "12", "test_id": "CRT-2025-012", "grade_level": 11, "skills": {"logical": 65, "analysis": 82, "problem": 74, "digital_tools": 78}, "artefact_hash": "QmArtefactHash12"}', 'QmArtefactHash12', 'Verified'),
(13, 'CRT-2025-013', 11, '{"student_id": "13", "test_id": "CRT-2025-013", "grade_level": 11, "skills": {"logical": 83, "analysis": 63, "problem": 90, "digital_tools": 72}, "artefact_hash": "QmArtefactHash13"}', 'QmArtefactHash13', 'Verified'),
(14, 'CRT-2025-014', 10, '{"student_id": "14", "test_id": "CRT-2025-014", "grade_level": 10, "skills": {"logical": 71, "analysis": 66, "problem": 100, "digital_tools": 76}, "artefact_hash": "QmArtefactHash14"}', 'QmArtefactHash14', 'Verified'),
(15, 'CRT-2025-015', 11, '{"student_id": "15", "test_id": "CRT-2025-015", "grade_level": 11, "skills": {"logical": 60, "analysis": 77, "problem": 93, "digital_tools": 73}, "artefact_hash": "QmArtefactHash15"}', 'QmArtefactHash15', 'Verified'),
(16, 'CRT-2025-016', 10, '{"student_id": "16", "test_id": "CRT-2025-016", "grade_level": 10, "skills": {"logical": 62, "analysis": 61, "problem": 99, "digital_tools": 71}, "artefact_hash": "QmArtefactHash16"}', 'QmArtefactHash16', 'Verified'),
(17, 'CRT-2025-017', 12, '{"student_id": "17", "test_id": "CRT-2025-017", "grade_level": 12, "skills": {"logical": 87, "analysis": 65, "problem": 64, "digital_tools": 89}, "artefact_hash": "QmArtefactHash17"}', 'QmArtefactHash17', 'Verified'),
(18, 'CRT-2025-018', 10, '{"student_id": "18", "test_id": "CRT-2025-018", "grade_level": 10, "skills": {"logical": 66, "analysis": 79, "problem": 75, "digital_tools": 88}, "artefact_hash": "QmArtefactHash18"}', 'QmArtefactHash18', 'Verified'),
(19, 'CRT-2025-019', 11, '{"student_id": "19", "test_id": "CRT-2025-019", "grade_level": 11, "skills": {"logical": 73, "analysis": 96, "problem": 95, "digital_tools": 80}, "artefact_hash": "QmArtefactHash19"}', 'QmArtefactHash19', 'Not verified'),
(20, 'CRT-2025-020', 9, '{"student_id": "20", "test_id": "CRT-2025-020", "grade_level": 9, "skills": {"logical": 89, "analysis": 66, "problem": 88, "digital_tools": 69}, "artefact_hash": "QmArtefactHash20"}', 'QmArtefactHash20', 'Verified'),
(21, 'CRT-2025-021', 9, '{"student_id": "21", "test_id": "CRT-2025-021", "grade_level": 9, "skills": {"logical": 63, "analysis": 68, "problem": 87, "digital_tools": 75}, "artefact_hash": "QmArtefactHash21"}', 'QmArtefactHash21', 'Verified'),
(22, 'CRT-2025-022', 9, '{"student_id": "22", "test_id": "CRT-2025-022", "grade_level": 9, "skills": {"logical": 78, "analysis": 87, "problem": 76, "digital_tools": 70}, "artefact_hash": "QmArtefactHash22"}', 'QmArtefactHash22', 'Verified'),
(23, 'CRT-2025-023', 12, '{"student_id": "23", "test_id": "CRT-2025-023", "grade_level": 12, "skills": {"logical": 78, "analysis": 72, "problem": 67, "digital_tools": 89}, "artefact_hash": "QmArtefactHash23"}', 'QmArtefactHash23', 'Verified'),
(24, 'CRT-2025-024', 11, '{"student_id": "24", "test_id": "CRT-2025-024", "grade_level": 11, "skills": {"logical": 89, "analysis": 78, "problem": 79, "digital_tools": 67}, "artefact_hash": "QmArtefactHash24"}', 'QmArtefactHash24', 'Verified'),
(25, 'CRT-2025-025', 10, '{"student_id": "25", "test_id": "CRT-2025-025", "grade_level": 10, "skills": {"logical": 72, "analysis": 65, "problem": 78, "digital_tools": 86}, "artefact_hash": "QmArtefactHash25"}', 'QmArtefactHash25', 'Verified'),
(26, 'CRT-2025-026', 11, '{"student_id": "26", "test_id": "CRT-2025-026", "grade_level": 11, "skills": {"logical": 79, "analysis": 64, "problem": 87, "digital_tools": 86}, "artefact_hash": "QmArtefactHash26"}', 'QmArtefactHash26', 'Verified'),
(27, 'CRT-2025-027', 11, '{"student_id": "27", "test_id": "CRT-2025-027", "grade_level": 11, "skills": {"logical": 75, "analysis": 78, "problem": 62, "digital_tools": 83}, "artefact_hash": "QmArtefactHash27"}', 'QmArtefactHash27', 'Verified'),
(28, 'CRT-2025-028', 10, '{"student_id": "28", "test_id": "CRT-2025-028", "grade_level": 10, "skills": {"logical": 78, "analysis": 63, "problem": 67, "digital_tools": 80}, "artefact_hash": "QmArtefactHash28"}', 'QmArtefactHash28', 'Verified'),
(29, 'CRT-2025-029', 11, '{"student_id": "29", "test_id": "CRT-2025-029", "grade_level": 11, "skills": {"logical": 75, "analysis": 78, "problem": 95, "digital_tools": 71}, "artefact_hash": "QmArtefactHash29"}', 'QmArtefactHash29', 'Verified'),
(30, 'CRT-2025-030', 9, '{"student_id": "30", "test_id": "CRT-2025-030", "grade_level": 9, "skills": {"logical": 66, "analysis": 76, "problem": 86, "digital_tools": 80}, "artefact_hash": "QmArtefactHash30"}', 'QmArtefactHash30', 'Verified'),
(31, 'CRT-2025-031', 11, '{"student_id": "31", "test_id": "CRT-2025-031", "grade_level": 11, "skills": {"logical": 94, "analysis": 80, "problem": 70, "digital_tools": 78}, "artefact_hash": "QmArtefactHash31"}', 'QmArtefactHash31', 'Verified'),
(32, 'CRT-2025-032', 11, '{"student_id": "32", "test_id": "CRT-2025-032", "grade_level": 11, "skills": {"logical": 87, "analysis": 100, "problem": 98, "digital_tools": 80}, "artefact_hash": "QmArtefactHash32"}', 'QmArtefactHash32', 'Verified'),
(33, 'CRT-2025-033', 12, '{"student_id": "33", "test_id": "CRT-2025-033", "grade_level": 12, "skills": {"logical": 99, "analysis": 82, "problem": 63, "digital_tools": 82}, "artefact_hash": "QmArtefactHash33"}', 'QmArtefactHash33', 'Verified'),
(34, 'CRT-2025-034', 10, '{"student_id": "34", "test_id": "CRT-2025-034", "grade_level": 10, "skills": {"logical": 61, "analysis": 91, "problem": 82, "digital_tools": 74}, "artefact_hash": "QmArtefactHash34"}', 'QmArtefactHash34', 'Verified'),
(35, 'CRT-2025-035', 9, '{"student_id": "35", "test_id": "CRT-2025-035", "grade_level": 9, "skills": {"logical": 100, "analysis": 81, "problem": 98, "digital_tools": 90}, "artefact_hash": "QmArtefactHash35"}', 'QmArtefactHash35', 'Verified'),
(36, 'CRT-2025-036', 12, '{"student_id": "36", "test_id": "CRT-2025-036", "grade_level": 12, "skills": {"logical": 75, "analysis": 93, "problem": 76, "digital_tools": 93}, "artefact_hash": "QmArtefactHash36"}', 'QmArtefactHash36', 'Verified'),
(37, 'CRT-2025-037', 10, '{"student_id": "37", "test_id": "CRT-2025-037", "grade_level": 10, "skills": {"logical": 62, "analysis": 60, "problem": 68, "digital_tools": 93}, "artefact_hash": "QmArtefactHash37"}', 'QmArtefactHash37', 'Verified'),
(38, 'CRT-2025-038', 12, '{"student_id": "38", "test_id": "CRT-2025-038", "grade_level": 12, "skills": {"logical": 87, "analysis": 69, "problem": 95, "digital_tools": 88}, "artefact_hash": "QmArtefactHash38"}', 'QmArtefactHash38', 'Verified'),
(39, 'CRT-2025-039', 10, '{"student_id": "39", "test_id": "CRT-2025-039", "grade_level": 10, "skills": {"logical": 76, "analysis": 88, "problem": 81, "digital_tools": 94}, "artefact_hash": "QmArtefactHash39"}', 'QmArtefactHash39', 'Verified'),
(40, 'CRT-2025-040', 12, '{"student_id": "40", "test_id": "CRT-2025-040", "grade_level": 12, "skills": {"logical": 69, "analysis": 77, "problem": 93, "digital_tools": 71}, "artefact_hash": "QmArtefactHash40"}', 'QmArtefactHash40', 'Verified'),
(41, 'CRT-2025-041', 11, '{"student_id": "41", "test_id": "CRT-2025-041", "grade_level": 11, "skills": {"logical": 60, "analysis": 74, "problem": 84, "digital_tools": 79}, "artefact_hash": "QmArtefactHash41"}', 'QmArtefactHash41', 'Not verified'),
(42, 'CRT-2025-042', 12, '{"student_id": "42", "test_id": "CRT-2025-042", "grade_level": 12, "skills": {"logical": 65, "analysis": 92, "problem": 94, "digital_tools": 100}, "artefact_hash": "QmArtefactHash42"}', 'QmArtefactHash42', 'Verified'),
(43, 'CRT-2025-043', 12, '{"student_id": "43", "test_id": "CRT-2025-043", "grade_level": 12, "skills": {"logical": 78, "analysis": 75, "problem": 87, "digital_tools": 93}, "artefact_hash": "QmArtefactHash43"}', 'QmArtefactHash43', 'Verified'),
(44, 'CRT-2025-044', 10, '{"student_id": "44", "test_id": "CRT-2025-044", "grade_level": 10, "skills": {"logical": 60, "analysis": 84, "problem": 63, "digital_tools": 66}, "artefact_hash": "QmArtefactHash44"}', 'QmArtefactHash44', 'Verified'),
(45, 'CRT-2025-045', 9, '{"student_id": "45", "test_id": "CRT-2025-045", "grade_level": 9, "skills": {"logical": 80, "analysis": 92, "problem": 82, "digital_tools": 61}, "artefact_hash": "QmArtefactHash45"}', 'QmArtefactHash45', 'Verified'),
(46, 'CRT-2025-046', 9, '{"student_id": "46", "test_id": "CRT-2025-046", "grade_level": 9, "skills": {"logical": 60, "analysis": 87, "problem": 100, "digital_tools": 94}, "artefact_hash": "QmArtefactHash46"}', 'QmArtefactHash46', 'Verified'),
(47, 'CRT-2025-047', 11, '{"student_id": "47", "test_id": "CRT-2025-047", "grade_level": 11, "skills": {"logical": 77, "analysis": 72, "problem": 89, "digital_tools": 78}, "artefact_hash": "QmArtefactHash47"}', 'QmArtefactHash47', 'Verified'),
(48, 'CRT-2025-048', 9, '{"student_id": "48", "test_id": "CRT-2025-048", "grade_level": 9, "skills": {"logical": 86, "analysis": 87, "problem": 82, "digital_tools": 71}, "artefact_hash": "QmArtefactHash48"}', 'QmArtefactHash48', 'Verified'),
(49, 'CRT-2025-049', 12, '{"student_id": "49", "test_id": "CRT-2025-049", "grade_level": 12, "skills": {"logical": 64, "analysis": 60, "problem": 99, "digital_tools": 87}, "artefact_hash": "QmArtefactHash49"}', 'QmArtefactHash49', 'Verified'),
(50, 'CRT-2025-050', 11, '{"student_id": "50", "test_id": "CRT-2025-050", "grade_level": 11, "skills": {"logical": 95, "analysis": 92, "problem": 97, "digital_tools": 72}, "artefact_hash": "QmArtefactHash50"}', 'QmArtefactHash50', 'Verified'),
(51, 'CRT-2025-051', 10, '{"student_id": "51", "test_id": "CRT-2025-051", "grade_level": 10, "skills": {"logical": 95, "analysis": 87, "problem": 69, "digital_tools": 85}, "artefact_hash": "QmArtefactHash51"}', 'QmArtefactHash51', 'Verified'),
(52, 'CRT-2025-052', 10, '{"student_id": "52", "test_id": "CRT-2025-052", "grade_level": 10, "skills": {"logical": 91, "analysis": 71, "problem": 88, "digital_tools": 73}, "artefact_hash": "QmArtefactHash52"}', 'QmArtefactHash52', 'Verified'),
(53, 'CRT-2025-053', 12, '{"student_id": "53", "test_id": "CRT-2025-053", "grade_level": 12, "skills": {"logical": 88, "analysis": 64, "problem": 73, "digital_tools": 83}, "artefact_hash": "QmArtefactHash53"}', 'QmArtefactHash53', 'Verified'),
(54, 'CRT-2025-054', 10, '{"student_id": "54", "test_id": "CRT-2025-054", "grade_level": 10, "skills": {"logical": 84, "analysis": 97, "problem": 61, "digital_tools": 88}, "artefact_hash": "QmArtefactHash54"}', 'QmArtefactHash54', 'Verified'),
(55, 'CRT-2025-055', 12, '{"student_id": "55", "test_id": "CRT-2025-055", "grade_level": 12, "skills": {"logical": 69, "analysis": 76, "problem": 76, "digital_tools": 62}, "artefact_hash": "QmArtefactHash55"}', 'QmArtefactHash55', 'Verified'),
(56, 'CRT-2025-056', 11, '{"student_id": "56", "test_id": "CRT-2025-056", "grade_level": 11, "skills": {"logical": 88, "analysis": 82, "problem": 73, "digital_tools": 76}, "artefact_hash": "QmArtefactHash56"}', 'QmArtefactHash56', 'Verified'),
(57, 'CRT-2025-057', 10, '{"student_id": "57", "test_id": "CRT-2025-057", "grade_level": 10, "skills": {"logical": 76, "analysis": 80, "problem": 77, "digital_tools": 98}, "artefact_hash": "QmArtefactHash57"}', 'QmArtefactHash57', 'Verified'),
(58, 'CRT-2025-058', 12, '{"student_id": "58", "test_id": "CRT-2025-058", "grade_level": 12, "skills": {"logical": 74, "analysis": 67, "problem": 91, "digital_tools": 65}, "artefact_hash": "QmArtefactHash58"}', 'QmArtefactHash58', 'Verified'),
(59, 'CRT-2025-059', 11, '{"student_id": "59", "test_id": "CRT-2025-059", "grade_level": 11, "skills": {"logical": 78, "analysis": 99, "problem": 87, "digital_tools": 91}, "artefact_hash": "QmArtefactHash59"}', 'QmArtefactHash59', 'Verified'),
(60, 'CRT-2025-060', 9, '{"student_id": "60", "test_id": "CRT-2025-060", "grade_level": 9, "skills": {"logical": 83, "analysis": 95, "problem": 97, "digital_tools": 71}, "artefact_hash": "QmArtefactHash60"}', 'QmArtefactHash60', 'Verified'),
(61, 'CRT-2025-061', 12, '{"student_id": "61", "test_id": "CRT-2025-061", "grade_level": 12, "skills": {"logical": 67, "analysis": 89, "problem": 84, "digital_tools": 94}, "artefact_hash": "QmArtefactHash61"}', 'QmArtefactHash61', 'Verified'),
(62, 'CRT-2025-062', 9, '{"student_id": "62", "test_id": "CRT-2025-062", "grade_level": 9, "skills": {"logical": 77, "analysis": 76, "problem": 86, "digital_tools": 62}, "artefact_hash": "QmArtefactHash62"}', 'QmArtefactHash62', 'Verified'),
(63, 'CRT-2025-063', 10, '{"student_id": "63", "test_id": "CRT-2025-063", "grade_level": 10, "skills": {"logical": 91, "analysis": 75, "problem": 61, "digital_tools": 72}, "artefact_hash": "QmArtefactHash63"}', 'QmArtefactHash63', 'Verified'),
(64, 'CRT-2025-064', 11, '{"student_id": "64", "test_id": "CRT-2025-064", "grade_level": 11, "skills": {"logical": 66, "analysis": 89, "problem": 72, "digital_tools": 87}, "artefact_hash": "QmArtefactHash64"}', 'QmArtefactHash64', 'Verified'),
(65, 'CRT-2025-065', 9, '{"student_id": "65", "test_id": "CRT-2025-065", "grade_level": 9, "skills": {"logical": 98, "analysis": 65, "problem": 96, "digital_tools": 67}, "artefact_hash": "QmArtefactHash65"}', 'QmArtefactHash65', 'Verified'),
(66, 'CRT-2025-066', 12, '{"student_id": "66", "test_id": "CRT-2025-066", "grade_level": 12, "skills": {"logical": 83, "analysis": 92, "problem": 95, "digital_tools": 88}, "artefact_hash": "QmArtefactHash66"}', 'QmArtefactHash66', 'Verified'),
(67, 'CRT-2025-067', 9, '{"student_id": "67", "test_id": "CRT-2025-067", "grade_level": 9, "skills": {"logical": 92, "analysis": 70, "problem": 61, "digital_tools": 98}, "artefact_hash": "QmArtefactHash67"}', 'QmArtefactHash67', 'Verified'),
(68, 'CRT-2025-068', 9, '{"student_id": "68", "test_id": "CRT-2025-068", "grade_level": 9, "skills": {"logical": 78, "analysis": 79, "problem": 79, "digital_tools": 62}, "artefact_hash": "QmArtefactHash68"}', 'QmArtefactHash68', 'Verified'),
(69, 'CRT-2025-069', 12, '{"student_id": "69", "test_id": "CRT-2025-069", "grade_level": 12, "skills": {"logical": 100, "analysis": 97, "problem": 81, "digital_tools": 64}, "artefact_hash": "QmArtefactHash69"}', 'QmArtefactHash69', 'Verified'),
(70, 'CRT-2025-070', 11, '{"student_id": "70", "test_id": "CRT-2025-070", "grade_level": 11, "skills": {"logical": 91, "analysis": 72, "problem": 64, "digital_tools": 67}, "artefact_hash": "QmArtefactHash70"}', 'QmArtefactHash70', 'Verified'),
(71, 'CRT-2025-071', 9, '{"student_id": "71", "test_id": "CRT-2025-071", "grade_level": 9, "skills": {"logical": 81, "analysis": 63, "problem": 94, "digital_tools": 64}, "artefact_hash": "QmArtefactHash71"}', 'QmArtefactHash71', 'Verified'),
(72, 'CRT-2025-072', 10, '{"student_id": "72", "test_id": "CRT-2025-072", "grade_level": 10, "skills": {"logical": 82, "analysis": 73, "problem": 87, "digital_tools": 98}, "artefact_hash": "QmArtefactHash72"}', 'QmArtefactHash72', 'Verified'),
(73, 'CRT-2025-073', 12, '{"student_id": "73", "test_id": "CRT-2025-073", "grade_level": 12, "skills": {"logical": 76, "analysis": 93, "problem": 96, "digital_tools": 69}, "artefact_hash": "QmArtefactHash73"}', 'QmArtefactHash73', 'Verified'),
(74, 'CRT-2025-074', 10, '{"student_id": "74", "test_id": "CRT-2025-074", "grade_level": 10, "skills": {"logical": 94, "analysis": 93, "problem": 98, "digital_tools": 86}, "artefact_hash": "QmArtefactHash74"}', 'QmArtefactHash74', 'Verified'),
(75, 'CRT-2025-075', 10, '{"student_id": "75", "test_id": "CRT-2025-075", "grade_level": 10, "skills": {"logical": 89, "analysis": 97, "problem": 90, "digital_tools": 89}, "artefact_hash": "QmArtefactHash75"}', 'QmArtefactHash75', 'Verified'),
(76, 'CRT-2025-076', 12, '{"student_id": "76", "test_id": "CRT-2025-076", "grade_level": 12, "skills": {"logical": 80, "analysis": 81, "problem": 98, "digital_tools": 77}, "artefact_hash": "QmArtefactHash76"}', 'QmArtefactHash76', 'Verified'),
(77, 'CRT-2025-077', 12, '{"student_id": "77", "test_id": "CRT-2025-077", "grade_level": 12, "skills": {"logical": 75, "analysis": 87, "problem": 62, "digital_tools": 83}, "artefact_hash": "QmArtefactHash77"}', 'QmArtefactHash77', 'Verified'),
(78, 'CRT-2025-078', 12, '{"student_id": "78", "test_id": "CRT-2025-078", "grade_level": 12, "skills": {"logical": 74, "analysis": 90, "problem": 77, "digital_tools": 76}, "artefact_hash": "QmArtefactHash78"}', 'QmArtefactHash78', 'Verified'),
(79, 'CRT-2025-079', 10, '{"student_id": "79", "test_id": "CRT-2025-079", "grade_level": 10, "skills": {"logical": 83, "analysis": 72, "problem": 95, "digital_tools": 95}, "artefact_hash": "QmArtefactHash79"}', 'QmArtefactHash79', 'Verified'),
(80, 'CRT-2025-080', 9, '{"student_id": "80", "test_id": "CRT-2025-080", "grade_level": 9, "skills": {"logical": 62, "analysis": 60, "problem": 89, "digital_tools": 96}, "artefact_hash": "QmArtefactHash80"}', 'QmArtefactHash80', 'Verified'),
(81, 'CRT-2025-081', 10, '{"student_id": "81", "test_id": "CRT-2025-081", "grade_level": 10, "skills": {"logical": 79, "analysis": 74, "problem": 66, "digital_tools": 73}, "artefact_hash": "QmArtefactHash81"}', 'QmArtefactHash81', 'Verified'),
(82, 'CRT-2025-082', 12, '{"student_id": "82", "test_id": "CRT-2025-082", "grade_level": 12, "skills": {"logical": 84, "analysis": 96, "problem": 90, "digital_tools": 66}, "artefact_hash": "QmArtefactHash82"}', 'QmArtefactHash82', 'Verified'),
(83, 'CRT-2025-083', 10, '{"student_id": "83", "test_id": "CRT-2025-083", "grade_level": 10, "skills": {"logical": 65, "analysis": 90, "problem": 63, "digital_tools": 95}, "artefact_hash": "QmArtefactHash83"}', 'QmArtefactHash83', 'Verified'),
(84, 'CRT-2025-084', 9, '{"student_id": "84", "test_id": "CRT-2025-084", "grade_level": 9, "skills": {"logical": 63, "analysis": 63, "problem": 98, "digital_tools": 89}, "artefact_hash": "QmArtefactHash84"}', 'QmArtefactHash84', 'Verified'),
(85, 'CRT-2025-085', 9, '{"student_id": "85", "test_id": "CRT-2025-085", "grade_level": 9, "skills": {"logical": 73, "analysis": 61, "problem": 81, "digital_tools": 82}, "artefact_hash": "QmArtefactHash85"}', 'QmArtefactHash85', 'Verified'),
(86, 'CRT-2025-086', 12, '{"student_id": "86", "test_id": "CRT-2025-086", "grade_level": 12, "skills": {"logical": 83, "analysis": 69, "problem": 60, "digital_tools": 77}, "artefact_hash": "QmArtefactHash86"}', 'QmArtefactHash86', 'Verified'),
(87, 'CRT-2025-087', 12, '{"student_id": "87", "test_id": "CRT-2025-087", "grade_level": 12, "skills": {"logical": 79, "analysis": 70, "problem": 88, "digital_tools": 99}, "artefact_hash": "QmArtefactHash87"}', 'QmArtefactHash87', 'Verified'),
(88, 'CRT-2025-088', 9, '{"student_id": "88", "test_id": "CRT-2025-088", "grade_level": 9, "skills": {"logical": 65, "analysis": 83, "problem": 77, "digital_tools": 68}, "artefact_hash": "QmArtefactHash88"}', 'QmArtefactHash88', 'Verified'),
(89, 'CRT-2025-089', 11, '{"student_id": "89", "test_id": "CRT-2025-089", "grade_level": 11, "skills": {"logical": 99, "analysis": 66, "problem": 75, "digital_tools": 62}, "artefact_hash": "QmArtefactHash89"}', 'QmArtefactHash89', 'Verified'),
(90, 'CRT-2025-090', 12, '{"student_id": "90", "test_id": "CRT-2025-090", "grade_level": 12, "skills": {"logical": 76, "analysis": 79, "problem": 71, "digital_tools": 89}, "artefact_hash": "QmArtefactHash90"}', 'QmArtefactHash90', 'Verified'),
(91, 'CRT-2025-091', 10, '{"student_id": "91", "test_id": "CRT-2025-091", "grade_level": 10, "skills": {"logical": 94, "analysis": 65, "problem": 83, "digital_tools": 77}, "artefact_hash": "QmArtefactHash91"}', 'QmArtefactHash91', 'Verified'),
(92, 'CRT-2025-092', 12, '{"student_id": "92", "test_id": "CRT-2025-092", "grade_level": 12, "skills": {"logical": 70, "analysis": 73, "problem": 87, "digital_tools": 82}, "artefact_hash": "QmArtefactHash92"}', 'QmArtefactHash92', 'Verified'),
(93, 'CRT-2025-093', 9, '{"student_id": "93", "test_id": "CRT-2025-093", "grade_level": 9, "skills": {"logical": 92, "analysis": 98, "problem": 86, "digital_tools": 71}, "artefact_hash": "QmArtefactHash93"}', 'QmArtefactHash93', 'Verified'),
(94, 'CRT-2025-094', 12, '{"student_id": "94", "test_id": "CRT-2025-094", "grade_level": 12, "skills": {"logical": 75, "analysis": 96, "problem": 90, "digital_tools": 89}, "artefact_hash": "QmArtefactHash94"}', 'QmArtefactHash94', 'Verified'),
(95, 'CRT-2025-095', 11, '{"student_id": "95", "test_id": "CRT-2025-095", "grade_level": 11, "skills": {"logical": 65, "analysis": 81, "problem": 96, "digital_tools": 89}, "artefact_hash": "QmArtefactHash95"}', 'QmArtefactHash95', 'Verified'),
(96, 'CRT-2025-096', 9, '{"student_id": "96", "test_id": "CRT-2025-096", "grade_level": 9, "skills": {"logical": 75, "analysis": 76, "problem": 71, "digital_tools": 62}, "artefact_hash": "QmArtefactHash96"}', 'QmArtefactHash96', 'Verified'),
(97, 'CRT-2025-097', 9, '{"student_id": "97", "test_id": "CRT-2025-097", "grade_level": 9, "skills": {"logical": 62, "analysis": 87, "problem": 81, "digital_tools": 78}, "artefact_hash": "QmArtefactHash97"}', 'QmArtefactHash97', 'Verified'),
(98, 'CRT-2025-098', 9, '{"student_id": "98", "test_id": "CRT-2025-098", "grade_level": 9, "skills": {"logical": 95, "analysis": 67, "problem": 61, "digital_tools": 72}, "artefact_hash": "QmArtefactHash98"}', 'QmArtefactHash98', 'Not verified'),
(99, 'CRT-2025-099', 10, '{"student_id": "99", "test_id": "CRT-2025-099", "grade_level": 10, "skills": {"logical": 97, "analysis": 69, "problem": 79, "digital_tools": 95}, "artefact_hash": "QmArtefactHash99"}', 'QmArtefactHash99', 'Verified'),
(100, 'CRT-2025-100', 11, '{"student_id": "100", "test_id": "CRT-2025-100", "grade_level": 11, "skills": {"logical": 75, "analysis": 72, "problem": 86, "digital_tools": 100}, "artefact_hash": "QmArtefactHash100"}', 'QmArtefactHash100', 'Verified');

-- Insert test_score_staging records for 100 students
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (1, 'CRT-2025-001', 'Digital Skills', 83, 64, 69, 60, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (2, 'CRT-2025-002', 'Digital Skills', 84, 73, 83, 63, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (3, 'CRT-2025-003', 'Digital Skills', 83, 94, 74, 94, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (4, 'CRT-2025-004', 'Digital Skills', 100, 75, 90, 70, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (5, 'CRT-2025-005', 'Digital Skills', 74, 81, 65, 94, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (6, 'CRT-2025-006', 'Digital Skills', 75, 79, 95, 62, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (7, 'CRT-2025-007', 'Digital Skills', 93, 72, 95, 84, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (8, 'CRT-2025-008', 'Digital Skills', 78, 89, 80, 62, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (9, 'CRT-2025-009', 'Digital Skills', 93, 97, 87, 97, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (10, 'CRT-2025-010', 'Digital Skills', 74, 80, 90, 60, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (11, 'CRT-2025-011', 'Digital Skills', 83, 81, 64, 100, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (12, 'CRT-2025-012', 'Digital Skills', 93, 96, 66, 88, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (13, 'CRT-2025-013', 'Digital Skills', 83, 88, 64, 98, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (14, 'CRT-2025-014', 'Digital Skills', 96, 95, 93, 88, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (15, 'CRT-2025-015', 'Digital Skills', 68, 79, 100, 65, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (16, 'CRT-2025-016', 'Digital Skills', 66, 94, 72, 94, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (17, 'CRT-2025-017', 'Digital Skills', 77, 81, 96, 93, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (18, 'CRT-2025-018', 'Digital Skills', 96, 94, 67, 68, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (19, 'CRT-2025-019', 'Digital Skills', 81, 85, 89, 70, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (20, 'CRT-2025-020', 'Digital Skills', 94, 60, 90, 93, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (21, 'CRT-2025-021', 'Digital Skills', 79, 64, 75, 75, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (22, 'CRT-2025-022', 'Digital Skills', 77, 71, 97, 70, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (23, 'CRT-2025-023', 'Digital Skills', 80, 74, 65, 79, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (24, 'CRT-2025-024', 'Digital Skills', 89, 80, 88, 75, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (25, 'CRT-2025-025', 'Digital Skills', 97, 96, 92, 73, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (26, 'CRT-2025-026', 'Digital Skills', 87, 97, 69, 69, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (27, 'CRT-2025-027', 'Digital Skills', 75, 61, 94, 81, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (28, 'CRT-2025-028', 'Digital Skills', 87, 60, 74, 62, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (29, 'CRT-2025-029', 'Digital Skills', 82, 85, 99, 83, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (30, 'CRT-2025-030', 'Digital Skills', 96, 90, 73, 77, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (31, 'CRT-2025-031', 'Digital Skills', 66, 99, 65, 92, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (32, 'CRT-2025-032', 'Digital Skills', 82, 81, 60, 67, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (33, 'CRT-2025-033', 'Digital Skills', 91, 85, 81, 60, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (34, 'CRT-2025-034', 'Digital Skills', 91, 84, 81, 66, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (35, 'CRT-2025-035', 'Digital Skills', 72, 62, 74, 87, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (36, 'CRT-2025-036', 'Digital Skills', 76, 88, 73, 94, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (37, 'CRT-2025-037', 'Digital Skills', 74, 84, 86, 100, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (38, 'CRT-2025-038', 'Digital Skills', 90, 76, 77, 76, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (39, 'CRT-2025-039', 'Digital Skills', 63, 87, 80, 94, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (40, 'CRT-2025-040', 'Digital Skills', 85, 80, 81, 75, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (41, 'CRT-2025-041', 'Digital Skills', 66, 70, 97, 75, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (42, 'CRT-2025-042', 'Digital Skills', 93, 99, 81, 75, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (43, 'CRT-2025-043', 'Digital Skills', 79, 97, 88, 75, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (44, 'CRT-2025-044', 'Digital Skills', 65, 69, 60, 80, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (45, 'CRT-2025-045', 'Digital Skills', 90, 97, 73, 98, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (46, 'CRT-2025-046', 'Digital Skills', 75, 71, 81, 100, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (47, 'CRT-2025-047', 'Digital Skills', 74, 82, 81, 72, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (48, 'CRT-2025-048', 'Digital Skills', 96, 84, 99, 71, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (49, 'CRT-2025-049', 'Digital Skills', 75, 83, 92, 77, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (50, 'CRT-2025-050', 'Digital Skills', 70, 83, 60, 97, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (51, 'CRT-2025-051', 'Digital Skills', 74, 85, 93, 87, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (52, 'CRT-2025-052', 'Digital Skills', 68, 81, 86, 82, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (53, 'CRT-2025-053', 'Digital Skills', 81, 99, 89, 78, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (54, 'CRT-2025-054', 'Digital Skills', 66, 81, 98, 61, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (55, 'CRT-2025-055', 'Digital Skills', 99, 69, 93, 99, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (56, 'CRT-2025-056', 'Digital Skills', 63, 99, 97, 88, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (57, 'CRT-2025-057', 'Digital Skills', 90, 76, 68, 77, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (58, 'CRT-2025-058', 'Digital Skills', 76, 71, 89, 96, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (59, 'CRT-2025-059', 'Digital Skills', 98, 99, 82, 74, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (60, 'CRT-2025-060', 'Digital Skills', 68, 71, 69, 63, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (61, 'CRT-2025-061', 'Digital Skills', 81, 92, 71, 71, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (62, 'CRT-2025-062', 'Digital Skills', 98, 86, 72, 93, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (63, 'CRT-2025-063', 'Digital Skills', 68, 78, 99, 61, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (64, 'CRT-2025-064', 'Digital Skills', 64, 87, 89, 93, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (65, 'CRT-2025-065', 'Digital Skills', 95, 60, 89, 68, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (66, 'CRT-2025-066', 'Digital Skills', 97, 78, 73, 100, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (67, 'CRT-2025-067', 'Digital Skills', 79, 60, 69, 62, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (68, 'CRT-2025-068', 'Digital Skills', 92, 86, 98, 91, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (69, 'CRT-2025-069', 'Digital Skills', 92, 62, 60, 65, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (70, 'CRT-2025-070', 'Digital Skills', 98, 81, 93, 99, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (71, 'CRT-2025-071', 'Digital Skills', 66, 62, 79, 85, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (72, 'CRT-2025-072', 'Digital Skills', 61, 94, 85, 98, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (73, 'CRT-2025-073', 'Digital Skills', 88, 90, 73, 84, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (74, 'CRT-2025-074', 'Digital Skills', 76, 77, 98, 90, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (75, 'CRT-2025-075', 'Digital Skills', 97, 99, 86, 89, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (76, 'CRT-2025-076', 'Digital Skills', 61, 65, 75, 86, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (77, 'CRT-2025-077', 'Digital Skills', 79, 61, 62, 67, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (78, 'CRT-2025-078', 'Digital Skills', 69, 67, 65, 84, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (79, 'CRT-2025-079', 'Digital Skills', 80, 68, 87, 100, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (80, 'CRT-2025-080', 'Digital Skills', 93, 65, 66, 81, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (81, 'CRT-2025-081', 'Digital Skills', 97, 66, 75, 64, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (82, 'CRT-2025-082', 'Digital Skills', 69, 62, 82, 92, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (83, 'CRT-2025-083', 'Digital Skills', 99, 87, 71, 89, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (84, 'CRT-2025-084', 'Digital Skills', 95, 69, 84, 68, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (85, 'CRT-2025-085', 'Digital Skills', 74, 81, 82, 89, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (86, 'CRT-2025-086', 'Digital Skills', 80, 96, 97, 76, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (87, 'CRT-2025-087', 'Digital Skills', 94, 65, 81, 77, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (88, 'CRT-2025-088', 'Digital Skills', 66, 100, 67, 86, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (89, 'CRT-2025-089', 'Digital Skills', 74, 60, 87, 89, 11, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (90, 'CRT-2025-090', 'Digital Skills', 61, 70, 92, 92, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (91, 'CRT-2025-091', 'Digital Skills', 64, 83, 88, 75, 9, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (92, 'CRT-2025-092', 'Digital Skills', 71, 80, 64, 89, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (93, 'CRT-2025-093', 'Digital Skills', 81, 79, 79, 66, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (94, 'CRT-2025-094', 'Digital Skills', 62, 91, 64, 94, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (95, 'CRT-2025-095', 'Digital Skills', 88, 86, 69, 85, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (96, 'CRT-2025-096', 'Digital Skills', 94, 63, 100, 69, 12, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (97, 'CRT-2025-097', 'Digital Skills', 80, 88, 76, 70, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (98, 'CRT-2025-098', 'Digital Skills', 97, 64, 80, 63, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (99, 'CRT-2025-099', 'Digital Skills', 86, 76, 69, 79, 10, TRUE);
INSERT INTO test_score_staging (student_id, test_id, course_name, logical_thinking, critical_analysis, problem_solving, digital_tools, grade_level, is_ready) VALUES (100, 'CRT-2025-100', 'Digital Skills', 68, 67, 60, 65, 11, TRUE);




