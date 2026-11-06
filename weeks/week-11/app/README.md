# Week 11: your app

Put your Week 11 code here, for example `crud.py` or `crud.mjs`. The apps in [apps/](../../../apps/README.md) show how to connect and how to bind parameters.

- Read the connection settings from environment variables.
- Use a parameter for every value (`%s` in Python, `?` in Node.js).
- Change only tables in `student_work`.

Run your app from the top folder of the repository.

**Python** (uses the `.venv` from the apps guide):

```bash
.venv/bin/python weeks/week-11/app/crud.py
```

**Node.js** (install the MySQL driver in this folder once):

```bash
npm --prefix weeks/week-11/app init -y
npm --prefix weeks/week-11/app install mysql2@3.24.6
node weeks/week-11/app/crud.mjs
```

Commit the `package.json` and `package-lock.json` that npm creates, but not `node_modules/`.
