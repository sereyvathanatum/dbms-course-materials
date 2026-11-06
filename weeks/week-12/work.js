// Week 12: NoSQL and MongoDB CRUD
// Read from cambodia. Insert, update and delete only in student_work.
// Save the output of each task in results/.

const source = db.getSiblingDB('cambodia');
const work = db.getSiblingDB('student_work');

// ----- Lab -----

// Lab 1: Run `example.js` and look at one document from each collection.
// TODO

// Lab 2: Find the provinces with an area above a value you choose from the data, showing only code, name and area.
// TODO

// Lab 3: Copy the provinces into `student_work.w12_province` and create a unique index on `province_pcode`.
// TODO

// Lab 4: Delete one document from your copy, insert the same document again, and check that its fields match `cambodia.province`.
// TODO

// Lab 5: Update one name in your copy to the value it already has. Explain the difference between `matchedCount` and `modifiedCount`.
// TODO

// ----- Homework -----

// Homework 1: Write four CRUD commands, save their output, and compare each one with the matching SQL statement.
// TODO

// Homework 2: Explain where embedding districts inside provinces could help, and when a relational database is still the better choice.
// TODO

// Homework 3: In `student_work`, build one province document with an array of its districts, copied from `cambodia.district`. Query a nested field with dot notation (for example `districts.district_pcode`) and the array with `$size` or `$elemMatch`.
// TODO
