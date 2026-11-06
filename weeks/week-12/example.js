const source = db.getSiblingDB('cambodia');
const work = db.getSiblingDB('student_work');
printjson(source.province.find({}, {_id:0}).sort({province_pcode:1}).limit(3).toArray());
// Copy the provinces into student_work. Never change the cambodia database.
for (const row of source.province.find({}, {_id:0}).toArray()) {
  work.w12_province.replaceOne({province_pcode:row.province_pcode},row,{upsert:true});
}
work.w12_province.createIndex({province_pcode:1},{unique:true});
// findOne(filter, projection, options): the sort goes in the third argument.
const original = work.w12_province.findOne({}, {}, {sort:{province_pcode:1}});
printjson(work.w12_province.deleteOne({_id:original._id}));
printjson(work.w12_province.insertOne(original));
// Check that the reinserted document still matches cambodia.province.
const restored = work.w12_province.findOne({province_pcode:original.province_pcode}, {_id:0});
const sourceRow = source.province.findOne({province_pcode:original.province_pcode}, {_id:0});
printjson({restored, matches_source:['province_pcode','province_name','area_km2'].every(f => restored[f] === sourceRow[f])});
printjson({source_count:source.province.countDocuments({}),copy_count:work.w12_province.countDocuments({})});
