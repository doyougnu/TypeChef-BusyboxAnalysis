# How to Run the Logging

1. [Do this once] Setup a [h2 database](http://h2database.com/html/main.html) if you want to run the database logging.
   If you need help with that let me know, I kept a document somewhere on how I did that. Afterwards you should have a database file somewhere.
2. [Do this once] Open `TypeChef/FeatureExprLib/src/main/resources/application.conf` and add a profile for your database.
   You may copy and adapt the following profile that you will also find in that file:

    ```conf
    h2localhostpaul = {
        url = "jdbc:h2:/mnt/c/Users/Paul Bittner/Documents/Software/VSAT/typechefqueries"
        driver = org.h2.Driver
        connectionPool = disabled
        keepAliveConnection = true
        user = "sa"
        password = "vsat"
    }
    ```

   It should only be necessary for you to change the fields `url`, `user`, and `password`.
   (It was really just the same url as we had in code but when putting it into application.conf, it magically worked 🤷‍♂️.)

3. Open `TypeChef/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATMissionControl.scala`. On top of the `VSATMissionControl` object you will find settings:

    ```scala
    /// Configure the logging here.
    private val withTextBasedLogging : Boolean = true;
    private val withDatabaseLogging : Boolean = false;
    val DEBUG : Boolean = false; // Will print more information (mostly used for database logging)
    ```

   Configure as you need.
   You can run any combination of text-based and database logging (none, one, or both).

4. Make sure you don't have an h2 server running or the database file opened externally.
   Otherwise you will get an `IO Exception` when running the logging.

5. Go to the directory of the repository `TypeChef-BusyboxAnalysis` in your terminal (i.e., `cd` to it).
   Before running the logging, consider the following:

   * **BEWARE**: When you use database logging, it **will drop the tables `QUERIES` and          `FEATUREMODELS`** in the database you specified earlier!
   If you dont want this to happen, either copy your database or rename the tables!
   * **BEWARE**: When starting logging (independent of text or database) the directory `VSAT_metadata` will be deleted.
   This will remove any data from text-based logging.

   To start the logging, run `VsatRunQueryLogging.sh`.
   This will take a while.
   `VsatRunQueryLogging.sh` will compile TypeChef, remove all existing logging data (stored in the directory `VSAT_metadata`), run `cleanBusybox.sh` and then run `analyzeBusybox.sh`.

6. Pray for no exceptions.
