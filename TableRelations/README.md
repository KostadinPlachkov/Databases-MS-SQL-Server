# Table of Content
* Database Design
* Table Relations
* Cascade Operations
* E/R Diagrams

# Steps in Database Design
* Steps in the database design process:
    1. Identification of the entities
    2. Identification of the columns in the tables
    3. Defining a primary key for each entity table
    4. Identification and modeling of relationships
        * Multiplicity of relationships
    5. Defining other constraints
    6. Filling test data in the tables
    
# How to Choose a Primary Key?
* Always define an additional column for the primary key  
    * Don't use an existing column (for example SSN)
    * Must be an integer number
    * Must be declared as a primary key
    * Use identity to implement auto-increment
    * Put the primary key as a first column
* Exceptions
    * Entities that have well known ID, e.g. countries (BG, DE, US) and currencies (USD, EUR, BGN)
