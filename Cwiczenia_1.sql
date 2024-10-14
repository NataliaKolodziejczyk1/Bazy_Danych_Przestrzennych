-- 1. Utwórz nową bazę danych nazywając ją firma.
CREATE DATABASE firma;

-- 2. Dodaj schemat o nazwie ksiegowosc.
CREATE SCHEMA ksiegowosc;

-- 3. Dodaj cztery tabele

CREATE TABLE pracownicy(
id_pracownika INT PRIMARY KEY,
imie VARCHAR(30),
nazwisko VARCHAR(50),
adres VARCHAR(255),
telefon VARCHAR(9)
);

COMMENT ON TABLE pracownicy IS 'Tabela zawierajaca podstawowe informacje o pracownikach';

CREATE TABLE godziny(
id_godziny INT PRIMARY KEY,
data DATE,
liczba_godzin INT,
id_pracownika INT,
FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika)
);

COMMENT ON TABLE godziny IS 'Tabela zawierajaca informacje o liczbie przepracowanych godzin przez pracownika w danym miesiącu';

CREATE TABLE pensja(
id_pensji INT PRIMARY KEY,
stanowisko VARCHAR(50),
kwota DECIMAL(7,2)
);

COMMENT ON TABLE pensja IS 'Tabela zawierajaca informacje o pensji na danym stanowisku';

CREATE TABLE premia(
id_premii INT PRIMARY KEY,
rodzaj VARCHAR(50),
kwota DECIMAL(6,2)
);

COMMENT ON TABLE premia IS 'Tabela zawierajaca informacje o mozliwych premiach';

CREATE TABLE wynagrodzenie(
id_wynagrodzenia INT PRIMARY KEY,
data DATE,
id_pracownika INT,
id_godziny INT,
id_pensji INT,
id_premii INT,
FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika),
FOREIGN KEY (id_godziny) REFERENCES godziny(id_godziny),
FOREIGN KEY (id_pensji) REFERENCES pensja(id_pensji),
FOREIGN KEY (id_premii) REFERENCES premia(id_premii)
);

COMMENT ON TABLE wynagrodzenie IS 'Tabela zawierajaca informacje o wynagrodzeniu pracownika w danym miesiacu, uwzgledniajac wszystkie potrzebne informacje';

-- 4. Wypełnij każdą tabelę 10. rekordami. 

INSERT INTO pracownicy (id_pracownika, imie, nazwisko, adres, telefon)
VALUES
(1, 'Jan', 'Kowalski', 'ul. Królewska 1, Kraków', '123456789'),
(2, 'Anna', 'Nowak', 'ul. Władysława Reymonta 2, Kraków', '987654321'),
(3, 'Piotr', 'Wiśniewski', 'ul. Doktora Tomasza Żywca 3, Wieliczka', '555555555'),
(4, 'Katarzyna', 'Wójcik', 'ul. Św. Wawrzyńca 4, Kraków', '444444444'),
(5, 'Tomasz', 'Kozłowski', 'ul. Kobierzyńska 5, Kraków', '333333333'),
(6, 'Maria', 'Zielińska', 'ul. Gromadzka 6, Kraków', '222222222'),
(7, 'Michał', 'Szymański', 'ul. Na Grobli 7, Niepołomice', '111111111'),
(8, 'Joanna', 'Dąbrowska', 'ul. Akacjowa 8, Niepołomice', '666666666'),
(9, 'Adam', 'Pawlak', 'ul. Centralna 9, Wielka Wieś', '777777777'),
(10, 'Magdalena', 'Krawczyk', 'ul. Polna 10, Zabierzów', '888888888');

