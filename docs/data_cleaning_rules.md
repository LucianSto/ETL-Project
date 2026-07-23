# Reguli de curatare a datelor - DU Exam & Absence Schedule

## Scop

Acest document descrie regulile de curatare care vor fi aplicate asupra fisierului DUExamAbsenceSchedule.csv in etapa de Staging, inainte de incarcarea datelor in modelul dimensional.

---

## Regula 1 - Eliminarea spatiilor inutile

Se vor elimina spatiile de la inceputul si sfarsitul tuturor campurilor text.

Campuri:

- EmployeeId
- EmployeeName
- Grade
- Discipline
- LineManager
- DeliveryUnit
- ActivityCode

---

## Regula 2 - Standardizarea codurilor de activitate

Toate codurile de activitate vor fi transformate in litere mari.

Exemple:

w -> W

tr -> TR

ex -> EX

---

## Regula 3 - Tratarea valorilor goale

Valorile goale sau campurile care contin doar spatii vor fi transformate in NULL.

---

## Regula 4 - Validarea EmployeeId

Fiecare angajat trebuie sa aiba un EmployeeId valid.

Inregistrarile fara EmployeeId vor fi raportate in etapa de validare si nu vor fi incarcate in modelul dimensional.

---

## Regula 5 - Validarea atributelor angajatului

Se verifica existenta urmatoarelor campuri obligatorii:

- EmployeeName
- Grade
- Discipline
- LineManager
- DeliveryUnit

Valorile lipsa vor fi raportate pentru validare.

---

## Regula 6 - Transformarea structurii datelor

Datele vor fi transformate din format matrice in format tabelar.

Structura initiala:

Employee | 01-Jun | 02-Jun | 03-Jun

Structura rezultata:

Employee | ActivityDate | ActivityCode

Transformarea va fi realizata folosind operatia UNPIVOT.

---

## Regula 7 - Conversia datelor calendaristice

Coloanele care reprezinta zile calendaristice vor fi transformate intr-un camp de tip DATE.

---

## Regula 8 - Eliminarea inregistrarilor duplicate

Se va verifica existența eventualelor înregistrări duplicate. Dacă sunt identificate, acestea vor fi analizate înainte de încărcarea în modelul dimensional.

O inregistrare este considerata duplicata daca are aceeasi combinatie:

- EmployeeId
- ActivityDate
- ActivityCode

---

## Regula 9 - Validarea codurilor de activitate

Vor fi acceptate doar codurile de activitate valide existente in sursa.

Codurile necunoscute vor fi raportate pentru validare.

---

## Regula 10 - Pastrarea trasabilitatii datelor

Datele procesate vor pastra informatii despre sursa de provenienta prin utilizarea metadatelor de incarcare conform arhitecturii ETL.
