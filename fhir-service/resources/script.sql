-- Create DB and switch
CREATE DATABASE IF NOT EXISTS patient_data3
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE patient_data3;

-- Drop existing tables if any
DROP TABLE IF EXISTS `EncounterData`;
DROP TABLE IF EXISTS `PatientData`;

-- Create Patient table
CREATE TABLE `PatientData` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191),
    `gender` VARCHAR(191),
    `birthDate` VARCHAR(191),
    PRIMARY KEY(`id`)
);

-- Create Encounter table
CREATE TABLE `EncounterData` (
    `id` VARCHAR(191) NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `encounterClassSystem` VARCHAR(191),
    `encounterClassCode` VARCHAR(191),
    `encounterClassDisplay` VARCHAR(191),
    `typeText` VARCHAR(191),
    `subjectRef` VARCHAR(191) NOT NULL,
    `periodStart` VARCHAR(191),
    `periodEnd` VARCHAR(191),
    PRIMARY KEY(`id`)
);

-- Insert Patients
INSERT INTO `PatientData` (id, name, gender, birthDate) VALUES
  ('P001', 'John Doe', 'male', '1985-05-10'),
  ('P002', 'Jane Smith', 'female', '1990-11-23'),
  ('P003', 'Sam Perera', 'male', '1988-03-14');

-- Insert Encounters (2 per patient)
INSERT INTO `EncounterData` (id, status, encounterClassSystem, encounterClassCode, encounterClassDisplay, typeText, subjectRef, periodStart, periodEnd) VALUES
  -- Encounters for P001
  ('E001', 'finished', 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'AMB', 'ambulatory', 'General Checkup', 'Patient/P001', '2025-08-01T09:00:00Z', '2025-08-01T09:30:00Z'),
  ('E002', 'in-progress', 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'IMP', 'inpatient encounter', 'Emergency Visit', 'Patient/P001', '2025-08-10T14:00:00Z', NULL),

  -- Encounters for P002
  ('E003', 'finished', 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'AMB', 'ambulatory', 'Dental Consultation', 'Patient/P002', '2025-08-05T10:00:00Z', '2025-08-05T10:20:00Z'),
  ('E004', 'planned', 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'VR', 'virtual', 'Telehealth Appointment', 'Patient/P002', '2025-08-20T11:00:00Z', NULL),

  -- Encounters for P003
  ('E005', 'finished', 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'AMB', 'ambulatory', 'Follow-up Visit', 'Patient/P003', '2025-08-07T08:30:00Z', '2025-08-07T08:50:00Z'),
  ('E006', 'in-progress', 'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'HH', 'home health', 'Home Visit', 'Patient/P003', '2025-08-18T15:00:00Z', NULL);
