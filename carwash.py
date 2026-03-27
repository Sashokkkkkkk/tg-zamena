import sqlite3
from datetime import date

# ─────────────────────────────────────────
#  1. Создаём базу и заполняем тестовыми данными
# ─────────────────────────────────────────

conn = sqlite3.connect(":memory:")   # :memory: — база живёт в ОЗУ (для теста)
cur = conn.cursor()

cur.executescript("""
-- Клиенты
CREATE TABLE clients (
    id   INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Автомобили  
CREATE TABLE cars (
    id         INTEGER PRIMARY KEY,
    client_id  INTEGER REFERENCES clients(id),
    plate      TEXT NOT NULL   -- гос. номер
);

-- Услуги мойки
CREATE TABLE washes (
    id         INTEGER PRIMARY KEY,
    car_id     INTEGER REFERENCES cars(id),
    wash_date  TEXT NOT NULL,  -- 'YYYY-MM-DD'
    price      REAL NOT NULL
);

-- Тестовые данные
INSERT INTO clients VALUES
    (1, 'Иванов Иван'),
    (2, 'Петрова Мария'),
    (3, 'Сидоров Алексей');

INSERT INTO cars VALUES
    (1, 1, 'А123БВ'),
    (2, 1, 'Е456КМ'),
    (3, 2, 'Х789УО'),
    (4, 3, 'В001НН');

INSERT INTO washes VALUES
    (1,  1, '2025-03-27', 500),
    (2,  1, '2025-03-27', 800),
    (3,  2, '2025-01-10', 300),
    (4,  3, '2025-02-14', 1200),
    (5,  3, '2025-03-27', 700),
    (6,  4, '2024-12-01', 400),
    (7,  4, '2024-12-15', 400),
    (8,  4, '2025-01-05', 400),
    (9,  1, '2025-03-20', 600),
    (10, 2, '2025-03-01', 900);
""")

today = date.today().isoformat()   # '2025-03-27'

print("=" * 55)
print("  ТЕСТОВЫЕ ЗАПРОСЫ — АВТОМОЙКА")
print("=" * 55)


# ─────────────────────────────────────────
#  ЗАПРОС 1: Клиент с наибольшей суммой заказов
# ─────────────────────────────────────────
print("\n── Запрос 1: клиент с наибольшей суммой ──")

query1 = """
SELECT
    c.name          AS Клиент,
    SUM(w.price)    AS Сумма
FROM clients c
JOIN cars    ca ON ca.client_id = c.id
JOIN washes  w  ON w.car_id     = ca.id
GROUP BY c.id, c.name
ORDER BY Сумма DESC
LIMIT 1;
"""

row = cur.execute(query1).fetchone()
print(f"  {row[0]} — {row[1]:.0f} руб.")


# ─────────────────────────────────────────
#  ЗАПРОС 2: Все мойки за сегодня
# ─────────────────────────────────────────
print(f"\n── Запрос 2: мойки за сегодня ({today}) ──")

query2 = """
SELECT
    c.name       AS Клиент,
    ca.plate     AS Номер,
    w.price      AS Цена,
    w.wash_date  AS Дата
FROM washes  w
JOIN cars    ca ON ca.id        = w.car_id
JOIN clients c  ON c.id         = ca.client_id
WHERE w.wash_date = ?
ORDER BY w.id;
"""

rows = cur.execute(query2, (today,)).fetchall()
if rows:
    print(f"  {'Клиент':<20} {'Номер':<10} {'Цена':>8}")
    print(f"  {'-'*20} {'-'*10} {'-'*8}")
    for r in rows:
        print(f"  {r[0]:<20} {r[1]:<10} {r[2]:>8.0f} руб.")
else:
    print("  Сегодня моек не было.")


# ─────────────────────────────────────────
#  ЗАПРОС 3: Автомобиль, реже всего мытый в этом году
# ─────────────────────────────────────────
print("\n── Запрос 3: автомобиль реже всего в этом году ──")

query3 = """
SELECT
    ca.plate         AS Номер,
    c.name           AS Владелец,
    COUNT(w.id)      AS Кол_моек
FROM cars    ca
JOIN clients c  ON c.id     = ca.client_id
LEFT JOIN washes w
    ON  w.car_id    = ca.id
    AND strftime('%Y', w.wash_date) = strftime('%Y', 'now')
GROUP BY ca.id, ca.plate, c.name
ORDER BY Кол_моек ASC, ca.id
LIMIT 1;
"""

row = cur.execute(query3).fetchone()
print(f"  Номер: {row[0]}  |  Владелец: {row[1]}  |  Моек в этом году: {row[2]}")


conn.close()
print("\n" + "=" * 55)
