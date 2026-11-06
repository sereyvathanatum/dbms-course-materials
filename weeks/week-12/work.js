// Week 12: NoSQL and MongoDB CRUD
// Read from cambodia. Insert, update and delete only in student_work.
// Save the output of each task in results/.

const source = db.getSiblingDB('cambodia');
const work = db.getSiblingDB('student_work');

// ----- Lab -----

// Lab 1: Run `example.js`; look at one document per collection.
// TODO

// Lab 2: Find provinces above an area you choose; show code, name and area only.
// TODO

// Lab 3: Copy provinces to `student_work.w12_province` with a unique index on `province_pcode`.
// TODO

// Lab 4: Delete one document, insert it again, check its fields against `cambodia.province`.
// TODO

// Lab 5: Update one name to its current value. `matchedCount` vs `modifiedCount`?
// TODO

// ----- Homework -----

// Homework 1: Write four CRUD commands with output; compare each with SQL.
// TODO

// Homework 2: When would embedding districts in provinces help? When is SQL better?
// TODO

// Homework 3: In `student_work`, build one province document with an array of its districts. Query `districts.district_pcode` and use `$size` or `$elemMatch`.
// TODO