INSERT INTO godziny (id_godziny, data, liczba_godzin, id_pracownika)
VALUES
(1, '2024-09-30', 160.00, 1),
(2, '2024-09-30', 152.00, 2),
(3, '2024-09-30', 170.00, 3),
(4, '2024-09-30', 165.00, 4),
(5, '2024-09-30', 150.00, 5),
(6, '2024-09-30', 140.00, 6),
(7, '2024-09-30', 175.00, 7),
(8, '2024-09-30', 180.00, 8),
(9, '2024-09-30', 155.00, 9),
(10, '2024-09-30', 160.00, 10);

INSERT INTO pensja (id_pensji, stanowisko, kwota)
VALUES
(1, 'Kierownik', 9000.00),
(2, 'Inżynier', 6500.00),
(3, 'Asystent', 4000.00),
(4, 'Księgowy', 5000.00),
(5, 'Programista', 8000.00),
(6, 'Sprzedawca', 3000.00),
(7, 'Student', 1000.00),
(8, 'Sekretarz', 3500.00),
(9, 'Magazynier', 2800.00),
(10, 'Mechanik', 4500.00);

INSERT INTO premia (id_premii, rodzaj, kwota)
VALUES
(1, 'Brak', 0.00),
(2, 'Roczne', 2000.00),
(3, 'Motywacyjna', 500.00),
(4, 'Uznaniowa', 800.00),
(5, 'Lojalnościowa', 1500.00),
(6, 'Za wyniki', 1200.00),
(7, 'Nadgodziny', 500.00),
(8, 'Projektowa', 900.00),
(9, 'Okolicznościowa', 400.00),
(10, 'Dodatkowa', 600.00);

INSERT INTO wynagrodzenie (id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii)
VALUES
(1, '2024-10-10', 1, 1, 1, 1),
(2, '2024-10-10', 2, 2, 5, 2),
(3, '2024-10-10', 3, 3, 4, 1),
(4, '2024-10-10', 4, 4, 4, 1),
(5, '2024-10-10', 5, 5, 5, 5),
(6, '2024-10-10', 6, 6, 1, 6),
(7, '2024-10-10', 7, 7, 7, 1),
(8, '2024-10-10', 8, 8, 8, 8),
(9, '2024-10-10', 9, 9, 9, 9),
(10, '2024-10-10', 10, 10, 10, 10);

-- 5. Wykonaj następujące zapytania: 

-- a) Wyświetl tylko id pracownika oraz jego nazwisko.  

SELECT id_pracownika, nazwisko 
FROM pracownicy;

-- b) Wyświetl id pracowników, których płaca jest większa niż 1000. 

SELECT w.id_wynagrodzenia
FROM wynagrodzenie AS w
LEFT JOIN premia AS pr ON w.id_premii = pr.id_premii 
LEFT JOIN pensja AS pe ON w.id_pensji = pe.id_pensji 
WHERE pe.kwota + pr.kwota > 1000;

-- c) Wyświetl id pracowników nieposiadających premii, których płaca jest większa niż 2000.  

SELECT id_pracownika
FROM wynagrodzenie
WHERE id_premii IN (
SELECT id_premii
FROM premia
WHERE rodzaj = 'Brak' ) AND id_pensji IN (
SELECT id_pensji
FROM pensja
WHERE kwota > 2000);

-- d) Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’.

SELECT id_pracownika, imie, nazwisko
FROM pracownicy
WHERE imie LIKE 'J%';

-- e) Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’. 

SELECT id_pracownika, imie, nazwisko
FROM pracownicy
WHERE nazwisko SIMILAR TO '%(n|N)%' AND imie LIKE '%a';

-- f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie.  

SELECT p.imie, p.nazwisko, GREATEST(g.liczba_godzin - 160, 0) AS nadgodziny
FROM pracownicy p
LEFT JOIN godziny g ON p.id_pracownika = g.id_pracownika 


-- g) Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000 PLN.  

SELECT pr.imie, pr.nazwisko, pe.kwota
FROM wynagrodzenie w
LEFT JOIN pracownicy pr ON w.id_pracownika = pr.id_pracownika
LEFT JOIN pensja pe ON pe.id_pensji = w.id_pensji
WHERE pe.kwota BETWEEN 1500 AND 3000;

