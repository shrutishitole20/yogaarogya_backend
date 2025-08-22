// Supabase Backend Configuration
// Use this for server-side operations with service role

const { createClient } = require('@supabase/supabase-js');

// Server-side Supabase client with service role (admin privileges)
const supabaseAdmin = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

// Client-side Supabase client (for frontend)
const supabaseClient = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

module.exports = {
  supabaseAdmin,
  supabaseClient
};
