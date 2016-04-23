
Game Localization DB

Tool written in Node.js with Express and MongoDB for managing game project language localization data.


General Features

- Full history of string data edits identifying who changed what and when, with rollback options.

- Can add custom tags to string data and query strings based on their tags.

- Manage multiple projects with various user read / write permissions, import sets of strings between projects.

- Can export data drops to a variety of formats commonly used in game projects.

- Can export data for external localization, identifies which strings need translation or have been updated.

- Can import data bundles, uses smart logic to determine the age of the bundle and update the strings that have changed.

- Progress reports including frequency of strings being added / updated and burndown of strings needing translation.

- Passport.js configurable login system supports local, Gmail, and many other login options.


Data Schema

Note that MongoDB automatically supplies an _id field on all entries.

history table
- date - date that the event occurred
- type - identifies the event, eg. "user created", "user verified", "string edited", etc.
- args - additional data object, varies according to the event type

users table
- email - used as login
- pass - hashed password
- salt - salt used to secure hashed password against dictionary attack
- name - optional display name of user
- verified - true if the user's email address has been confirmed

languages table
- name - display name of the language

projects table
- name - display name of project
- admin_ids - list of admin users
- access_ids - list of users with at least regular read / write access
- read_only_access_ids - list of users who can at least read the db
- language_ids - list of languages used by the project
- comments - list of user comments for the project

string_tags table
- name - display name of the tag
- comments - list of user comments for the tag

string_data table
- name - human-readable identifier for the string, alternative to _id
- project_id - project that the string is part of
- translations - map of language_id to translation data
- comments - list of user comments for the string data

imports table
- project_id - project that the import was created for
- data - set of strings with translations that make up the import body
- result - list of errors generated during import, if any
- comments - list of user comments for the import

exports table
- project_id - project that the export was created for
- data - set of strings with translations that make up the export body
- comments - list of user comments for the export