-- h) Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.  

SELECT pr.imie, pr.nazwisko
FROM pracownicy pr
LEFT JOIN godziny g ON pr.id_pracownika = g.id_pracownika
WHERE g.liczba_godzin > 160 AND pr.id_pracownika IN (
SELECT w.id_pracownika
FROM wynagrodzenie w
LEFT JOIN premia p ON p.id_premii = w.id_premii
WHERE p.rodzaj = 'Brak'
);

-- i) Uszereguj pracowników według pensji. 

SELECT pr.imie, pr.nazwisko, pe.kwota
FROM wynagrodzenie w
LEFT JOIN pracownicy pr ON pr.id_pracownika = w.id_pracownika
LEFT JOIN pensja pe ON pe.id_pensji = w.id_pensji
ORDER BY pe.kwota;

-- j) Uszereguj pracowników według pensji i premii malejąco. 

SELECT pr.imie, pr.nazwisko, pe.kwota AS pensja, pre.kwota AS premia
FROM wynagrodzenie w
LEFT JOIN pracownicy pr ON pr.id_pracownika = w.id_pracownika
LEFT JOIN pensja pe ON pe.id_pensji = w.id_pensji
LEFT JOIN premia pre ON pre.id_premii = w.id_premii
ORDER BY (pe.kwota, pre.kwota) DESC;

-- k) Zlicz i pogrupuj pracowników według pola ‘stanowisko’. 

SELECT pe.stanowisko, COUNT(pr.id_pracownika) AS ilosc_na_danym_stanowisku
FROM wynagrodzenie w
LEFT JOIN pracownicy pr ON pr.id_pracownika = w.id_pracownika
LEFT JOIN pensja pe ON pe.id_pensji = w.id_pensji
GROUP BY pe.stanowisko;

-- l) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij dowolne inne).

SELECT pe.stanowisko, AVG(pe.kwota + pr.kwota) AS srednia, MIN(pe.kwota + pr.kwota) AS minimalna, MAX(pe.kwota + pr.kwota) AS maksymalna
FROM wynagrodzenie w
LEFT JOIN premia pr ON pr.id_premii = w.id_premii
LEFT JOIN pensja pe ON pe.id_pensji = w.id_pensji
WHERE pe.stanowisko = 'Kierownik'
GROUP BY pe.stanowisko;

-- m) Policz sumę wszystkich wynagrodzeń. 

SELECT SUM(pr.kwota+pe.kwota) AS suma_wynagrodzen
FROM wynagrodzenie w
LEFT JOIN pensja pe ON w.id_pensji = pe.id_pensji
LEFT JOIN premia pr ON w.id_premii = pr.id_premii;

-- f) Policz sumę wynagrodzeń w ramach danego stanowiska.  

SELECT pe.stanowisko, SUM(pr.kwota+pe.kwota) AS suma_wynagrodzen
FROM wynagrodzenie w
LEFT JOIN pensja pe ON w.id_pensji = pe.id_pensji
LEFT JOIN premia pr ON w.id_premii = pr.id_premii
GROUP BY pe.stanowisko;

-- g) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.  

SELECT pe.stanowisko, COUNT(w.id_premii) AS liczba_premii
FROM wynagrodzenie w
LEFT JOIN pensja pe ON w.id_pensji = pe.id_pensji
LEFT JOIN premia pr ON w.id_premii = pr.id_premii
WHERE pr.rodzaj != 'Brak'
GROUP BY pe.stanowisko;

--h) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.
DELETE FROM wynagrodzenie WHERE id_pracownika IN (
SELECT w.id_pracownika
FROM wynagrodzenie w
LEFT JOIN pensja pe ON pe.id_pensji = w.id_pensji
WHERE pe.kwota < 1200
);
