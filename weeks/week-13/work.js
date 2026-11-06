// Week 13: MongoDB aggregation and data modelling
// Read from cambodia. Insert, update and delete only in student_work.
// Save the output of each task in results/.

const source = db.getSiblingDB('cambodia');
const work = db.getSiblingDB('student_work');

// ----- Lab -----

// Lab 1: Count districts per `province_pcode`, sorted by code. Translate a SQL `GROUP BY … ORDER BY … LIMIT` into `$group`, `$sort`, `$limit` and compare.
// TODO

// Lab 2: Show each district with its province name (`$lookup`).
// TODO

// Lab 3: Attach districts to provinces, `$unwind`, and compare the count with the SQL join.
// TODO

// Lab 4: Remove `_id` with `$project`; compare values with SQL.
// TODO

// Lab 5: Design an embedded province-with-districts model from the existing data. How do you keep it updated? How does it grow?
// TODO

// ----- Homework -----

// Homework 1: Write three pipelines using $match, $group, $project, $lookup and $unwind.
// TODO

// Homework 2: For two project queries: embed or reference? Why?
// TODO
