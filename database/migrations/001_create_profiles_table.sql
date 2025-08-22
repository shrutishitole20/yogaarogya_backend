-- Migration: Create profiles table
-- Created: 2024-01-01

CREATE TABLE profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    name TEXT,
    avatar_url TEXT,
    has_practiced BOOLEAN DEFAULT false,
    experience_years INTEGER,
    goals TEXT,
    age INTEGER CHECK (age > 0 AND age < 150),
    city TEXT,
    previous_yoga_experience TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Allow profile creation" ON profiles
FOR INSERT 
TO authenticated, service_role
WITH CHECK (true);

CREATE POLICY "Users can view their own profile" ON profiles
FOR SELECT 
TO authenticated 
USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles
FOR UPDATE 
TO authenticated 
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);
