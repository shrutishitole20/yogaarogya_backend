-- Migration: Create health assessments table
-- Created: 2024-01-02

CREATE TABLE health_assessments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    back_pain BOOLEAN DEFAULT false,
    neck_pain BOOLEAN DEFAULT false,
    stress BOOLEAN DEFAULT false,
    insomnia BOOLEAN DEFAULT false,
    digestive_issues BOOLEAN DEFAULT false,
    joint_pain BOOLEAN DEFAULT false,
    high_blood_pressure BOOLEAN DEFAULT false,
    obesity BOOLEAN DEFAULT false,
    respiratory_issues BOOLEAN DEFAULT false,
    diabetes BOOLEAN DEFAULT false,
    arthritis BOOLEAN DEFAULT false,
    anxiety BOOLEAN DEFAULT false,
    depression BOOLEAN DEFAULT false,
    migraine BOOLEAN DEFAULT false,
    thyroid BOOLEAN DEFAULT false,
    heart_disease BOOLEAN DEFAULT false,
    asthma BOOLEAN DEFAULT false,
    allergies BOOLEAN DEFAULT false
);

-- Enable RLS
ALTER TABLE health_assessments ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can insert their own health assessment" ON health_assessments
FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own health assessment" ON health_assessments
FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own health assessment" ON health_assessments
FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Index for performance
CREATE INDEX idx_health_assessments_user_id ON health_assessments(user_id);
