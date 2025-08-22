# YOGAAROGYA API Documentation

## Base URL
```
https://wwqnqujhjlfifnhtveot.supabase.co/rest/v1/
```

## Authentication
All requests require authentication header:
```
Authorization: Bearer <access_token>
```

## Endpoints

### Authentication
- **POST** `/auth/v1/signup` - User registration
- **POST** `/auth/v1/token?grant_type=password` - User login
- **POST** `/auth/v1/logout` - User logout
- **POST** `/auth/v1/recover` - Password recovery

### Profiles
- **GET** `/profiles?id=eq.<user_id>` - Get user profile
- **POST** `/profiles` - Create user profile
- **PATCH** `/profiles?id=eq.<user_id>` - Update user profile

### Health Assessments
- **GET** `/health_assessments?user_id=eq.<user_id>` - Get user health assessment
- **POST** `/health_assessments` - Create health assessment
- **PATCH** `/health_assessments?id=eq.<assessment_id>` - Update health assessment

### Feedback
- **GET** `/feedback?user_id=eq.<user_id>` - Get user feedback
- **GET** `/feedback?rating=gte.4&suggestions=not.is.null` - Get positive feedback (public)
- **POST** `/feedback` - Submit feedback
- **PATCH** `/feedback?id=eq.<feedback_id>` - Update feedback

### Yoga Sessions
- **GET** `/yoga_sessions?user_id=eq.<user_id>` - Get user sessions
- **POST** `/yoga_sessions` - Create session record
- **PATCH** `/yoga_sessions?id=eq.<session_id>` - Update session

## Request Examples

### Create Profile
```javascript
POST /profiles
{
  "id": "user_uuid",
  "name": "John Doe",
  "age": 30,
  "city": "Mumbai",
  "previous_yoga_experience": true,
  "experience_years": 2,
  "goals": "Improve flexibility"
}
```

### Submit Health Assessment
```javascript
POST /health_assessments
{
  "user_id": "user_uuid",
  "back_pain": true,
  "stress": true,
  "insomnia": false,
  "diabetes": false
  // ... other health conditions
}
```

### Submit Feedback
```javascript
POST /feedback
{
  "user_id": "user_uuid",
  "rating": 5,
  "is_user_friendly": true,
  "suggestions": "Great app! Love the personalized recommendations."
}
```

### Create Yoga Session
```javascript
POST /yoga_sessions
{
  "user_id": "user_uuid",
  "pose_name": "Cat-Cow Pose",
  "duration": 300,
  "pose_category": "back_pain",
  "rating": 4
}
```

## Response Format
All responses follow this format:
```javascript
{
  "data": [...], // Array of results or single object
  "error": null, // Error object if any
  "count": 10,   // Total count (for paginated results)
  "status": 200  // HTTP status code
}
```

## Error Handling
```javascript
{
  "error": {
    "message": "Error description",
    "details": "Detailed error information",
    "hint": "Suggestion to fix the error",
    "code": "PGRST116"
  }
}
```

## Rate Limiting
- 100 requests per minute per user
- 1000 requests per hour per IP

## Pagination
Use `limit` and `offset` parameters:
```
GET /yoga_sessions?user_id=eq.<user_id>&limit=10&offset=20
```

## Filtering
Supabase PostgREST operators:
- `eq` - equals
- `neq` - not equals
- `gt` - greater than
- `gte` - greater than or equal
- `lt` - less than
- `lte` - less than or equal
- `like` - pattern matching
- `ilike` - case insensitive pattern matching
- `is` - checking for exact equality (null, true, false)
- `in` - one of a list of values
- `cs` - contains
- `cd` - contained in
