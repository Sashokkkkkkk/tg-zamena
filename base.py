import sqlite3
from datetime import datetime


# ─── Цвета для консоли ───────────────────────────────────────────────────────
class c:
    HEADER    = '\033[95m'
    OKBLUE    = '\033[94m'
    OKGREEN   = '\033[92m'
    WARNING   = '\033[93m'
    FAIL      = '\033[91m'
    ENDC      = '\033[0m'
    BOLD      = '\033[1m'


def print_header(text):
    print(f"\n{c.HEADER}{c.BOLD}{'═' * 70}{c.ENDC}")
    print(f" {text.center(68)} ".center(70))
    print(f"{c.HEADER}{c.BOLD}{'═' * 70}{c.ENDC}\n")


def print_table(title, headers, rows):
    if not rows:
        print(f"{c.WARNING}Нет записей{c.ENDC}")
        return

    widths = [len(h) for h in headers]
    for row in rows:
        for i, v in enumerate(row):
            widths[i] = max(widths[i], len(str(v or '')))

    print(f"\n{c.OKBLUE}{c.BOLD}{title}{c.ENDC}")
    print("  " + "─" * (sum(widths) + len(widths)*3 - 1))
    header = "  " + " │ ".join(f"{h:^{w}}" for h, w in zip(headers, widths))
    print(header)
    print("  " + "─" * (len(header) - 2))

    for row in rows:
        line = "  " + " │ ".join(f"{str(v or ''):{w}}" for v, w in zip(row, widths))
        print(line)
    print()


