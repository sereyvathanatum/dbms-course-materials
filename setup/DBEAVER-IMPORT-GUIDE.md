# DBeaver Community SQL Import Guide (FESE304)

In the weekly hands-on SQL labs (Weeks 1–8 and 10–11), each week includes a self-contained `dataset.sql` file inside `weeks/week-XX/` (for example, `weeks/week-01/dataset.sql` or `weeks/week-05/dataset.sql`).

Follow this guide once to connect **DBeaver Community** to your local Docker MySQL 8.4 server, and then import each week's dataset in 5 seconds.

---

## 1. Start Your Local Docker Stack

From the top folder of this repository:

```bash
docker compose up -d --wait
```

---

## 2. Create Your MySQL Connection in DBeaver (One-Time Setup)

1. Open **DBeaver Community** and click **New Database Connection** (`Ctrl+Shift+N`).
2. Select **MySQL** and click **Next >**.
3. Under the **Main** tab, enter:
   - **Server Host:** `127.0.0.1` (or `localhost`)
   - **Port:** `3306`
   - **Database:** `student_work`
   - **Username:** `practice`
   - **Password:** `practice-local-only`
   - Check **Save password locally**.
4. **Enable Public Key Retrieval (important for MySQL 8.4):**
   - Click the **Driver properties** tab.
   - Find **`allowPublicKeyRetrieval`** and set it to **`true`**.
5. Click **Test Connection...** (download the MySQL JDBC driver if prompted), then click **Finish**.

---

## 3. Import Any Week’s `dataset.sql`

1. In DBeaver, choose **File → Open File...** (`Ctrl+O`) and select `weeks/week-XX/dataset.sql`.
2. In the toolbar dropdown above the editor, select your **`127.0.0.1` (`student_work`)** MySQL connection.
3. Press **`Alt+X`** (*Execute SQL Script*) — do **not** press `Ctrl+Enter` (which runs only one statement).
4. In the left **Database Navigator**, right-click **Databases** and press **`F5`** (*Refresh*).
5. Close `dataset.sql` and open `weeks/week-XX/work.sql` to write your answers!

> **Tip:** Every `dataset.sql` is safe to re-run at any time (`DROP DATABASE IF EXISTS ...; CREATE DATABASE ...;`) if you want a fresh reset.

---

## 4. Troubleshooting

| Error in DBeaver | Fix |
| --- | --- |
| `Public Key Retrieval is not allowed` | Right-click connection → **Edit Connection → Driver properties** → set `allowPublicKeyRetrieval` = `true`. |
| `Access denied for user 'practice'@'%'` | Run `docker compose down -v && docker compose up -d --wait` (or grant privileges as `root`). |
| `No active connection` | Pick your MySQL connection in the toolbar dropdown above the SQL editor before pressing `Alt+X`. |
| New database not showing on the left | Right-click **Databases** in Database Navigator and press **`F5`**. |
