# Firebase Security Rules

## Authentication

- All writes/reads require authenticated users (except for public dog listings).

## Roles

- Use the `role` field in `/users/{uid}` for RBAC.
- Only `admin`/`manager`/`shelter_manager` can write to `/dogs`, `/events`, `/merchandise`.
- All adoption applications are only readable by the submitter and admins.

## Sample Rules

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /dogs/{dogId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager', 'shelter_manager'];
    }
    match /adoption_applications/{appId} {
      allow create: if request.auth != null;
      allow read, update, delete: if request.auth != null && (request.auth.uid == resource.data.userId || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'manager', 'shelter_manager']);
    }
  }
}
