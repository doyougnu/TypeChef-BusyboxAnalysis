# How to run the logging

1. [Do this once] Setup a [h2 database](http://h2database.com/html/main.html) if you want to run the database logging.
   If you need help with that let me know, I kept a document somewhere on how I did that. Afterwards you should have a database file somewhere.
2. [Do this once] Open `TypeChef/FeatureExprLib/src/main/resources/application.conf` and add a profile for your database.
   You may copy and adapt the following profile that you will also find in that file:

    ```
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

    ```
    /// Configure the logging here.
    private val withTextBasedLogging : Boolean = true;
    private val withDatabaseLogging : Boolean = false;
    val DEBUG : Boolean = false; // Will print more information (mostly used for database logging)
    ```

   Configure as you need.
   You can run any combination of text-based and database logging (none, one, or both).

4. Make sure you don't have a h2 server running or the database file opened externally.
   Otherwise you will get an `IO Exception` when running the logging.

5. Go to the directory of the repository `TypeChef-BusyboxAnalysis` in your terminal (i.e., `cd` to it).
    Then run `VsatRunQueryLogging.sh`.
    It will compile TypeChef, remove all existing logging data (stored in the directory `VSAT_metadata`), run `cleanBusybox.sh` and then run `analyzeBusybox.sh`.

6. Pray for no exceptions.
