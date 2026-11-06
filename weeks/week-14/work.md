# Week 14: Redis caching and choosing a database

Write the commands you ran under each task and save their output in results/.

## Lab 1

Run `apps/python/cache.py` or `apps/node/cache.mjs` twice with the same province code. Save the miss and then the hit.

TODO

## Lab 2

Use redis-cli to look at the stored JSON and its TTL. Wait until the key expires and run the app again to see a miss.

TODO

## Lab 3

Build a hash, a list and a set from fields in the province or district data.

TODO

## Lab 4

Build a sorted set of provinces scored by area and compare its order with the same ORDER BY in MySQL. Explain what Redis does when two scores are equal.

TODO

## Lab 5

Delete your cache key and check that the next run loads it again. Write a short policy for what to do when the data changes and when Redis is down.

TODO

## Homework 1

Submit your Redis commands, their output, what you saw when the key expired, and your cache code.

TODO

## Homework 2

For each way your capstone uses data, choose MySQL, MongoDB or Redis and explain why (durability, relationships, validation and consistency).

TODO

## Homework 3

Explain why Redis is fast for key lookups, and describe one requirement where a graph database would fit better than MySQL, MongoDB or Redis.

TODO
