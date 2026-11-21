# Week 12 Practice Pack · Olist Nested Orders in MongoDB

> Printable version: [README.pdf](README.pdf)

- **Course:** FESE304 — Database Management Systems
- **Topic:** Document Model & MongoDB CRUD (`find()`, projections, dot notation, `$gt`/`$in`, `$exists`, `$size`, `$elemMatch`, `insertOne`/`updateOne`)
- **Level:** Low-to-Medium (designed for self-study at home)
- **Target Engine & Namespace:** MongoDB 8.0 (`w12_olist.orders`, with scratch updates in `w12_olist.w12_scratch`)
- **Dataset Source & License:** [Olist Brazilian E-Commerce Public Dataset (500 nested order documents, CC BY-NC-SA 4.0)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## How to Use This Pack at Home

1. Load the dataset into your local MongoDB container:
   ```bash
   docker compose exec -T mongo mongosh --quiet < weeks/week-12/dataset.js
   ```
   *(Or connect **MongoDB Compass** to `mongodb://localhost:27019`, create database `w12_olist` and collection `orders`, and import `orders_sample.json`.)*
2. Open `mongosh` (`docker compose exec mongo mongosh`) and run `use w12_olist;`.
3. Never modify `db.orders` directly — copy one document into `db.w12_scratch` for update tasks!
4. Complete **Core Practice (Tasks 1–12)** first; try **Optional Stretch (Tasks 13–15)** if you finish early.

---

## Document Structure & Real Sample Document (`w12_olist.orders` — 500 docs)

| Field | Type | Description |
| --- | --- | --- |
| `_id` | `String` | Order ID (32-char hex string) |
| `status` | `String` | `"delivered"`, `"shipped"`, `"canceled"`, `"unavailable"`, `"invoiced"`, `"processing"` |
| `purchase_date` / `delivered_date` | `String \| null` | Timestamps (`delivered_date` is `null` if not delivered) |
| `customer` | `Object` | `{ id, unique_id, zip_prefix, city, state }` |
| `items` | `Array<Object>` | `[{ item_id, product_id, category, seller_id, seller_state, price, freight_value }]` |
| `payments` | `Array<Object>` | `[{ sequential, type, installments, value }]` |
| `order_total` | `Number` | Total order value in BRL |
| `review` | `Object` *(optional)* | Present on `460` of `500` docs (`score`, optional `title`, optional `message`) |

**Shortened real document (`_id: "00010242fe8c5a6d1ba2dd792cb16214"`):**

```json
{
  "_id": "00010242fe8c5a6d1ba2dd792cb16214",
  "status": "delivered",
  "customer": { "city": "campos dos goytacazes", "state": "RJ" },
  "items": [{ "item_id": 1, "category": "cool_stuff", "seller_state": "SP", "price": 58.9, "freight_value": 13.29 }],
  "payments": [{ "sequential": 1, "type": "credit_card", "installments": 2, "value": 72.19 }],
  "order_total": 72.19,
  "review": { "score": 5, "message": "Perfeito, produto entregue antes do combinado." }
}
```

---

## Worked Example (Try This First!)

Count how many order documents are stored in `db.orders`:

```javascript
db.orders.countDocuments({});
```

> **Verification:** Expected `500`

---

## Part 1: Basics — `find()`, Projections, Dot Notation & Sorting (Tasks 1–5) — Core Practice

### Task 1 · Look up one order by `_id`
Find the document with `_id: "00010242fe8c5a6d1ba2dd792cb16214"`, projecting `{ _id: 1, status: 1, "customer.city": 1, "customer.state": 1, order_total: 1 }`.

> **Verification:** Expected `1` document | First: `{"_id":"00010242fe8c5a6d1ba2dd792cb16214","status":"delivered","customer":{"city":"campos dos goytacazes","state":"RJ"},"order_total":72.19}`

### Task 2 · Delivered orders in Rio de Janeiro (`RJ`)
Find documents where `status` is `"delivered"` and `"customer.state"` is `"RJ"`. Project `{ _id: 1, "customer.city": 1, order_total: 1 }` and sort by `{ _id: 1 }`.

> **Verification:** Expected `65` documents | First: `{"_id":"00010242fe8c5a6d1ba2dd792cb16214","customer":{"city":"campos dos goytacazes"},"order_total":72.19}`

### Task 3 · Top 5 orders over 1,000 BRL (`$gt`, `sort`, `limit`)
Find documents with `order_total > 1000` (`{ order_total: { $gt: 1000 } }`). Project `{ _id: 1, "customer.state": 1, order_total: 1 }`, sort by `{ order_total: -1, _id: 1 }`, and `.limit(5)`.

> **Verification:** Expected `5` documents | First: `{"_id":"01a0013ddc7cd129e350e8671b56a263","customer":{"state":"GO"},"order_total":1810.5}`

### Task 4 · Canceled or unavailable orders (`$in`)
Find documents where `status` is in `["canceled", "unavailable"]`. Project `{ _id: 1, status: 1, "customer.state": 1, order_total: 1 }` and sort by `{ _id: 1 }`.

> **Verification:** Expected `25` documents | First: `{"_id":"0010dedd556712d7bb69a19cb7bbd37a","status":"unavailable","customer":{"state":"SP"},"order_total":0}`

### Task 5 · Top 5 five-star orders in São Paulo (`SP`)
Find documents where `"customer.state"` is `"SP"` and `"review.score"` is `5`. Project `{ _id: 1, "customer.city": 1, "review.score": 1, order_total: 1 }`, sort by `{ order_total: -1, _id: 1 }`, and `.limit(5)`.

> **Verification:** Expected `5` documents | First: `{"_id":"000576fe39319847cbb9d288c5617fa6","customer":{"city":"praia grande"},"order_total":880.75,"review":{"score":5}}`

---

## Part 2: Everyday Practice — Sparse Fields, Arrays & Safe Updates (Tasks 6–10) — Core Practice

### Task 6 · Delivered orders with no `review` object (`$exists: false`)
In MongoDB, optional fields can simply be absent. Find `"delivered"` orders where `review` does not exist (`review: { $exists: false }`). Project `{ _id: 1, "customer.state": 1, order_total: 1 }` and sort by `{ _id: 1 }`.

<details>
<summary>Hint</summary>
`db.orders.find({ status: "delivered", review: { $exists: false } }, ...)`
</details>

> **Verification:** Expected `37` documents | First: `{"_id":"00143d0f86d6fbd9f9b38ab440ac16f5","customer":{"state":"GO"},"order_total":109.29}`

### Task 7 · One-star reviews that have a written comment (`$exists: true`)
Find orders where `"review.score"` is `1` and `"review.message"` exists (`{ $exists: true }`). Project `{ _id: 1, "customer.state": 1, "review.score": 1 }` and sort by `{ _id: 1 }`.

<details>
<summary>Hint</summary>
Combine `"review.score": 1` and `"review.message": { $exists: true }` in the same filter object.
</details>

> **Verification:** Expected `73` documents | First: `{"_id":"0005a1a1728c9d785b8e2b08b904576c","customer":{"state":"SP"},"review":{"score":1}}`

### Task 8 · Orders with exactly 3 line items (`$size`)
Find orders whose `items` array has length `3` (`{ items: { $size: 3 } }`). Project `{ _id: 1, "customer.state": 1, order_total: 1 }` and sort by `{ order_total: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
`$size` checks the exact length of an array field.
</details>

> **Verification:** Expected `13` documents | First: `{"_id":"01a0013ddc7cd129e350e8671b56a263","customer":{"state":"GO"},"order_total":1810.5}`

### Task 9 · Match two conditions on the *same* array element (`$elemMatch`)
Find orders containing at least one item in `items` where that same item has `price >= 150` AND `freight_value >= 20`. Project `{ _id: 1, "customer.state": 1, order_total: 1 }` and sort by `{ order_total: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
`{ items: { $elemMatch: { price: { $gte: 150 }, freight_value: { $gte: 20 } } } }`
</details>

> **Verification:** Expected `59` documents | First: `{"_id":"01a0013ddc7cd129e350e8671b56a263","customer":{"state":"GO"},"order_total":1810.5}`

### Task 10 · Safe `updateOne()` practice (`$set` and `$addToSet`)
1. Copy order `"00010242fe8c5a6d1ba2dd792cb16214"` from `db.orders` into a clean scratch collection `db.w12_scratch`.
2. Run `updateOne()` to set `checked_by: "student_lab"` (`$set`) and add `["verified", "rj", "verified"]` to `tags` using `$addToSet` + `$each` (notice duplicate `"verified"` is automatically ignored!).
3. Verify with `find(..., { _id: 1, status: 1, checked_by: 1, tags: 1 })`, then run `db.w12_scratch.drop()`.

<details>
<summary>Hint</summary>
```javascript
db.w12_scratch.drop();
db.w12_scratch.insertOne(db.orders.findOne({ _id: "00010242fe8c5a6d1ba2dd792cb16214" }));
db.w12_scratch.updateOne(
  { _id: "00010242fe8c5a6d1ba2dd792cb16214" },
  { $set: { checked_by: "student_lab" }, $addToSet: { tags: { $each: ["verified", "rj", "verified"] } } }
);
```
</details>

> **Verification:** Expected `1` document | First: `{"_id":"00010242fe8c5a6d1ba2dd792cb16214","status":"delivered","checked_by":"student_lab","tags":["verified","rj"]}`

---

## Part 3: Fix the Bug (Tasks 11–12) — Core Practice

### Task 11 · Exact subdocument equality returns `0` documents
The query below returns `0` documents because `{ payments: { type: "voucher", installments: 1 } }` only matches an object with *literally those 2 fields and nothing else* (real payment objects have 4 fields!). Fix it using `$elemMatch`, projecting `{ _id: 1, order_total: 1 }` sorted by `{ _id: 1 }`.

```javascript
db.orders.find(
  { payments: { type: "voucher", installments: 1 } },
  { _id: 1, order_total: 1 }
).sort({ _id: 1 });
```

<details>
<summary>Hint</summary>
Wrap the condition in `$elemMatch`: `{ payments: { $elemMatch: { type: "voucher", installments: 1 } } }`.
</details>

> **Verification:** Expected `15` documents | First: `{"_id":"0016dfedd97fc2950e388d2971d718c7","order_total":70.55}`

### Task 12 · `{ field: null }` matches missing parent objects too!
Checking `{ "review.message": null }` returns `214` orders — including orders that don’t even have a `review`! Fix it to find only orders that **have** a `"review.title"` (`$exists: true`) and **lack** a `"review.message"` (`$exists: false`). Project `{ _id: 1, "review.score": 1, "review.title": 1 }` sorted by `{ _id: 1 }`.

```javascript
db.orders.find({ "review.message": null });
```

<details>
<summary>Hint</summary>
`{ "review.title": { $exists: true }, "review.message": { $exists: false } }`
</details>

> **Verification:** Expected `2` documents | First: `{"_id":"0282e83acfe3e7aaf60c871a4a9aca61","review":{"score":1,"title":"Comprei 02, recebi 01"}}`

---

## Part 4: Optional Stretch (Tasks 13–15) — Try If You Finish Early

### Task 13 · High-installment credit card payments (`$elemMatch`)
Find orders containing a payment element with `type: "credit_card"` and `installments >= 10`. Project `{ _id: 1, "customer.state": 1, order_total: 1 }` sorted by `{ order_total: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
`{ payments: { $elemMatch: { type: "credit_card", installments: { $gte: 10 } } } }`
</details>

> **Verification:** Expected `36` documents | First: `{"_id":"01a0013ddc7cd129e350e8671b56a263","customer":{"state":"GO"},"order_total":1810.5}`

### Task 14 · Interstate orders (`RJ` buyer, `SP` seller)
Find orders where `"customer.state"` is `"RJ"` and `"items.seller_state"` is `"SP"`. Project `{ _id: 1, "customer.city": 1, order_total: 1 }` sorted by `{ order_total: -1, _id: 1 }`.

<details>
<summary>Hint</summary>
For a single condition on an array field (`"items.seller_state": "SP"`), dot notation works directly without `$elemMatch`.
</details>

> **Verification:** Expected `46` documents | First: `{"_id":"0245631f7bd55dbee7c6b441629bba94","customer":{"city":"rio de janeiro"},"order_total":939.72}`

### Task 15 · Combine `$set`, `$inc`, and `$unset` in one `updateOne()`
Copy order `"00143d0f86d6fbd9f9b38ab440ac16f5"` into a clean `db.w12_scratch` collection. In one `updateOne()`:
- `$set` `note: "checked_in_lab"`
- `$inc` `"payments.0.installments"` by `1` (from `1` to `2`)
- `$unset` `estimated_delivery_date: ""`

Verify with `find(..., { _id: 1, note: 1, "payments.installments": 1, estimated_delivery_date: 1 })`, then drop `db.w12_scratch`.

<details>
<summary>Hint</summary>
You can put `$set`, `$inc`, and `$unset` as three keys in the same update document!
</details>

> **Verification:** Expected `1` document | First: `{"_id":"00143d0f86d6fbd9f9b38ab440ac16f5","payments":[{"installments":2}],"note":"checked_in_lab"}`

---

## Capstone sprint

**C12:** Add a document part to your project and map your tables to documents.

## Submit

Answers in `work.js`, reflection in `reflection.md`, output in `results/`. Commit and push. See [SUBMISSIONS.md](../../SUBMISSIONS.md).
