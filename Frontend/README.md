# User Management Frontend

A simple and elegant frontend interface for the User Management System backend.

## Features

- ✅ View all users in a clean table
- ✅ Add new users
- ✅ Update existing users
- ✅ Delete users
- ✅ Responsive design
- ✅ Real-time feedback with success/error messages

## Files

- `index.html` - Main HTML structure
- `style.css` - Styling with modern gradient design
- `app.js` - JavaScript for API interactions

## How to Run

### Option 1: Direct File Opening
1. Make sure your backend is running on `http://localhost:8080`
2. Simply open `index.html` in your web browser

### Option 2: Using Live Server (Recommended)
1. Install "Live Server" extension in VS Code
2. Right-click on `index.html`
3. Select "Open with Live Server"
4. The frontend will open at `http://127.0.0.1:5500`

### Option 3: Using Python HTTP Server
```bash
cd Frontend
python -m http.server 3000
```
Then open `http://localhost:3000` in your browser

## API Endpoints Used

- `GET /api/v3/getusers` - Fetch all users
- `GET /api/v3/getuser/{userId}` - Fetch user by ID
- `POST /api/v3/adduser` - Create new user
- `PUT /api/v3/updateuser` - Update existing user
- `DELETE /api/v3/deleteuser/{userId}` - Delete user by ID

## Configuration

If your backend runs on a different port, update the `API_BASE_URL` in `app.js`:

```javascript
const API_BASE_URL = 'http://localhost:YOUR_PORT/api/v3';
```

## Usage

1. **Add User**: Fill in the User ID and Name, then click "Add User"
2. **Update User**: Click "Edit" on any user row, modify the name, and click "Update User"
3. **Delete User**: Click "Delete" on any user row and confirm
4. **Refresh**: Click the "Refresh" button to reload the user list

## Requirements

- Backend must be running with CORS enabled (already configured in your UserController)
- Modern web browser (Chrome, Firefox, Edge, Safari)

## Troubleshooting

If you see "Error loading users":
1. Ensure the backend is running on port 8080
2. Check that your MySQL database is running
3. Verify the backend logs for any errors
4. Check browser console (F12) for detailed error messages
