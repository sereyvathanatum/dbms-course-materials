// Week 13: MongoDB aggregation and data modelling
// Read from cambodia. Insert, update and delete only in student_work.
// Save the output of each task in results/.

const source = db.getSiblingDB('cambodia');
const work = db.getSiblingDB('student_work');

// ----- Lab -----

// Lab 1: Group districts by `province_pcode`, count them and sort by code. Then write a SQL query with `GROUP BY … ORDER BY … LIMIT` and translate it into a pipeline with `$group`, `$sort` and `$limit`. Compare the outputs.
// TODO

// Lab 2: Use `$lookup` to show each district with its province name.
// TODO

// Lab 3: Use `$lookup` to attach districts to provinces, then `$unwind` them. Compare the number of documents with the row count of the same SQL join.
// TODO

// Lab 4: Use `$project` to remove `_id`, and compare the values with a SQL result.
// TODO

// Lab 5: Design an embedded model (provinces with their districts) built only from the existing data. Explain how you would keep it up to date, how it would grow and what an update would cost.
// TODO

// ----- Homework -----

// Homework 1: Write three pipelines that together use $match, $group, $project, $lookup and $unwind.
// TODO

// Homework 2: For two queries in your project, explain whether you would embed or reference, and why.
// TODO
