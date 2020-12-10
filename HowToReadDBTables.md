# How to Read the Database Tables

The [logging](HowToRunVSATLogging.md), will create the tables `QUERIES` and `FEATUREMODELS`.

## QUERIES

The `QUERIES` table is created in the following way:
```sql
CREATE TABLE QUERIES (
    formula varchar(max) NOT NULL,
    fmhash varchar(255) NOT NULL,
    mode varchar(50) NOT NULL,
    tcCacheHits int NOT NULL,
    dbCacheHits int NOT NULL,
    sentToSAT bool NOT NULL,
    CONSTRAINT pkey PRIMARY KEY(formula, fmhash, mode)
    );
```
Meanings of columns:
- _formula_: The formula of the query as text.
- _fmhash_: A hash identifying the feature model under which feature model the _formula_ was queried.
The _fmhash_ is the primary key for the `FEATUREMODELS` table.
If there was no such feature model, this field is set to `NoFeatureModel`.
(Note: There is not entry for `NoFeatureModel` in table `FEATUREMODELS`.)
- _mode_: The mode under which the query was made.
One of `Unknown`, `ArgParse`, `Lexing`, `Parsing`, `TypeChecking`.
- _tcCacheHits_: The number of cache hits we got from TypeChef's caching.
If this is `0`, the formula was only passed to `isSatisfiable` once.
Cache hits occur when a `isSatisfiable` is invoked on `SATFeatureExpr` for the same feature model twice ([click here to look](https://github.com/doyougnu/TypeChef/blob/827ec8789436bbcde970383c40d2754541b787da/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/SATFeatureExpr.scala#L160)).
- _dbCacheHits_: It happens that TypeChef's has a cache miss on a formula but we already have this formula in our database (w.r.t. to primary key).
When this happens, we increment _dbCacheHits_ which has an initial value of `0`.
This means, the formula of this row had _tcCacheHits_ cache hits in TypeChef and was considered a novel formula _dbCacheHits_ + 1 times.
The current hypothesis is that this might happen because TypeChef may lose its cache inbetween different runs of the `main` method whereas the database is persistent between runs.
- _sentToSAT_: Some formulas are so easy to solve that TypeChef solves them immediately (e.g., for _true_, _false_, and literals without feature model).
_sentToSAT_ is true iff the formula was delegated to a sat solver by TypeChef.
Thus, _sentToSAT_ is false iff the formula was easy enough to be solved by TypeChef directly.

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
- _hash_: The primary key that is used for referencing feature models from within the `QUERIES` table.
The current implementation for that has is `fm.toString()` in TypeChef which produces the default Java string hash for objects.
- _formula_: The feature model as a propositional formula similar to the `formula` column in the `QUERIES`.