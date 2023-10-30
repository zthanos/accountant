# Pending work

### Έσοδα

- ~~**Μετατροπή σε compontent του pager**:~~
-  - ~~Ο pager παιρνει σαν input τις χρονιές από τη λίστα των κινήσεων.~~
   - ~~Αποτελείτε από 4 χρονιές και 2 κουμπιά για την κίλυση της μπάρας σε προηγούμενα επόμενα χρόνια.~~
   - ~~Μεταφορά σε ĺive component~~
- ~~**Active state**: Ανάλογα με ποια χρονιά ειναι επιλεγμένη να φαίνεται αναμένο το αντίστοιχο κουμπί.~~
- ~~**Σύνολα στο footer**: Σύνολα ανά κατηγορία, γενικό σύνολο.~~
- **Φόρμα καταχώρισης κίνησης**: 
  - Δημιουργία φόρμας καταχώρισης και επεξεργασίας κινήσεων.
  - με τα αντίστοιχα validations.
- ~~**Μεταφορά δεδομένων σε βάση**:~~ 
  - ~~Δημιουργία πίνακα *IncomeTransactions* στην Postgres.~~
  - ~~Δημιουργία context module~~
  - ~~mix phx.gen.context Transactions Transaction transactions description:string transaction_date:naive_datetime sales_category:string invoice_type:string invoice_number:string net_amount:string  vat_rate:string vat_amount:string gross_amount:string~~
  - mix phx.gen.context Gists Gist gists user_id:references:users name:string description:text markup_text:text
  - ~~Import income transactions to db~~ 
- **Ανάγνωση στοιχείων από DB:**
