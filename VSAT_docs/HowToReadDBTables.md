# How to Read the Database Tables

The [logging](HowToRunVSATLogging.md), will create the tables `SATQUERIES`, `BDDQUERIES`, `FEATUREMODELS` and `ERRORS`.

## SATQUERIES

The `SATQUERIES` table is created in the following way:
```sql
CREATE TABLE SATQUERIES (
    formula varchar(max) NOT NULL,
    fmhash varchar(255) NOT NULL,
    file varchar(255) NOT NULL,
    mode varchar(50) NOT NULL,
    tcCacheHits int NOT NULL,
    dbCacheHits int NOT NULL,
    sentToSAT bool NOT NULL,
    PRIMARY KEY(formula, fmhash, file, mode)
    );
```
Meanings of columns:
- _formula_: The formula of the query as text.
- _fmhash_: A hash identifying the feature model under which the _formula_ was queried.
The _fmhash_ is the primary key for the `FEATUREMODELS` table.
If there was no such feature model, this field is set to `NoFM`.
(Note: There is no entry for `NoFM` in table `FEATUREMODELS`.)
- _file_: The file that was processed when this query was made. For each file of the target system (e.g., linux or busybox), TypeChef is invoked once. So its restarted inbetween files and loses its cache.
- _mode_: The mode under which the query was made.
Modes are explained [here](./WhatAreTheModes.md).
- _tcCacheHits_: The number of cache hits we got from TypeChef's caching.
If this is `0`, the formula was only passed to `isSatisfiable` once.
Cache hits occur when `isSatisfiable` is invoked on a `SATFeatureExpr` for the same feature model twice ([here](https://github.com/doyougnu/TypeChef/blob/d01738eab427ef7425018e6797d990f0ee14d24b/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/SATFeatureExpr.scala#L160)).
- _dbCacheHits_: It can happen that TypeChef has a cache miss on a formula but we already have this formula in our database (w.r.t. primary key).
When this happens, we increment _dbCacheHits_ which has an initial value of `0`.
This means, the formula of this row had _tcCacheHits_ cache hits in TypeChef and was considered a novel formula _dbCacheHits_ + 1 times.
The current hypothesis is that this might happen because TypeChef may lose its cache inbetween different runs of the `main` method whereas the database is persistent between runs.
However, we experienced that this can also happen within a single run of TypeChef.
- _sentToSAT_: Some formulas are so easy to solve that TypeChef solves them immediately (e.g., for _true_, _false_, and literals without feature model).
_sentToSAT_ is true iff the formula was delegated to a sat solver by TypeChef.
_sentToSAT_ is false iff the formula was easy enough to be solved by TypeChef directly.

So for a row _(formula, fm, file, mode, tc, db, sat)_ in `SATQUERIES` we know that
- _formula_ was checked for satisfiability in conjunction with _fm_ under _mode_ when processing the file _file_.
- _formula and fm_ was sent to the sat solver iff _sat_.
- if _sat_ is true, then _formula_ was asked for satisfiability with _fm_ in _mode_ exactly _1 + tc + db_ times during the run on _file_.
  Once because the row exists.
  Once for every cache hit in TypeChef _tc_.
  Once for every cache miss in TypeChef when the formula was already in `SATQUERIES` _db_ (w.r.t. to primary keys).

To get the total number of times _SAT(p and fm)_ was called for a formula _p_ and feature model _fm_ (disregarding the mode and the file), do the following (This should probably be done in a single `SELECT` query):
- Delete all rows where `sentToSAT == false` because these rows were not sent to the SAT solver.
- Delete columns _file_ and _mode_.
  This will result in duplicate entries as _file_ and _mode_ were part of the primary key.
  The new primary key will be  _(formula, fmhash)_.
- Merge each duplicate rows (w.r.t. the new primary key) by summing their _tcCacheHit_ and _dbCacheHit_ properties.
  _sentToSAT_ will be equal automatically because there are only rows with `sentToSAT == true` at this step.
- Now, for each row we know that
  - _formula_ was asked for satisfiability with _fm_ exactly _1 + tc + db_ times across modes and runs.
  - TypeChef had _tc_ cache hits on that formula across all modes.

This process can also repeated with deleting only one of the two columns _file_ or _mode_ to accumulate all queries made for a certain file or all queries made in a certain mode.

## BDDQUERIES

The `BDDQUERIES` table is created in the following way:
```sql
CREATE TABLE BDDQUERIES (
    hash varchar(255) NOT NULL,
    fmhash varchar(255) NOT NULL,
    file varchar(255) NOT NULL,
    mode varchar(50) NOT NULL,
    tcCacheHits int NOT NULL,
    dbCacheHits int NOT NULL,
    sentToSAT bool NOT NULL,
    PRIMARY KEY(hash, fmhash, file, mode)
    );
```
Meanings of columns:
- _hash_: A hash value identifying this BDD. We did not store the exact BDD but only this hash value.
- _fmhash_: A hash identifying the feature model. The exact feature model is not stored in the db though. So this hash is **not** and index into the `FEATUREMODELS` table.
- _file_: same as for `SATQUERIES`
- _mode_: same as for `SATQUERIES`
- _tcCacheHits_: same as for `SATQUERIES`
- _dbCacheHits_: same as for `SATQUERIES`
- _sentToSAT_: same as for `SATQUERIES`

## FEATUREMODELS

The `FEATUREMODELS` table is created in the following way:
```sql
CREATE TABLE FEATUREMODELS (
    hash varchar(255) NOT NULL,
    formula varchar(max) NOT NULL,
    PRIMARY KEY(hash)
    );
```
Meanings of columns:
- _hash_: The primary key that is used for referencing feature models from within the `SATQUERIES` table.
The hash is constructed from two separate hashes: A custom hash on the cnf combined (via `_`) with the hashcode of the string representation of that feature model.
The hash function is implemented [here](https://github.com/doyougnu/TypeChef/blob/d01738eab427ef7425018e6797d990f0ee14d24b/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATMissionControl.scala#L150).
- _formula_: The feature model as a propositional formula similar to the `formula` column in the `SATQUERIES`.


## ERRORS

The `ERRORS` table is created in the following way:
```sql
CREATE TABLE ERRORS (
    file varchar(255) NOT NULL,
    no int NOT NULL,
    message varchar(max) NOT NULL,
    stacktrace varchar(max),
    PRIMARY KEY(file, no)
    );
```
Meanings of columns:
- _file_: The file that was processed by TypeChef when the error occured.
If we have a crucial error on a file, we likely should invalidate all SAT and BDD queries made when processing that file. Alternatively, that file could be re-evaluated with TypeChef. (But do not do so naively or the existing tables might be dropped!)
- _no_: This is the _no_'th error when processing the file. For each file, _no_ starts by zero and is increased by one whenever an error occurs.
- _message_: Information on the error.
- _stacktrace_: Stack Trace of the error in TypeChef. Unfortunately this is often useless because the errors likely occur within _anonymous functions_ or _futures_ in other threads.