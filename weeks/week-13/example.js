const source = db.getSiblingDB('cambodia');
printjson(source.district.aggregate([
 {$group:{_id:'$province_pcode',district_count:{$sum:1}}},{$sort:{_id:1}}
]).toArray());
printjson(source.province.aggregate([
 {$sort:{province_pcode:1}},{$limit:1},
 {$lookup:{from:'district',localField:'province_pcode',foreignField:'province_pcode',as:'districts'}},
 {$unwind:'$districts'},{$project:{_id:0,province_pcode:1,district_pcode:'$districts.district_pcode'}},
 {$sort:{district_pcode:1}}
]).toArray());
