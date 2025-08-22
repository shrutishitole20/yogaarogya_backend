-- Migration: Create yoga sessions table
-- Created: 2024-01-04

CREATE TABLE yoga_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    pose_name TEXT NOT NULL,
    duration INTEGER NOT NULL, -- in seconds
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    pose_category TEXT,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5)
);

-- Enable RLS
ALTER TABLE yoga_sessions ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can insert their own yoga sessions" ON yoga_sessions
FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own yoga sessions" ON yoga_sessions
FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own yoga sessions" ON yoga_sessions
FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Indexes for performance
CREATE INDEX idx_yoga_sessions_user_id ON yoga_sessions(user_id);
CREATE INDEX idx_yoga_sessions_completed_at ON yoga_sessions(completed_at);
