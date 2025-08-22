-- YOGAAROGYA Database Schema
-- PostgreSQL + Supabase

-- =============================================
-- 1. PROFILES TABLE
-- =============================================
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

-- RLS Policies for profiles
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

-- =============================================
-- 2. HEALTH ASSESSMENTS TABLE
-- =============================================
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

-- RLS Policies for health_assessments
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

-- =============================================
-- 3. FEEDBACK TABLE
-- =============================================
CREATE TABLE feedback (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    is_user_friendly BOOLEAN NOT NULL,
    suggestions TEXT
);

-- Enable RLS
ALTER TABLE feedback ENABLE ROW LEVEL SECURITY;

-- RLS Policies for feedback
CREATE POLICY "Users can insert their own feedback" ON feedback
FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own feedback" ON feedback
FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own feedback" ON feedback
FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Public read access for positive feedback (for homepage testimonials)
CREATE POLICY "Allow public read access to positive feedback" ON feedback
FOR SELECT 
TO anon, authenticated
USING (rating >= 4 AND suggestions IS NOT NULL);

-- =============================================
-- 4. YOGA SESSIONS TABLE
-- =============================================
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

-- RLS Policies for yoga_sessions
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

-- =============================================
-- 5. INDEXES FOR PERFORMANCE
-- =============================================
CREATE INDEX idx_health_assessments_user_id ON health_assessments(user_id);
CREATE INDEX idx_feedback_user_id ON feedback(user_id);
CREATE INDEX idx_feedback_rating ON feedback(rating);
CREATE INDEX idx_yoga_sessions_user_id ON yoga_sessions(user_id);
CREATE INDEX idx_yoga_sessions_completed_at ON yoga_sessions(completed_at);

-- =============================================
-- 6. FUNCTIONS (if needed)
-- =============================================
-- Function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, name)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call the function on new user creation
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
