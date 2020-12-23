# How to Run the Logging

1. [Do this once] Setup a [h2 database](http://h2database.com/html/main.html) if you want to run the database logging.
   On windows I just opened the h2 browser interface and connected to the database I wanted to create.
   I entered the url under which I wanted to have the database and entered credentials under which that database should be accessible.
   When connecting to that (not yet existing) database, it was created automatically by h2.
   Afterwards you should have a database file somewhere.
2. [Do this once] Open `TypeChef/FeatureExprLib/src/main/resources/application.conf` and add a profile for your database.
   You may copy and adapt the following profiles that you will also find in that file:

    ```conf
   h2paulbusybox = {
      url = "jdbc:h2:/mnt/c/Users/Paul Bittner/Documents/Software/VSAT/busybox"
      driver = org.h2.Driver
      connectionPool = disabled
      keepAliveConnection = true
      user = "sa"
      password = "vsat"
   }

   h2paullinux = {
      url = "jdbc:h2:/mnt/c/Users/Paul Bittner/Documents/Software/VSAT/linux"
      driver = org.h2.Driver
      connectionPool = disabled
      keepAliveConnection = true
      user = "sa"
      password = "vsat"
   }
    ```

   For different test subjects (linux and busybox) I use separate databases to avoid overwriting any existing data (on accident).
   It should only be necessary for you to change the fields `url`, `user`, and `password`.
   (It was really just the same url as we had in code but when putting it into application.conf, it magically worked 🤷‍♂️.)

3. Go to `TypeChef/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATMissionControl.scala`.
   On top of the `VSATMissionControl` object you will find settings:

    ```scala
    /// Configure the logging here.
    private val withTextBasedLogging : Boolean = true;
    private val withDatabaseLogging : Boolean = false;
    val DEBUG : Boolean = false; // Will print more information (mostly used for database logging)
    ```

   Configure as you need.
   You can run any combination of text-based and database logging (none, one, or both).

4. If you want to run database logging, go to `TypeChef/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATDatabase.scala` and configure the following:

   ```scala
   // Select the database profile in application.conf that you want to use.
   private val databaseProfileToUse : String =
        "h2paullinux"
   //   "h2paulbusybox"
        ;

   /**
    * If set to true, the tables SATQUERIES, BDDQUERIES, ERRORS, and FEATUREMODELS will be dropped at the beginning of development.
    * This is necessary to get correct results when starting the logging.
    * Running the logging twice with this being set to false yields wrong data (e.g. too many cache hits on queries).
    * Set this to false if you want to rerun the logging for specific files.
    * If in doubt, leave unchanged or ask Paul.
    */
   private val dropExistingTablesOnFirstRun : Boolean = true;
   ```

5. Make sure you don't have an h2 server running or the database file opened externally.
   Otherwise you will get an `IO Exception` when running the logging.

6. Go to the directory of the repository `TypeChef-BusyboxAnalysis` in your terminal (i.e., `cd` to it).
   Before running the logging, consider the following:

   * **BEWARE**: When you use database logging, it **will drop all the tables `SATQUERIES`, `BDDQUERIES`, `ERRORS` and `FEATUREMODELS`** in the database you specified earlier!
   If you dont want this to happen, either copy your database or rename the tables!
   * **BEWARE**: When starting logging (independent of text or database) the directory `VSAT_metadata` will be deleted.
   This will remove any data from text-based logging.

   To start the logging, run `VsatRunQueryLogging.sh` (or `linux26333/VsatRunQueryLogging.sh` when using the linux dataset).
   This will take a while.
   `VsatRunQueryLogging.sh` will compile TypeChef, remove all existing logging data (stored in the directory `VSAT_metadata`), run `cleanBusybox.sh` (or equivalend file on the linux subject) and then run `analyzeBusybox.sh` (or the corresponding linux script).

7. If any errors occur during the logging, it will continue to run either way because these errors occur in TypeChef which then is just restarted afterwards on the next test subject file.
You will find all errors in the `ERRORS` table in your database.