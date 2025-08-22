-- Create DB and switch
CREATE DATABASE IF NOT EXISTS patient_data3
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE patient_data3;

-- Drop existing tables if any
DROP TABLE IF EXISTS `EncounterData`;
DROP TABLE IF EXISTS `PatientData`;

-- Create Patient table
CREATE TABLE `PatientData` (
    `id` VARCHAR(36) NOT NULL,
    `name` VARCHAR(191),
    `gender` VARCHAR(191),
    `birthDate` VARCHAR(191),
    PRIMARY KEY(`id`)
);

-- Create Encounter table
CREATE TABLE `EncounterData` (
    `id` VARCHAR(36) NOT NULL,
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

-- Insert Patients with hardcoded UUIDs
INSERT INTO `PatientData` (id, name, gender, birthDate) VALUES
  ('550e8400-e29b-41d4-a716-446655440000', 'John Doe', 'male',   '1985-05-10'),
  ('550e8400-e29b-41d4-a716-446655440001', 'Jane Smith', 'female','1990-11-23'),
  ('550e8400-e29b-41d4-a716-446655440002', 'Sam Perera', 'male',  '1988-03-14');

-- Insert Encounters (2 per patient)
INSERT INTO `EncounterData`
(id, status, encounterClassSystem, encounterClassCode, encounterClassDisplay, typeText, subjectRef, periodStart, periodEnd) VALUES
  -- Encounters for John Doe
  ('111e8400-e29b-41d4-a716-446655440000', 'finished',   'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'AMB', 'ambulatory',          'General Checkup',        'Patient/550e8400-e29b-41d4-a716-446655440000', '2025-08-01T09:00:00Z', '2025-08-01T09:30:00Z'),
  ('111e8400-e29b-41d4-a716-446655440001', 'in-progress','http://terminology.hl7.org/CodeSystem/v3-ActCode', 'IMP', 'inpatient encounter', 'Emergency Visit',        'Patient/550e8400-e29b-41d4-a716-446655440000', '2025-08-10T14:00:00Z', NULL),

  -- Encounters for Jane Smith
  ('222e8400-e29b-41d4-a716-446655440000', 'finished',   'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'AMB', 'ambulatory',          'Dental Consultation',    'Patient/550e8400-e29b-41d4-a716-446655440001', '2025-08-05T10:00:00Z', '2025-08-05T10:20:00Z'),
  ('222e8400-e29b-41d4-a716-446655440001', 'planned',    'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'VR',  'virtual',             'Telehealth Appointment', 'Patient/550e8400-e29b-41d4-a716-446655440001', '2025-08-20T11:00:00Z', NULL),

  -- Encounters for Sam Perera
  ('333e8400-e29b-41d4-a716-446655440000', 'finished',   'http://terminology.hl7.org/CodeSystem/v3-ActCode', 'AMB', 'ambulatory',          'Follow-up Visit',        'Patient/550e8400-e29b-41d4-a716-446655440002', '2025-08-07T08:30:00Z', '2025-08-07T08:50:00Z'),
  ('333e8400-e29b-41d4-a716-446655440001', 'in-progress','http://terminology.hl7.org/CodeSystem/v3-ActCode', 'HH',  'home health',         'Home Visit',             'Patient/550e8400-e29b-41d4-a716-446655440002', '2025-08-18T15:00:00Z', NULL);
