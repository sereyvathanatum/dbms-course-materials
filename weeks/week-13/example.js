// WEEK-13 Worked Example (w13_f1)
const db = db.getSiblingDB('w13_f1');

db.races.aggregate([
  { $match: { season: 2024 } },
  { $count: "races_2024" }
]);