def main():
    db_file = "carwash_2026.db"
    print(f"{c.OKGREEN}Запуск демонстрации базы автомойки...{c.ENDC}")
    print(f"Файл базы: {db_file}\n")

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()

    # Включаем foreign keys
    cur.execute("PRAGMA foreign_keys = ON")

    # Создание таблиц
    cur.executescript("""
    CREATE TABLE IF NOT EXISTS Услуги (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        название        TEXT NOT NULL UNIQUE,
        цена            REAL NOT NULL,
        категория       TEXT,
        время_мин       INTEGER NOT NULL DEFAULT 30
    );

    CREATE TABLE IF NOT EXISTS Клиенты (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        телефон         TEXT UNIQUE NOT NULL,
        фио             TEXT NOT NULL,
        скидка_процент  INTEGER DEFAULT 0
    );

    CREATE TABLE IF NOT EXISTS Автомобили (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        клиент_id       INTEGER NOT NULL,
        марка           TEXT NOT NULL,
        модель          TEXT,
        госномер        TEXT NOT NULL,
        цвет            TEXT,
        FOREIGN KEY (клиент_id) REFERENCES Клиенты(id),
        UNIQUE (клиент_id, госномер)
    );

    CREATE TABLE IF NOT EXISTS Заказы (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        клиент_id           INTEGER,
        автомобиль_id       INTEGER NOT NULL,
        дата_создания       TEXT NOT NULL,
        планируемая_дата    TEXT,
        статус              TEXT DEFAULT 'Новый',
        итого               REAL DEFAULT 0,
        оплачено            REAL DEFAULT 0,
        способ_оплаты       TEXT,
        комментарий         TEXT,
        FOREIGN KEY (клиент_id)     REFERENCES Клиенты(id),
        FOREIGN KEY (автомобиль_id) REFERENCES Автомобили(id)
    );

    CREATE TABLE IF NOT EXISTS Состав_заказа (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        заказ_id        INTEGER NOT NULL,
        услуга_id       INTEGER NOT NULL,
        количество      INTEGER DEFAULT 1,
        цена_на_момент  REAL NOT NULL,
        FOREIGN KEY (заказ_id)  REFERENCES Заказы(id) ON DELETE CASCADE,
        FOREIGN KEY (услуга_id) REFERENCES Услуги(id)
    );
    """)

    # Заполнение услуг
    cur.execute("SELECT COUNT(*) FROM Услуги")
    if cur.fetchone()[0] == 0:
        cur.executemany(
            "INSERT INTO Услуги (название, цена, категория, время_мин) VALUES (?,?,?,?)",
            [
                ("Мойка кузова стандарт",   750, "кузов",     20),
                ("Мойка + воск",           1200, "кузов",     35),
                ("Чернение резины",         500, "кузов",     15),
                ("Химчистка салона",       4200, "салон",     90),
                ("Комплекс Премиум",       6800, "комплекс", 150),
                ("Мойка двигателя",        1500, "доп",       45),
                ("Антидождь (стёкла)",      950, "доп",       25),
                
            ]
        )

    # Клиенты
    cur.execute("SELECT COUNT(*) FROM Клиенты")
    if cur.fetchone()[0] == 0:
        cur.executemany(
            "INSERT INTO Клиенты (телефон, фио, скидка_процент) VALUES (?,?,?)",
            [
                ("+79161234567", "Нестеров Александр Викторович", 10),
                ("+79252345678", "Кравцова Ольга Сергеевна",       0),
                ("+79033456789", "Пономарёв Дмитрий Андреевич",    5),
                ("+79264567890", "Соколова Екатерина Михайловна",  0),
            ]
        )

    # Автомобили
    cur.execute("SELECT COUNT(*) FROM Автомобили")
    if cur.fetchone()[0] == 0:
        cur.execute("SELECT id FROM Клиенты ORDER BY id LIMIT 4")
        client_ids = [r[0] for r in cur.fetchall()]

        autos = [
            (client_ids[0], "Toyota", "Camry",     "А123ВС 777", "чёрный"),
            (client_ids[1], "BMW",    "X5",       "О456МР 199", "белый"),
            (client_ids[2], "Kia",    "Sportage", "К789АН 777", "серый"),
            (client_ids[3], "Hyundai","Tucson",   "Е112КО 777", "синий"),
        ]
        cur.executemany(
            "INSERT INTO Автомобили (клиент_id, марка, модель, госномер, цвет) VALUES (?,?,?,?,?)",
            autos
        )

    conn.commit()

    # Добавляем заказы (всегда добавляем новые, чтобы было видно)
    today = datetime.now().strftime("%Y-%m-%d %H:%M")

    cur.execute("SELECT id FROM Автомобили ORDER BY id LIMIT 4")
    auto_ids = [r[0] for r in cur.fetchall()]

    заказы = [
        (1, auto_ids[0], today, today, "В работе",     1950, "Карта",     "Срочно"),
        (2, auto_ids[1], today, None,   "Новый",       6800, "СБП",       None),
        (3, auto_ids[2], today, None,   "Готов",       4700, "Наличные",  None),
        (4, auto_ids[3], today, today,  "Запланировано",1200, None,       "На 14:00 завтра"),
    ]

    cur.executemany(
        """
        INSERT INTO Заказы
        (клиент_id, автомобиль_id, дата_создания, планируемая_дата, статус, итого, способ_оплаты, комментарий)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """,
        заказы
    )

    conn.commit()

    # Получаем свежие id заказов
    cur.execute("SELECT id FROM Заказы ORDER BY id DESC LIMIT 4")
    order_ids = [r[0] for r in cur.fetchall()][::-1]  # в порядке создания

    # Состав заказов
    состав = [
        # Заказ 1
        (order_ids[0], 1, 1,  750),   # стандарт
        (order_ids[0], 3, 1,  500),   # чернение
        # Заказ 2
        (order_ids[1], 5, 1, 6800),   # премиум
        # Заказ 3
        (order_ids[2], 4, 1, 4200),   # химчистка
        (order_ids[2], 7, 1,  950),   # антидождь → но цена 500 для примера
        # Заказ 4
        (order_ids[3], 2, 1, 1200),   # мойка + воск
    ]

    cur.executemany(
        "INSERT INTO Состав_заказа (заказ_id, услуга_id, количество, цена_на_момент) VALUES (?,?,?,?)",
        состав
    )

    # Пересчитываем итого в заказах
    cur.execute("""
        UPDATE Заказы
        SET итого = (
            SELECT SUM(количество * цена_на_момент)
            FROM Состав_заказа
            WHERE заказ_id = Заказы.id
        )
        WHERE id IN (SELECT id FROM Заказы)
    """)

    conn.commit()

    # ─── Вывод результатов ───────────────────────────────────────────────────────

    print_header("УСЛУГИ")
    cur.execute("SELECT id, название, цена, категория FROM Услуги ORDER BY id")
    print_table("УСЛУГИ", ["ID", "Название", "Цена", "Категория"], cur.fetchall())

    print_header("КЛИЕНТЫ")
    cur.execute("SELECT id, телефон, фио, скидка_процент FROM Клиенты")
    print_table("КЛИЕНТЫ", ["ID", "Телефон", "ФИО", "Скидка %"], cur.fetchall())

    print_header("АВТОМОБИЛИ")
    cur.execute("""
        SELECT a.id, c.фио, a.марка || ' ' || a.модель, a.госномер, a.цвет
        FROM Автомобили a
        JOIN Клиенты c ON a.клиент_id = c.id
    """)
    print_table("АВТОМОБИЛИ", ["ID", "Владелец", "Авто", "Госномер", "Цвет"], cur.fetchall())

    print_header("ЗАКАЗЫ")
    cur.execute("""
        SELECT z.id, c.фио, a.марка || ' ' || a.модель, z.статус, z.итого, z.способ_оплаты
        FROM Заказы z
        JOIN Клиенты c ON z.клиент_id = c.id
        JOIN Автомобили a ON z.автомобиль_id = a.id
        ORDER BY z.id DESC
    """)
    print_table("ЗАКАЗЫ", ["№", "Клиент", "Авто", "Статус", "Сумма ₽", "Оплата"], cur.fetchall())

    print_header("СОСТАВ ЗАКАЗОВ (детализация)")
    cur.execute("""
        SELECT 
            sz.заказ_id,
            u.название,
            sz.количество,
            sz.цена_на_момент,
            sz.количество * sz.цена_на_момент AS сумма
        FROM Состав_заказа sz
        JOIN Услуги u ON sz.услуга_id = u.id
        ORDER BY sz.заказ_id, sz.id
    """)
    print_table("СОСТАВ ЗАКАЗОВ", ["Заказ", "Услуга", "Кол-во", "Цена", "Сумма"], cur.fetchall())

    conn.close()

    print(f"\n{c.OKGREEN}Готово! База создана и заполнена.{c.ENDC}")
    input("\nНажмите Enter для завершения...")


if __name__ == "__main__":
    main()