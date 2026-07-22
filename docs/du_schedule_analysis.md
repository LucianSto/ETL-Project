# Analiza sursei de date - DU Exam & Absence Schedule

## Scop

Acest document descrie analiza fisierului sursa utilizat pentru procesul ETL.

Obiectivul este intelegerea structurii datelor, identificarea eventualelor probleme de calitate si definirea transformarilor necesare inainte de incarcarea datelor in modelul dimensional.

---

# Informatii despre sursa

Nume fisier:
DUExamAbsenceSchedule.csv

Tip sursa:
Fisier CSV

Descriere:

Fisierul contine activitatea zilnica a angajatilor referitoare la examenele Delivery Unit si absente.

---

# Structura fisierului

Fisierul este format din doua categorii de coloane.

## Informatii despre angajat

- EmployeeId
- EmployeeName
- Grade
- Discipline
- LineManager
- DeliveryUnit

## Activitatea zilnica

Restul coloanelor reprezinta zile calendaristice.

Exemplu:

- 01-Jun
- 02-Jun
- 03-Jun
- ...

Fiecare celula contine codul activitatii pentru ziua respectiva.

Exemple de coduri identificate:

- W
- TR
- EX

---

# Observatii

In urma analizei fisierului au fost observate urmatoarele:

- fisierul este organizat in format matrice;
- fiecare coloana reprezinta o zi calendaristica;
- fiecare rand reprezinta un angajat;
- activitatea este memorata sub forma unor coduri;
- pentru modelul dimensional este necesara transformarea datelor intr-un format tabelar.

---

# Transformarea necesara

Datele trebuie transformate din formatul:

Employee | 01-Jun | 02-Jun | 03-Jun

in formatul:

Employee | ActivityDate | ActivityCode

Aceasta transformare va fi realizata in etapa de Staging prin operatia UNPIVOT.

---

# Fluxul ETL

CSV

↓

Source

↓

Staging
(Curatare + Transformare)

↓

Target
(Star Schema)

