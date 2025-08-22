<<<<<<< HEAD
<<<<<<< HEAD
# YOGAAROGYA Backend

## Overview
This backend is powered by Supabase (Backend-as-a-Service) providing:
- PostgreSQL database
- Authentication system
- Real-time subscriptions
- Row Level Security (RLS)

## Database Schema

### Tables
1. **profiles** - User profile information
2. **health_assessments** - User health condition assessments
3. **feedback** - User feedback and ratings
4. **yoga_sessions** - Yoga practice session tracking

## Environment Variables Required

```env
SUPABASE_URL=https://wwqnqujhjlfifnhtveot.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

## Setup Instructions

1. Create a Supabase project
2. Run the database migrations in order
3. Configure Row Level Security policies
4. Set up authentication providers
5. Update environment variables

## API Endpoints

All API interactions go through Supabase client:
- Authentication: `/auth/v1/`
- Database: `/rest/v1/`
- Real-time: `/realtime/v1/`

## Security Features

- Row Level Security (RLS) enabled on all tables
- User isolation policies
- Public read access for testimonials only
- Secure authentication flow
=======
# shrutishitole20-yogaarogya_backend
>>>>>>> b956b39ec8ea269772543ed01f6e57212b6820d5
=======
# yogaarogya_backenddata
>>>>>>> 15fa83448862f43a02d9aac34b64f225947aec9b
