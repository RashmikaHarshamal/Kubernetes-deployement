// API Base URL - Update this if your backend runs on a different port
// For local development: http://localhost:8080/api/v3
// For Docker Compose: http://backend:8080/api/v3
// For Kubernetes with Ingress: /api/v3 (same domain)
const API_BASE_URL = window.location.hostname === 'localhost' 
    ? 'http://localhost:8080/api/v3'
    : '/api/v3';

// DOM Elements
const userForm = document.getElementById('user-form');
const userIdInput = document.getElementById('userId');
const userNameInput = document.getElementById('userName');
const submitBtn = document.getElementById('submit-btn');
const cancelBtn = document.getElementById('cancel-btn');1
const formTitle = document.getElementById('form-title');
const usersTbody = document.getElementById('users-tbody');
const messageDiv = document.getElementById('message');
const refreshBtn = document.getElementById('refresh-btn');

// State
let isEditMode = false;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadUsers();
});

// Event Listeners
userForm.addEventListener('submit', handleFormSubmit);
cancelBtn.addEventListener('click', resetForm);
refreshBtn.addEventListener('click', loadUsers);

// Load all users
async function loadUsers() {
    try {
        showMessage('Loading users...', 'success');
        const response = await fetch(`${API_BASE_URL}/getusers`);
        
        if (!response.ok) {
            throw new Error('Failed to fetch users');
        }
        
        const users = await response.json();
        displayUsers(users);
        hideMessage();
    } catch (error) {
        console.error('Error loading users:', error);
        showMessage('Error loading users. Make sure the backend is running on port 8080.', 'error');
    }
}

// Display users in table
function displayUsers(users) {
    usersTbody.innerHTML = '';
    
    if (users.length === 0) {
        usersTbody.innerHTML = '<tr><td colspan="3" class="no-users">No users found. Add a user to get started!</td></tr>';
        return;
    }
    
    users.forEach(user => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${user.id}</td>
            <td>${user.name}</td>
            <td>
                <button class="action-btn edit-btn" onclick="editUser(${user.id}, '${user.name}')">Edit</button>
                <button class="action-btn delete-btn" onclick="deleteUser(${user.id})">Delete</button>
            </td>
        `;
        usersTbody.appendChild(row);
    });
}

// Handle form submission
async function handleFormSubmit(e) {
    e.preventDefault();
    
    const userId = parseInt(userIdInput.value);
    const userName = userNameInput.value.trim();
    
    if (!userName) {
        showMessage('Please enter a valid name', 'error');
        return;
    }
    
    const userData = {
        id: userId,
        name: userName
    };
    
    try {
        if (isEditMode) {
            await updateUser(userData);
        } else {
            await addUser(userData);
        }
    } catch (error) {
        console.error('Error:', error);
        showMessage(`Error: ${error.message}`, 'error');
    }
}

// Add new user
async function addUser(userData) {
    try {
        const response = await fetch(`${API_BASE_URL}/adduser`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(userData)
        });
        
        if (!response.ok) {
            throw new Error('Failed to add user');
        }
        
        const newUser = await response.json();
        showMessage(`User "${newUser.name}" added successfully!`, 'success');
        resetForm();
        loadUsers();
    } catch (error) {
        throw error;
    }
}

// Update existing user
async function updateUser(userData) {
    try {
        const response = await fetch(`${API_BASE_URL}/updateuser`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(userData)
        });
        
        if (!response.ok) {
            throw new Error('Failed to update user');
        }
        
        const updatedUser = await response.json();
        showMessage(`User "${updatedUser.name}" updated successfully!`, 'success');
        resetForm();
        loadUsers();
    } catch (error) {
        throw error;
    }
}

// Set form to edit mode
function editUser(id, name) {
    isEditMode = true;
    formTitle.textContent = 'Update User';
    submitBtn.textContent = 'Update User';
    cancelBtn.style.display = 'block';
    
    userIdInput.value = id;
    userIdInput.readOnly = true;
    userNameInput.value = name;
    userNameInput.focus();
    
    // Scroll to form
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Delete user
async function deleteUser(userId) {
    if (!confirm('Are you sure you want to delete this user?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE_URL}/deleteuser/${userId}`, {
            method: 'DELETE'
        });
        
        if (!response.ok) {
            throw new Error('Failed to delete user');
        }
        
        const message = await response.text();
        showMessage(message || 'User deleted successfully!', 'success');
        loadUsers();
    } catch (error) {
        console.error('Error deleting user:', error);
        showMessage('Error deleting user', 'error');
    }
}

// Reset form
function resetForm() {
    isEditMode = false;
    formTitle.textContent = 'Add New User';
    submitBtn.textContent = 'Add User';
    cancelBtn.style.display = 'none';
    
    userIdInput.value = '';
    userIdInput.readOnly = false;
    userNameInput.value = '';
    
    hideMessage();
}

// Show message
function showMessage(text, type) {
    messageDiv.textContent = text;
    messageDiv.className = `message ${type}`;
}

// Hide message
function hideMessage() {
    setTimeout(() => {
        messageDiv.className = 'message';
    }, 3000);
}
